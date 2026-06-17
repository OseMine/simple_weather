import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/main.dart';
import 'package:simple_weather/services/settings.dart';

void main() {
  testWidgets('App launches with onboarding screen', (WidgetTester tester) async {
    final settings = SettingsService();
    await tester.pumpWidget(WeatherApp(settingsService: settings));

    expect(find.text('Simple Weather'), findsOneWidget);
    expect(find.text('Weiter'), findsOneWidget);
  });
}
