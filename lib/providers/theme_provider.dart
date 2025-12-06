import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';
  final SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider(this._prefs) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeIndex = _prefs.getInt(_key);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
      // notifyListeners() is not needed in constructor call for initial state
    }
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _prefs.setInt(_key, mode.index);
  }
}
