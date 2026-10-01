// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fittrack/app/app.dart';

void main() {
  testWidgets('FitTrack app loads the home dashboard', (tester) async {
    await tester.pumpWidget(const FitTrackApp());

    expect(find.textContaining('Good morning'), findsOneWidget);
    expect(find.text('Workouts'), findsOneWidget);
  });

  testWidgets('starting a workout initializes state before opening the screen', (tester) async {
    await tester.pumpWidget(const FitTrackApp());

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.byIcon(Icons.fitness_center_outlined),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Start Workout'));
    await tester.tap(find.text('Start Workout'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Exercise 1 of'), findsOneWidget);
  });

  testWidgets('profile settings tiles build on a Material surface', (tester) async {
    await tester.pumpWidget(const FitTrackApp());

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Units'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
  });
}
