import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';

void main() {
  testWidgets('Login screen renders and validates input', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Find the username and password fields
    final usernameField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    // Ensure widgets are rendered
    expect(usernameField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // Try submitting with empty fields
    await tester.tap(loginButton);
    await tester.pump(); // Rebuild after button press

    // Expect validation errors
    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
