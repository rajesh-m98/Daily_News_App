import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Translation Service using Google ML Kit
class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final Map<String, OnDeviceTranslator> _translators = {};

  /// Translate text from English to target language
  Future<String> translate(String text, String targetLanguage) async {
    // If target is English, return as is
    if (targetLanguage == 'en' || text.isEmpty) {
      return text;
    }

    try {
      // Get or create translator for this language pair
      final translator = await _getTranslator(targetLanguage);

      // Translate the text
      final translatedText = await translator.translateText(text);
      return translatedText;
    } catch (e) {
      // Return original text if translation fails
      return text;
    }
  }

  /// Translate article title and description
  Future<Map<String, String>> translateArticle({
    required String title,
    String? description,
    required String targetLanguage,
  }) async {
    if (targetLanguage == 'en') {
      return {'title': title, 'description': description ?? ''};
    }

    try {
      final translatedTitle = await translate(title, targetLanguage);
      final translatedDescription = description != null
          ? await translate(description, targetLanguage)
          : '';

      return {'title': translatedTitle, 'description': translatedDescription};
    } catch (e) {
      return {'title': title, 'description': description ?? ''};
    }
  }

  /// Get or create translator for language pair
  Future<OnDeviceTranslator> _getTranslator(String targetLanguage) async {
    final key = 'en-$targetLanguage';

    if (_translators.containsKey(key)) {
      return _translators[key]!;
    }

    // Create new translator
    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: _getTranslateLanguage(targetLanguage),
    );

    _translators[key] = translator;
    return translator;
  }

  /// Convert language code to TranslateLanguage
  TranslateLanguage _getTranslateLanguage(String code) {
    switch (code) {
      case 'hi':
        return TranslateLanguage.hindi;
      case 'ta':
        return TranslateLanguage.tamil;
      case 'te':
        return TranslateLanguage.telugu;
      case 'bn':
        return TranslateLanguage.bengali;
      case 'mr':
        return TranslateLanguage.marathi;
      default:
        return TranslateLanguage.english;
    }
  }

  /// Download language model if not already downloaded
  Future<bool> downloadLanguageModel(String languageCode) async {
    if (languageCode == 'en') return true;

    try {
      final modelManager = OnDeviceTranslatorModelManager();
      final language = _getTranslateLanguage(languageCode);

      // Check if model is already downloaded
      final isDownloaded = await modelManager.isModelDownloaded(
        language.bcpCode,
      );

      if (!isDownloaded) {
        // Download the model
        await modelManager.downloadModel(language.bcpCode);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if language model is downloaded
  Future<bool> isModelDownloaded(String languageCode) async {
    if (languageCode == 'en') return true;

    try {
      final modelManager = OnDeviceTranslatorModelManager();
      final language = _getTranslateLanguage(languageCode);
      return await modelManager.isModelDownloaded(language.bcpCode);
    } catch (e) {
      return false;
    }
  }

  /// Dispose all translators
  void dispose() {
    for (var translator in _translators.values) {
      translator.close();
    }
    _translators.clear();
  }
}
