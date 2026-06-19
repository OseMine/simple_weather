import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/services/widget_service.dart';

void main() {
  const channel = MethodChannel('home_widget');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('updateWeatherWidget with metric units', (tester) async {
    await WidgetService.updateWeatherWidget(
      temperature: 22.5,
      description: 'clear sky',
      units: 'metric',
    );
    await tester.pump();
  });

  testWidgets('updateWeatherWidget with imperial units', (tester) async {
    await WidgetService.updateWeatherWidget(
      temperature: 72.0,
      description: 'clear sky',
      units: 'imperial',
    );
    await tester.pump();
  });

  testWidgets('updateWeatherWidget with zero temperature', (tester) async {
    await WidgetService.updateWeatherWidget(
      temperature: 0,
      description: 'freezing',
      units: 'metric',
    );
    await tester.pump();
  });

  testWidgets('updateWeatherWidget with negative temperature', (tester) async {
    await WidgetService.updateWeatherWidget(
      temperature: -5.5,
      description: 'cold',
      units: 'metric',
    );
    await tester.pump();
  });
}
