import 'package:flutter/material.dart';
import '../services/getweather.dart';
import '../services/widget_service.dart';
import '../widgets/temperature_display.dart';
import '../services/settings.dart' as settings;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Weather>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }

          final weatherData = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final s = settings.SettingsService();
            s.updateLastTemperature(weatherData.temperature);
            s.updateLastDescription(weatherData.description);
            WidgetService.updateWeatherWidget(
              temperature: weatherData.temperature,
              description: weatherData.description,
              units: s.units,
              brightness: s.themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light,
              seedColor: s.accentColor,
            );
          });
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TemperatureDisplay(
                    temperature: weatherData.temperature,
                  ),
                  Text(
                    weatherData.description,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
