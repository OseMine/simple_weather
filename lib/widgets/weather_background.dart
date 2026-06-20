import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import '../services/getweather.dart';
import '../services/settings.dart' as settings;

class WeatherBackground extends StatelessWidget {
  final Weather weather;
  final Widget child;
  final Future<void> Function()? onRefresh;

  const WeatherBackground({
    super.key,
    required this.weather,
    required this.child,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final iconUrl = 'https://openweathermap.org/img/wn/${weather.icon}@4x.png';
    final blurValue = settings.SettingsService().bgblur;

    final body = Stack(
      children: [
        Positioned(
          bottom: -60,
          right: -60,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurValue,
              sigmaY: blurValue,
            ),
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
        ),
        child,
      ],
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: body,
          ),
        ),
      );
    }

    return body;
  }
}