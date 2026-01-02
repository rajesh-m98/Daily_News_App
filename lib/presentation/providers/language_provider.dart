import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Language Provider - manages app language state
class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'en';
  SharedPreferences? _prefs;

  String get selectedLanguage => _selectedLanguage;

  /// Get language display name
  String get languageName =>
      AppConstants.supportedLanguages[_selectedLanguage] ?? 'English';

  /// Get API language code
  String get apiLanguageCode =>
      AppConstants.apiLanguageCodes[_selectedLanguage] ?? 'en';

  /// Initialize and load saved language
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _selectedLanguage =
        _prefs?.getString(AppConstants.keySelectedLanguage) ?? 'en';
    notifyListeners();
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    if (_selectedLanguage == languageCode) return;

    _selectedLanguage = languageCode;
    await _prefs?.setString(AppConstants.keySelectedLanguage, languageCode);
    notifyListeners();
  }

  /// Check if language is selected
  bool isLanguageSelected(String languageCode) {
    return _selectedLanguage == languageCode;
  }
}
