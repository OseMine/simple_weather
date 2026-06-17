import 'package:flutter/material.dart';
import '../services/getweather.dart';

class WeatherBackground extends StatelessWidget {
  final Weather weather;
  final Widget child;

  const WeatherBackground({
    super.key,
    required this.weather,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final iconUrl = 'https://openweathermap.org/img/wn/${weather.icon}@4x.png';

    return Stack(
      children: [
        Positioned(
          bottom: -60,
          right: -60,
          child: Opacity(
            opacity: 0.12,
            child: Image.network(
              iconUrl,
              width: 380,
              height: 380,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
