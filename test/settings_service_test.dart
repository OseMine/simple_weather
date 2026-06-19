import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weather/services/settings.dart';

void main() {
  group('SettingsService', () {
    test('initializes with defaults when no prefs saved', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.initSettings();

      expect(service.onboardingDone, false);
      expect(service.language, 'en');
      expect(service.units, 'metric');
      expect(service.bgblur, 10.0);
      expect(service.lastTemperature, 161.0);
    });

    test('loads saved preferences', () async {
      SharedPreferences.setMockInitialValues({
        'onboardingDone': true,
        'language': 'de',
        'units': 'imperial',
        'isDarkMode': true,
        'accentColor': Colors.blue.toARGB32(),
        'bgblur': 5.0,
        'lastTemperature': 25.0,
      });
      final service = SettingsService();
      await service.initSettings();

      expect(service.onboardingDone, true);
      expect(service.language, 'de');
      expect(service.units, 'imperial');
      expect(service.themeMode, ThemeMode.dark);
      expect(service.accentColor.toARGB32(), Colors.blue.toARGB32());
      expect(service.bgblur, 5.0);
      expect(service.lastTemperature, 25.0);
    });

    test('updateUnits saves and notifies', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.initSettings();

      bool notified = false;
      service.addListener(() => notified = true);
      service.updateUnits('imperial');

      expect(service.units, 'imperial');
      expect(notified, true);
    });

    test('updateLanguage saves and notifies', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.initSettings();

      bool notified = false;
      service.addListener(() => notified = true);
      service.updateLanguage('de');

      expect(service.language, 'de');
      expect(notified, true);
    });

    test('updateBgBlur saves and notifies', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.initSettings();

      bool notified = false;
      service.addListener(() => notified = true);
      service.updateBgBlur(8.5);

      expect(service.bgblur, 8.5);
      expect(notified, true);
    });

    test('updateLastTemperature saves and notifies', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.initSettings();

      bool notified = false;
      service.addListener(() => notified = true);
      service.updateLastTemperature(30.0);

      expect(service.lastTemperature, 30.0);
      expect(notified, true);
    });

    test('updateLastDescription stores value', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.initSettings();

      service.updateLastDescription('clear sky');
      expect(service.lastDescription, 'clear sky');
    });

    test('completeOnboarding sets flag and notifies', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.initSettings();

      bool notified = false;
      service.addListener(() => notified = true);
      service.completeOnboarding();

      expect(service.onboardingDone, true);
      expect(notified, true);
    });
  });
}
