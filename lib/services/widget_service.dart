import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
class WidgetService {
  static Future<void> init() async {
    if (!kIsWeb) {
      await HomeWidget.registerInteractivityCallback(backgroundCallback);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundCallback(Uri? uri) async {
    // Called when widget is tapped or system triggers update
  }

  static Future<void> updateWeatherWidget({
    required double temperature,
    required String description,
    required String units,
    Brightness brightness = Brightness.dark,
    Color? seedColor,
  }) async {
    if (kIsWeb) return;

    String tempStr = units == 'metric'
        ? '${temperature.toInt()}°C'
        : '${temperature.toInt()}°F';

    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor ?? Colors.green,
      brightness: brightness,
    );

    final bgColor = scheme.surface.toARGB32();
    final textColor = scheme.onSurface.toARGB32();
    final subtextColor = scheme.onSurfaceVariant.toARGB32();

    await HomeWidget.saveWidgetData<String>('temperature', tempStr);
    await HomeWidget.saveWidgetData<String>('description', description);
    await HomeWidget.saveWidgetData<int>('bgColor', bgColor);
    await HomeWidget.saveWidgetData<int>('textColor', textColor);
    await HomeWidget.saveWidgetData<int>('subtextColor', subtextColor);
    await HomeWidget.updateWidget(
      androidName: 'SimpleWeatherWidget',
    );
  }
}
