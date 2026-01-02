/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'D@ily News';
  static const String appVersion = '1.0.0';

  // SharedPreferences Keys
  static const String keySelectedLanguage = 'selected_language';
  static const String keySelectedCountry = 'selected_country';
  static const String keyThemeMode = 'theme_mode';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyCachedArticles = 'cached_articles';
  static const String keyLastFetchTime = 'last_fetch_time';

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Pagination
  static const int articlesPerPage = 10;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);

  // Error Messages
  static const String errorNetwork =
      'No internet connection. Please check your network.';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorApiLimit =
      'API limit reached. Please try again later.';
  static const String errorNoArticles = 'No articles found.';

  // Success Messages
  static const String successRefresh = 'News updated successfully!';

  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'हिंदी (Hindi)',
    'ta': 'தமிழ் (Tamil)',
    'te': 'తెలుగు (Telugu)',
    'bn': 'বাংলা (Bengali)',
    'mr': 'मराठी (Marathi)',
  };

  // Language codes for GNews API
  static const Map<String, String> apiLanguageCodes = {
    'en': 'en',
    'hi': 'hi',
    'ta': 'ta',
    'te': 'te',
    'bn': 'bn',
    'mr': 'mr',
  };

  // ML Kit language codes
  static const Map<String, String> mlKitLanguageCodes = {
    'en': 'en',
    'hi': 'hi',
    'ta': 'ta',
    'te': 'te',
    'bn': 'bn',
    'mr': 'mr',
  };

  // Category Icons (Material Icons code points)
  static const Map<String, int> categoryIcons = {
    'general': 0xe1bd, // public
    'business': 0xe8f9, // business_center
    'sports': 0xe4e7, // sports_soccer
    'technology': 0xe30a, // computer
    'health': 0xe3f0, // favorite
    'entertainment': 0xe02c, // movie
    'science': 0xe8d7, // science
  };

  // Category Colors - Modern Gradient Palette
  static const Map<String, int> categoryColors = {
    'general': 0xFF6366F1, // Indigo
    'business': 0xFF10B981, // Emerald
    'sports': 0xFFF59E0B, // Amber
    'technology': 0xFF8B5CF6, // Violet
    'health': 0xFFEC4899, // Pink
    'entertainment': 0xFFF43F5E, // Rose
    'science': 0xFF06B6D4, // Cyan
  };
}
