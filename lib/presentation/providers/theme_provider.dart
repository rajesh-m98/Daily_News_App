import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Theme Provider - manages app theme state
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  SharedPreferences? _prefs;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize and load saved theme
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final savedTheme = _prefs?.getString(AppConstants.keyThemeMode) ?? 'light';
    _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Toggle theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await _prefs?.setString(
      AppConstants.keyThemeMode,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _prefs?.setString(
      AppConstants.keyThemeMode,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }
}
