import 'package:flutter/material.dart';
import 'services/settings.dart';
import 'services/widget_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Wir erstellen eine Instanz deines Services beim App-Start
  final settingsService = SettingsService();
  await settingsService.initSettings();
  await WidgetService.init();
  runApp(WeatherApp(settingsService: settingsService));
}

class WeatherApp extends StatelessWidget {
  final SettingsService settingsService;

  // Der Konstruktor nimmt jetzt den Service entgegen
  const WeatherApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    // 2. Der ListenableBuilder sorgt dafür, dass sich die App neu aufbaut,
    // sobald sich im Service etwas ändert (z.B. der Dark Mode oder die Farbe)
    return ListenableBuilder(
      listenable: settingsService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wetter App',

          // 3. Hier übergeben wir den aktuellen ThemeMode (Light oder Dark)
          themeMode: settingsService.themeMode,

          // Definition für den Light Mode (Nutzt deine gewählte Akzentfarbe)
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: settingsService.accentColor,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          // Definition für den Dark Mode
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: settingsService.accentColor,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          // 4. Die Weiche: Ist das Onboarding fertig?
          // Wenn ja -> HomeScreen, wenn nein -> OnboardingScreen
          home: settingsService.onboardingDone
              ? const HomeScreen()
              : OnboardingScreen(settingsService: settingsService),
        );
      },
    );
  }
    
  }

