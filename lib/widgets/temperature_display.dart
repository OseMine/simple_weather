import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/settings.dart' as settings;

class TemperatureDisplay extends StatelessWidget {
  final double temperature;

  const TemperatureDisplay({
    super.key,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: settings.SettingsService().lastTemperature, end: temperature),
      duration: 2000.ms,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '${value.toStringAsFixed(0)}°C',
          style: const TextStyle(
            fontSize: 150,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    )
        .animate()
        .slideY(
          begin: 0.5,
          end: 0,
          duration: 1200.ms,
          curve: Curves.easeOutCubic,
        )
        .blurXY(
          begin: 12,
          end: 0,
          duration: 1000.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(
          duration: 800.ms,
          curve: Curves.easeOutCubic,
        );
  }

}
