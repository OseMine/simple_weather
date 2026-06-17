import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  // Bestehende Variablen
  double lastTemperature = 0.0;
  String units = 'metric'; // 'metric' oder 'imperial'
  bool onboardingDone = false;

  // Neue Variablen für dein Onboarding
  String language = 'en'; // 'de' oder 'en'
  ThemeMode themeMode = ThemeMode.light; // ThemeMode.light oder ThemeMode.dark
  Color accentColor = Colors.green; // Standard-Akzentfarbe
  double bgblur = 10.0; // Standard-Hintergrundunschärfe

  // Funktionen, um die Werte zu ändern und die UI zu aktualisieren
  void updateUnits(String newUnits) {
    units = newUnits;
    notifyListeners(); // Benachrichtigt die App über die Änderung
  }

  void updateLanguage(String newLanguage) {
    language = newLanguage;
    notifyListeners();
  }

  void updateThemeMode(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void updateAccentColor(Color color) {
    accentColor = color;
    notifyListeners();
  }

  void completeOnboarding() {
    onboardingDone = true;
    notifyListeners();
  }
}