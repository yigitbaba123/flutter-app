import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Uygulama genelinde tema değişimini yöneten sınıf.
/// InheritedWidget + ChangeNotifier yaklaşımı ile çalışır.
class ThemeProvider extends ChangeNotifier {
  AppColorScheme _currentScheme = AppThemes.luksScheme; // Fabrika ayarı: Lüks

  AppColorScheme get currentScheme => _currentScheme;
  ThemeData get themeData => AppThemes.buildTheme(_currentScheme);

  void setTheme(AppColorScheme scheme) {
    _currentScheme = scheme;
    notifyListeners();
  }
}
