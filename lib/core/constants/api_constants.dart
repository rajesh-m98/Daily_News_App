/// API Constants for GNews API
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://gnews.io/api/v4';

  static const String apiKey = 'dbe709d7aa457a4ae0a0a4d4fd906672';

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String search = '/search';

  // Default parameters
  static const String defaultCountry = 'in'; // India
  static const String defaultLanguage = 'en'; // English
  static const int maxArticles = 10; // Per request

  // Categories
  static const List<String> categories = [
    'general',
    'business',
    'sports',
    'technology',
    'health',
    'entertainment',
    'science',
  ];

  // Supported countries
  static const Map<String, String> countries = {
    'in': 'India',
    'us': 'United States',
    'gb': 'United Kingdom',
    'au': 'Australia',
    'ca': 'Canada',
  };

  // IP Geolocation API
  static const String ipApiUrl = 'http://ip-api.com/json';

  // Build URL helpers
  static String getTopHeadlinesUrl({
    required String country,
    required String lang,
    String? category,
    int max = 10,
  }) {
    final params = {
      'country': country,
      'lang': lang,
      'apikey': apiKey,
      'max': max.toString(),
      if (category != null && category.isNotEmpty) 'category': category,
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl$topHeadlines?$queryString';
  }

  static String getSearchUrl({
    required String query,
    required String country,
    required String lang,
    int max = 10,
  }) {
    final params = {
      'q': query,
      'country': country,
      'lang': lang,
      'apikey': apiKey,
      'max': max.toString(),
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl$search?$queryString';
  }
}
