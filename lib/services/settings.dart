import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class SettingsService extends ChangeNotifier {
  double lastTemperature = 0.0;
  String units = 'metric'; // 'metric' oder 'imperial'
  bool onboardingDone = false;
  String language = 'en'; // 'de' oder 'en'
  ThemeMode themeMode = ThemeMode.light; // ThemeMode.light oder ThemeMode.dark
  Color accentColor = Colors.green; // Standard-Akzentfarbe
  double bgblur = 10.0; // Standard-Hintergrundunschärfe

  Future<void> initSettings() async {
    onboardingDone = prefs?.getBool('onboardingDone') ?? false;
    language = prefs?.getString('language') ?? 'en';
    themeMode = (prefs?.getBool('isDarkMode') ?? false)
        ? ThemeMode.dark
        : ThemeMode.light;
    accentColor = Color(prefs?.getInt('accentColor') ?? Colors.green.value);
    bgblur = prefs?.getDouble('bgblur') ?? 10.0;
    units = prefs?.getString('units') ?? 'metric';
    lastTemperature = prefs?.getDouble('lastTemperature') ?? 161.0;
    notifyListeners();
  }

  // Funktionen, um die Werte zu ändern und die UI zu aktualisieren
  void updateUnits(String newUnits) {
    units = newUnits;
    prefs?.setString('units', newUnits);
    notifyListeners(); // Benachrichtigt die App über die Änderung
  }

  void updateLanguage(String newLanguage) {
    language = newLanguage;
    prefs?.setString('language', newLanguage);
    notifyListeners();
  }

  void updateThemeMode(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    prefs?.setBool('isDarkMode', isDark);
    notifyListeners();
  }

  void updateAccentColor(Color color) {
    accentColor = color;
    prefs?.setInt('accentColor', color.value);
    notifyListeners();
  }

  void updateBgBlur(double blur) {
    bgblur = blur;
    prefs?.setDouble('bgblur', blur);
    notifyListeners();
  }

  void completeOnboarding() {
    onboardingDone = true;
    prefs?.setBool('onboardingDone', true);
    notifyListeners();
  }
  void updateLastTemperature(double temp) {
    lastTemperature = temp;
    prefs?.setDouble('lastTemperature', temp);
    notifyListeners();
  }
}
