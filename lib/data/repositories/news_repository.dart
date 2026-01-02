import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/app_constants.dart';

/// News Repository - handles data operations
class NewsRepository {
  final ApiService _apiService = ApiService();
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Fetch top headlines
  Future<List<Article>> getTopHeadlines({
    required String country,
    required String lang,
    String? category,
    bool forceRefresh = false,
  }) async {
    await init();

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedArticles = _getCachedArticles(
        'headlines_${country}_$category',
      );
      if (cachedArticles != null && cachedArticles.isNotEmpty) {
        return cachedArticles;
      }
    }

    // Fetch from API - Get 100 articles for better pagination
    final articles = await _apiService.fetchTopHeadlines(
      country: country,
      lang: lang,
      category: category,
      max: 100, // Fetch 100 articles
    );

    // Cache the results
    _cacheArticles('headlines_${country}_$category', articles);

    return articles;
  }

  /// Search articles
  Future<List<Article>> searchArticles({
    required String query,
    required String country,
    required String lang,
  }) async {
    return await _apiService.searchArticles(
      query: query,
      country: country,
      lang: lang,
      max: AppConstants.articlesPerPage,
    );
  }

  /// Fetch local news
  Future<List<Article>> getLocalNews({
    required String cityName,
    required String country,
    required String lang,
    bool forceRefresh = false,
  }) async {
    await init();

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedArticles = _getCachedArticles('local_$cityName');
      if (cachedArticles != null && cachedArticles.isNotEmpty) {
        return cachedArticles;
      }
    }

    // Fetch from API
    final articles = await _apiService.fetchLocalNews(
      cityName: cityName,
      country: country,
      lang: lang,
      max: AppConstants.articlesPerPage,
    );

    // Cache the results
    _cacheArticles('local_$cityName', articles);

    return articles;
  }

  /// Get cached articles
  List<Article>? _getCachedArticles(String key) {
    final cacheKey = '${AppConstants.keyCachedArticles}_$key';
    final timeKey = '${AppConstants.keyLastFetchTime}_$key';

    final cachedData = _prefs?.getString(cacheKey);
    final lastFetchTime = _prefs?.getInt(timeKey);

    if (cachedData == null || lastFetchTime == null) {
      return null;
    }

    // Check if cache is expired
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
    final now = DateTime.now();
    if (now.difference(cacheTime) > AppConstants.cacheDuration) {
      return null;
    }

    try {
      final List<dynamic> jsonList = json.decode(cachedData);
      return jsonList.map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  /// Cache articles
  Future<void> _cacheArticles(String key, List<Article> articles) async {
    final cacheKey = '${AppConstants.keyCachedArticles}_$key';
    final timeKey = '${AppConstants.keyLastFetchTime}_$key';

    final jsonList = articles.map((article) => article.toJson()).toList();
    final jsonString = json.encode(jsonList);

    await _prefs?.setString(cacheKey, jsonString);
    await _prefs?.setInt(timeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Clear all cache
  Future<void> clearCache() async {
    await init();
    final keys = _prefs?.getKeys() ?? {};
    for (var key in keys) {
      if (key.startsWith(AppConstants.keyCachedArticles) ||
          key.startsWith(AppConstants.keyLastFetchTime)) {
        await _prefs?.remove(key);
      }
    }
  }
}
