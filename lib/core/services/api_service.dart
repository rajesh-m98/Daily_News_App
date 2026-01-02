import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../utils/error_handler.dart';
import '../../data/models/article_model.dart';

/// API Service for GNews API
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  /// Fetch top headlines
  Future<List<Article>> fetchTopHeadlines({
    required String country,
    required String lang,
    String? category,
    int max = 10,
  }) async {
    try {
      final url = ApiConstants.getTopHeadlinesUrl(
        country: country,
        lang: lang,
        category: category,
        max: max,
      );

      final response = await _client
          .get(Uri.parse(url))
          .timeout(AppConstants.apiTimeout);

      ErrorHandler.handleStatusCode(response.statusCode, response.body);

      final data = json.decode(response.body);

      if (data['articles'] == null) {
        throw ApiException('No articles found in response');
      }

      final articles = (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();

      return articles;
    } catch (e) {
      throw ApiException(ErrorHandler.getErrorMessage(e));
    }
  }

  /// Search for articles
  Future<List<Article>> searchArticles({
    required String query,
    required String country,
    required String lang,
    int max = 10,
  }) async {
    try {
      final url = ApiConstants.getSearchUrl(
        query: query,
        country: country,
        lang: lang,
        max: max,
      );

      final response = await _client
          .get(Uri.parse(url))
          .timeout(AppConstants.apiTimeout);

      ErrorHandler.handleStatusCode(response.statusCode, response.body);

      final data = json.decode(response.body);

      if (data['articles'] == null) {
        return [];
      }

      final articles = (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();

      return articles;
    } catch (e) {
      throw ApiException(ErrorHandler.getErrorMessage(e));
    }
  }

  /// Fetch local news based on city name
  Future<List<Article>> fetchLocalNews({
    required String cityName,
    required String country,
    required String lang,
    int max = 10,
  }) async {
    // Use search API with city name as query
    return searchArticles(
      query: cityName,
      country: country,
      lang: lang,
      max: max,
    );
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
