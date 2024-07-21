import 'package:babyshophub_admin/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Brightness _currentBrightness = Brightness.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return _currentBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  ThemeData get themeData {
    if (_themeMode == ThemeMode.system) {
      return _currentBrightness == Brightness.dark
          ? const BabyShopHubTheme().darkTheme
          : const BabyShopHubTheme().lightTheme;
    } else {
      return _themeMode == ThemeMode.dark
          ? const BabyShopHubTheme().darkTheme
          : const BabyShopHubTheme().lightTheme;
    }
  }

  ThemeProvider() {
    _loadThemeMode();
    _getCurrentBrightness();
    ServicesBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      _getCurrentBrightness();
      notifyListeners();
    };
  }

  void _getCurrentBrightness() {
    _currentBrightness =
        ServicesBinding.instance.platformDispatcher.platformBrightness;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    _saveThemeMode();
  }

  void _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeModeString = prefs.getString('themeMode');
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void _saveThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeMode.toString());
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    _getCurrentBrightness();
    notifyListeners();
    _saveThemeMode();
  }
}