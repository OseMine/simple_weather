import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weather/services/settings.dart';

void main() {
  group('SettingsService', () {
    late SettingsService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = SettingsService();
    });

    test('has default values', () {
      expect(service.lastTemperature, 0.0);
      expect(service.units, 'metric');
      expect(service.onboardingDone, false);
      expect(service.language, 'en');
      expect(service.themeMode, ThemeMode.light);
      expect(service.accentColor, Colors.green);
      expect(service.bgblur, 10.0);
    });

    test('initSettings keeps defaults when no prefs stored', () async {
      await service.initSettings();
      expect(service.onboardingDone, false);
      expect(service.language, 'en');
      expect(service.themeMode, ThemeMode.light);
      expect(service.bgblur, 10.0);
      expect(service.units, 'metric');
      expect(service.lastTemperature, 161.0);
    });

    test('initSettings loads stored values from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'onboardingDone': true,
        'language': 'de',
        'isDarkMode': true,
        'bgblur': 5.5,
        'units': 'imperial',
        'lastTemperature': 72.0,
      });

      final localService = SettingsService();
      await localService.initSettings();

      expect(localService.onboardingDone, true);
      expect(localService.language, 'de');
      expect(localService.themeMode, ThemeMode.dark);
      expect(localService.bgblur, 5.5);
      expect(localService.units, 'imperial');
      expect(localService.lastTemperature, 72.0);
    });

    test('updateUnits changes units and notifies', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);
      service.updateUnits('imperial');
      expect(service.units, 'imperial');
      expect(notifyCount, 1);
    });

    test('updateLanguage changes language and notifies', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);
      service.updateLanguage('de');
      expect(service.language, 'de');
      expect(notifyCount, 1);
    });

    test('updateThemeMode changes to dark', () {
      service.updateThemeMode(true);
      expect(service.themeMode, ThemeMode.dark);
    });

    test('updateThemeMode changes to light', () {
      service.updateThemeMode(false);
      expect(service.themeMode, ThemeMode.light);
    });

    test('updateThemeMode notifies listeners', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);
      service.updateThemeMode(true);
      expect(notifyCount, 1);
    });

    test('updateAccentColor changes color and notifies', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);
      service.updateAccentColor(Colors.blue);
      expect(service.accentColor, Colors.blue);
      expect(notifyCount, 1);
    });

    test('updateBgBlur changes blur and notifies', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);
      service.updateBgBlur(20.0);
      expect(service.bgblur, 20.0);
      expect(notifyCount, 1);
    });

    test('completeOnboarding sets flag and notifies', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);
      service.completeOnboarding();
      expect(service.onboardingDone, true);
      expect(notifyCount, 1);
    });

    test('updateLastTemperature changes temperature and notifies', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);
      service.updateLastTemperature(25.0);
      expect(service.lastTemperature, 25.0);
      expect(notifyCount, 1);
    });
  });
}
