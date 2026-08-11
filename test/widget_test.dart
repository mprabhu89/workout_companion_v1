import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/app/workout_companion_app.dart';

void main() {
  testWidgets('App launches to the Dashboard screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WorkoutCompanionApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);

    expect(find.text('Workout Companion'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Start Workout'), findsOneWidget);
    expect(find.text('Workout Plans'), findsOneWidget);
    expect(find.text('Workout History'), findsOneWidget);
    expect(find.text('No workout history yet'), findsOneWidget);
  });

  testWidgets('Dashboard opens Workout Plans', (WidgetTester tester) async {
    await tester.pumpWidget(const WorkoutCompanionApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Workout'));
    await tester.pumpAndSettle();

    expect(find.text('Workout Plans'), findsOneWidget);
    expect(
      find.text(
        'No workout plans yet.\nTap + to create your first workout plan.',
      ),
      findsOneWidget,
    );
  });
}
