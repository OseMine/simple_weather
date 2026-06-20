import 'package:flutter/material.dart';
import 'services/settings.dart';
import 'services/widget_service.dart';
import 'screens/main_navigation.dart';
import 'screens/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsService = SettingsService();
  await settingsService.initSettings();
  await WidgetService.init();
  runApp(WeatherApp(settingsService: settingsService));
}

class WeatherApp extends StatelessWidget {
  final SettingsService settingsService;

  const WeatherApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      
      listenable: settingsService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple Weather',

          themeMode: settingsService.themeMode,

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: settingsService.accentColor,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            colorScheme: (settingsService.pitchBlack
                ? ColorScheme.fromSeed(
                    seedColor: settingsService.accentColor,
                    brightness: Brightness.dark,
                  ).copyWith(
                    surface: Colors.black,
                    surfaceContainerHigh: Colors.black,
                    surfaceContainerHighest: Colors.black,
                    surfaceContainerLow: Colors.black,
                    surfaceContainerLowest: Colors.black,
                    surfaceDim: Colors.black,
                    surfaceBright: Colors.black,
                  )
                : ColorScheme.fromSeed(
                    seedColor: settingsService.accentColor,
                    brightness: Brightness.dark,
                  )),
            useMaterial3: true,
          ),

          home: settingsService.onboardingDone
              ? const MainNavigationScreen()
              : OnboardingScreen(settingsService: settingsService),
        );
      },
    );
  }
}

