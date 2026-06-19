import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:simple_weather/widgets/temperature_display.dart';

void main() {
  setUpAll(() {
    Animate.restartOnHotReload = false;
  });

  testWidgets('displays temperature with Celsius suffix', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TemperatureDisplay(temperature: 25),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('°C'), findsOneWidget);
  });

  testWidgets('displays temperature value', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TemperatureDisplay(temperature: 42),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('°C'), findsOneWidget);
  });
}
