import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/services/getweather.dart';

void main() {
  group('Weather.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = {
        'weather': [
          {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'},
        ],
        'main': {'temp': 22.5},
        'clouds': {'all': 10},
      };

      final weather = Weather.fromJson(json);

      expect(weather.main, 'Clear');
      expect(weather.description, 'clear sky');
      expect(weather.temperature, 23);
      expect(weather.clouds, 10);
      expect(weather.icon, '01d');
    });

    test('rounds temperature to nearest integer', () {
      final json = {
        'weather': [
          {'main': 'Rain', 'description': 'light rain', 'icon': '10d'},
        ],
        'main': {'temp': 22.7},
        'clouds': {'all': 75},
      };

      final weather = Weather.fromJson(json);
      expect(weather.temperature, 23);
    });

    test('parses temperature with negative value', () {
      final json = {
        'weather': [
          {'main': 'Snow', 'description': 'snow', 'icon': '13d'},
        ],
        'main': {'temp': -5.3},
        'clouds': {'all': 90},
      };

      final weather = Weather.fromJson(json);
      expect(weather.temperature, -5);
    });

    test('works with integer temperature in JSON', () {
      final json = {
        'weather': [
          {'main': 'Clouds', 'description': 'overcast', 'icon': '04d'},
        ],
        'main': {'temp': 15},
        'clouds': {'all': 100},
      };

      final weather = Weather.fromJson(json);
      expect(weather.temperature, 15);
    });
  });
}
