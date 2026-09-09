import 'package:amptive/src/config/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Amptive dark theme builds without throwing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AmptiveThemeData.darkTheme,
        home: const Scaffold(body: Center(child: Text('Amptive'))),
      ),
    );

    // The theme should have applied a dark background.
    final BuildContext context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(find.text('Amptive'), findsOneWidget);
  });
}