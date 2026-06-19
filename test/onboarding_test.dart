import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/screens/onboarding.dart';
import 'package:simple_weather/services/settings.dart';

Widget _wrapOnboarding(SettingsService service) {
  return MaterialApp(home: OnboardingScreen(settingsService: service));
}

void main() {
  group('OnboardingScreen', () {
    testWidgets('shows welcome page initially', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      expect(find.text('Simple Weather'), findsOneWidget);
      expect(find.text('Weiter'), findsOneWidget);
    });

    testWidgets('shows back button after navigating forward', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      expect(find.text('Zurück'), findsOneWidget);
    });

    testWidgets('last page shows start button', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Weiter'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Starten'), findsOneWidget);
    });

    testWidgets('completes onboarding on start', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Weiter'));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.text('Starten'));
      expect(service.onboardingDone, true);
    });

    testWidgets('language selection updates service', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(service.language, 'en');
    });

    testWidgets('accent color selection updates service', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      expect(service.accentColor, Colors.green);
    });

    testWidgets('theme toggle updates service', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(service.themeMode, ThemeMode.dark);
    });

    testWidgets('units selection updates service', (tester) async {
      final service = SettingsService();
      await tester.pumpWidget(_wrapOnboarding(service));

      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Imperial'));
      await tester.pumpAndSettle();
      expect(service.units, 'imperial');
    });
  });
}
