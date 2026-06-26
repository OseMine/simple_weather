import 'package:flutter/material.dart';
import '../services/getweather.dart';
import '../services/settings.dart' as settings;

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = getWeather();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Weather>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off_rounded, size: 64, color: cs.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(
                      'Wetterdaten nicht verfügbar',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          final weather = snapshot.data!;
          final s = settings.SettingsService();
          final isMetric = s.units == 'metric';

          String tempUnit = isMetric ? '°C' : '°F';
          String windUnit = isMetric ? 'm/s' : 'mph';

          String weatherDesc = weather.description;
          if (s.language == 'de') {
            final map = {
              'clear sky': 'Klarer Himmel',
              'few clouds': 'Wenig bewölkt',
              'scattered clouds': 'Vereinzelt bewölkt',
              'broken clouds': 'Stark bewölkt',
              'overcast clouds': 'Bedeckt',
              'shower rain': 'Schauer',
              'rain': 'Regen',
              'thunderstorm': 'Gewitter',
              'snow': 'Schnee',
              'mist': 'Nebel',
            };
            weatherDesc = map[weather.description.toLowerCase()] ?? weather.description;
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.list_alt_rounded, color: cs.onPrimaryContainer),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Wetter Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView(
                      children: [
                        _DetailTile(
                          icon: Icons.thermostat_rounded,
                          label: s.language == 'de' ? 'Temperatur' : 'Temperature',
                          value: '${weather.temperature.toStringAsFixed(0)}$tempUnit',
                          cs: cs,
                        ),
                        const SizedBox(height: 12),
                        _DetailTile(
                          icon: Icons.cloud_rounded,
                          label: s.language == 'de' ? 'Wetter' : 'Condition',
                          value: weatherDesc,
                          cs: cs,
                        ),
                        const SizedBox(height: 12),
                        _DetailTile(
                          icon: Icons.cloud_queue_rounded,
                          label: s.language == 'de' ? 'Bewölkung' : 'Cloudiness',
                          value: s.language == 'de'
                              ? '${weather.clouds.toStringAsFixed(0)}%'
                              : '${weather.clouds.toStringAsFixed(0)}%',
                          cs: cs,
                        ),
                        const SizedBox(height: 12),
                        _DetailTile(
                          icon: Icons.air_rounded,
                          label: s.language == 'de' ? 'Wind' : 'Wind',
                          value: '~ $windUnit',
                          cs: cs,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.auto_awesome_rounded, color: cs.primary, size: 28),
                              const SizedBox(height: 12),
                              Text(
                                s.language == 'de'
                                    ? 'Erweiterte Vorhersage in Entwicklung'
                                    : 'Extended forecast in development',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                s.language == 'de'
                                    ? 'Stündliche und 7-Tage-Vorhersagen folgen bald.'
                                    : 'Hourly and 7-day forecasts coming soon.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
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

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: cs.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
