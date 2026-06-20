import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget_service.dart';
import 'package:system_theme/system_theme.dart';

SharedPreferences? prefs;

class SettingsService extends ChangeNotifier {
  static SettingsService? _instance;

  factory SettingsService() {
    _instance ??= SettingsService._();
    return _instance!;
  }

  SettingsService._();

  Color systemAccentColor = SystemTheme.kDefaultFallbackColor;
  ThemeMode systemthemeMode = PlatformDispatcher.instance.platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  double lastTemperature = 0.0;
  String lastDescription = '';
  String units = 'metric';
  bool onboardingDone = false;
  String language = 'de';
  ThemeMode themeMode = ThemeMode.light;
  Color accentColor = SystemTheme.kDefaultFallbackColor;
  double bgblur = 10.0;
  double gradientHeight = 200;
  bool pitchBlack = false;

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
    accentColor = Color(prefs?.getInt('accentColor') ?? await _loadSystemAccentColor());
    bgblur = prefs?.getDouble('bgblur') ?? 10.0;
    gradientHeight = prefs?.getDouble('gradientHeight') ?? 200;
    units = prefs?.getString('units') ?? 'metric';
    lastTemperature = prefs?.getDouble('lastTemperature') ?? 161.0;
    pitchBlack = prefs?.getBool('pitchBlack') ?? false;
    notifyListeners();
  }

  Future<int> _loadSystemAccentColor() async {
    try {
      await SystemTheme.accentColor.load();
      systemAccentColor = SystemTheme.accentColor.accent;
      return systemAccentColor.toARGB32();
    } catch (_) {
      systemAccentColor = SystemTheme.kDefaultFallbackColor;
      return systemAccentColor.toARGB32();
    }
  }

  void updateUnits(String newUnits) {
    units = newUnits;
    prefs?.setString('units', newUnits);
    notifyListeners();
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

  void updatePitchBlack(bool value) {
    pitchBlack = value;
    prefs?.setBool('pitchBlack', value);
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

  void updateGradientHeight(double height) {
    gradientHeight = height;
    prefs?.setDouble('gradientHeight', height);
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

  void resetapp() {
    prefs?.clear();
    themeMode = systemthemeMode;
    accentColor = systemAccentColor;
    bgblur = 10.0;
    gradientHeight = 200;
    pitchBlack = false;
    units = 'metric';
    language = 'de';
    onboardingDone = false;
    notifyListeners();
  }
}
