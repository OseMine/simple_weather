import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/screens/home_screen.dart';

void main() {
  testWidgets('shows loading indicator initially', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
