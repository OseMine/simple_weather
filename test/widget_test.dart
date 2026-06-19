import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/main.dart';
import 'package:simple_weather/services/settings.dart';
import 'package:simple_weather/screens/onboarding.dart';
import 'package:simple_weather/screens/home_screen.dart';

void main() {
  group('WeatherApp', () {
    testWidgets('shows onboarding when onboardingDone is false', (tester) async {
      final settings = SettingsService();
      await tester.pumpWidget(WeatherApp(settingsService: settings));

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Simple Weather'), findsOneWidget);
      expect(find.text('Weiter'), findsOneWidget);
    });

    testWidgets('shows HomeScreen when onboardingDone is true', (tester) async {
      final settings = SettingsService();
      settings.completeOnboarding();
      await tester.pumpWidget(WeatherApp(settingsService: settings));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsNothing);
    });

    testWidgets('uses light theme by default', (tester) async {
      final settings = SettingsService();
      await tester.pumpWidget(WeatherApp(settingsService: settings));

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);
    });

    testWidgets('uses dark theme when set', (tester) async {
      final settings = SettingsService();
      settings.updateThemeMode(true);
      await tester.pumpWidget(WeatherApp(settingsService: settings));

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
    });
  });
}
