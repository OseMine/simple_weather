import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/services/getweather.dart';
import 'package:simple_weather/widgets/weather_background.dart';

void main() {
  final testWeather = Weather(
    main: 'Clear',
    description: 'clear sky',
    temperature: 25,
    clouds: 10,
    icon: '01d',
  );

  testWidgets('renders child widget inside background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WeatherBackground(
          weather: testWeather,
          child: const Text('Hello World'),
        ),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('renders with different weather icon', (tester) async {
    final rainyWeather = Weather(
      main: 'Rain',
      description: 'heavy rain',
      temperature: 15,
      clouds: 90,
      icon: '10d',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: WeatherBackground(
          weather: rainyWeather,
          child: const Text('Rainy'),
        ),
      ),
    );

    expect(find.text('Rainy'), findsOneWidget);
  });
}
