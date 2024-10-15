import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isDarkTheme = false;
  String _wallpaperUrl = '';

  bool get isDarkTheme => _isDarkTheme;
  String get wallpaperUrl => _wallpaperUrl;

  ThemeNotifier() {
    _loadPreferences();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _savePreferences();
    notifyListeners();
  }

  void setWallpaper(String url) {
    _wallpaperUrl = url;
    _savePreferences();
    notifyListeners();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _wallpaperUrl = prefs.getString('wallpaperUrl') ?? '';
    notifyListeners();
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
    prefs.setString('wallpaperUrl', _wallpaperUrl);
  }
}
