import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/article_model.dart';
import '../../data/repositories/news_repository.dart';
import '../../core/services/location_service.dart';
import '../../core/services/translation_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';

/// News Provider - manages news data and state
class NewsProvider with ChangeNotifier {
  final NewsRepository _repository = NewsRepository();
  final LocationService _locationService = LocationService();
  final TranslationService _translationService = TranslationService();

  // State
  List<Article> _articles = [];
  List<Article> _allArticles = []; // Full pool of articles
  List<Article> _localArticles = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String _selectedCountry = ApiConstants.defaultCountry;
  String? _currentCity;

  // Pagination
  int _displayedCount = 10; // Start with 10 articles
  bool _hasMore = true;

  // Getters
  List<Article> get articles => _articles;
  List<Article> get localArticles => _localArticles;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  String get selectedCountry => _selectedCountry;
  String? get currentCity => _currentCity;
  bool get hasError => _error != null;
  bool get hasArticles => _articles.isNotEmpty;
  bool get hasMore => _hasMore;

  /// Initialize
  Future<void> init() async {
    await _repository.init();
    await _loadSelectedCountry();
    await _detectLocation();
  }

  /// Load selected country from preferences
  Future<void> _loadSelectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCountry =
        prefs.getString(AppConstants.keySelectedCountry) ??
        ApiConstants.defaultCountry;
  }

  /// Detect user location
  Future<void> _detectLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      _currentCity = location.city;
      _selectedCountry = location.countryCode;

      // Save country preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keySelectedCountry, _selectedCountry);
    } catch (e) {
      // Use default if location detection fails
      _currentCity = null;
    }
  }

  /// Fetch top headlines
  Future<void> fetchTopHeadlines({
    String? category,
    String? language,
    bool forceRefresh = false,
  }) async {
    // Reset pagination when fetching fresh data
    _displayedCount = 10;
    _hasMore = true;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final lang = language ?? ApiConstants.defaultLanguage;

      // Fetch all articles (100)
      _allArticles = await _repository.getTopHeadlines(
        country: _selectedCountry,
        lang: lang,
        category: category,
        forceRefresh: forceRefresh,
      );

      // Translate if needed
      if (lang != 'en' && _allArticles.isNotEmpty) {
        await _translateAllArticles(lang);
      }

      // Display first 10
      _articles = _allArticles.take(_displayedCount).toList();
      _hasMore = _allArticles.length > _displayedCount;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _articles = [];
      _allArticles = [];
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more articles (pagination) - from cached pool
  Future<void> loadMoreArticles() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    // Simulate slight delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Load next 10 from the pool
      _displayedCount += 10;
      _articles = _allArticles.take(_displayedCount).toList();
      _hasMore = _allArticles.length > _displayedCount;
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Search articles
  Future<void> searchArticles({required String query, String? language}) async {
    if (query.trim().isEmpty) {
      _articles = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final lang = language ?? ApiConstants.defaultLanguage;

      _articles = await _repository.searchArticles(
        query: query,
        country: _selectedCountry,
        lang: lang,
      );

      // Translate if needed
      if (lang != 'en') {
        await _translateArticles(lang);
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      _articles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch local news
  Future<void> fetchLocalNews({
    String? language,
    bool forceRefresh = false,
  }) async {
    if (_currentCity == null) {
      await _detectLocation();
    }

    if (_currentCity == null) {
      _error = 'Unable to detect your location';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final lang = language ?? ApiConstants.defaultLanguage;

      _localArticles = await _repository.getLocalNews(
        cityName: _currentCity!,
        country: _selectedCountry,
        lang: lang,
        forceRefresh: forceRefresh,
      );

      // Translate if needed
      if (lang != 'en') {
        await _translateLocalArticles(lang);
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      _localArticles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Translate articles
  Future<void> _translateArticles(String targetLanguage) async {
    final translatedArticles = <Article>[];

    for (var article in _articles) {
      final translated = await _translationService.translateArticle(
        title: article.title,
        description: article.description,
        targetLanguage: targetLanguage,
      );

      translatedArticles.add(
        article.copyWith(
          title: translated['title']!,
          description: translated['description'],
        ),
      );
    }

    _articles = translatedArticles;
  }

  /// Translate all articles (full pool)
  Future<void> _translateAllArticles(String targetLanguage) async {
    final translatedArticles = <Article>[];

    for (var article in _allArticles) {
      final translated = await _translationService.translateArticle(
        title: article.title,
        description: article.description,
        targetLanguage: targetLanguage,
      );

      translatedArticles.add(
        article.copyWith(
          title: translated['title']!,
          description: translated['description'],
        ),
      );
    }

    _allArticles = translatedArticles;
  }

  /// Translate local articles
  Future<void> _translateLocalArticles(String targetLanguage) async {
    final translatedArticles = <Article>[];

    for (var article in _localArticles) {
      final translated = await _translationService.translateArticle(
        title: article.title,
        description: article.description,
        targetLanguage: targetLanguage,
      );

      translatedArticles.add(
        article.copyWith(
          title: translated['title']!,
          description: translated['description'],
        ),
      );
    }

    _localArticles = translatedArticles;
  }

  /// Refresh articles
  Future<void> refresh({String? category, String? language}) async {
    await fetchTopHeadlines(
      category: category,
      language: language,
      forceRefresh: true,
    );
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _repository.clearCache();
  }
}
