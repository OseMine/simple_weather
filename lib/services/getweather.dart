import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'settings.dart' as settings;
import 'api_key.dart';

class Weather {
  final String main;
  final String description;
  final double temperature;
  final double clouds;
  final String icon;

  const Weather({
    required this.main,
    required this.description,
    required this.temperature,
    required this.clouds,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temperature: (json['main']['temp'] as num).round().toDouble(),
      clouds: (json['clouds']['all'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}

Future<Weather> getWeather() async {
  Position position = await Geolocator.getCurrentPosition(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    ),
  );

  final response = await http.get(
    Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=${settings.SettingsService().units}&appid=$apiKey',
    ),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load weather: ${response.statusCode}');
  }

  return Weather.fromJson(jsonDecode(response.body));
}
