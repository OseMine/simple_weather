import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget_service.dart';
import 'package:system_theme/system_theme.dart';

SharedPreferences? prefs;

class SettingsService extends ChangeNotifier {
  Color systemcolor = SystemTheme.accentColor.accent;
  ThemeMode systemthemeMode = ThemeMode.light;
  double lastTemperature = 0.0;
  String lastDescription = '';
  String units = 'metric'; // 'metric' oder 'imperial'
  bool onboardingDone = false;
  String language = 'de'; // 'de' oder 'en'
  ThemeMode themeMode = ThemeMode.light; // ThemeMode.light oder ThemeMode.dark
  Color accentColor = Colors.green; // Standard-Akzentfarbe
  double bgblur = 10.0; // Standard-Hintergrundunschärfe

  Future<void> initSettings() async {
    prefs = await SharedPreferences.getInstance();
    onboardingDone = prefs?.getBool('onboardingDone') ?? false;
    language = prefs?.getString('language') ?? 'en';
    final savedDarkMode = prefs?.getBool('isDarkMode');
    if (savedDarkMode != null) {
      themeMode = savedDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      final systemBrightness = PlatformDispatcher.instance.platformBrightness;
      themeMode = systemBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    accentColor = Color(prefs?.getInt('accentColor') ?? systemcolor.toARGB32());
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
    WidgetService.updateWeatherWidget(
      temperature: lastTemperature,
      description: lastDescription,
      units: units,
      brightness: isDark ? Brightness.dark : Brightness.light,
      seedColor: accentColor,
    );
    notifyListeners();
  }

  void updateAccentColor(Color color) {
    accentColor = color;
    prefs?.setInt('accentColor', color.toARGB32());
    WidgetService.updateWeatherWidget(
      temperature: lastTemperature,
      description: lastDescription,
      units: units,
      brightness: themeMode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
      seedColor: color,
    );
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

  void updateLastDescription(String desc) {
    lastDescription = desc;
  }
}
