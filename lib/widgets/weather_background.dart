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

    final background = Positioned(
      bottom: MediaQuery.of(context).size.height / 2,
      right: MediaQuery.of(context).size.width / 2,
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
    );

    if (onRefresh != null) {
      return Stack(
        children: [
          background,
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: onRefresh!,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        background,
        child,
      ],
    );
  }
}