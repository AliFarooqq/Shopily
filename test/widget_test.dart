// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopily/main.dart';

void main() {
  testWidgets('App starts with SplashScreen and navigates to WelcomeScreen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the splash screen is displayed initially.
    expect(find.byType(Image), findsWidgets);

    // Advance time by 3 seconds to trigger the Timer navigation.
    await tester.pump(const Duration(seconds: 3));

    // Pump frames to complete the navigation animation.
    await tester.pump();
    await tester.pump();

    // Verify we've navigated to WelcomeScreen by checking for welcome text.
    expect(find.text('Welcome to Shopily!'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
