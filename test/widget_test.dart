import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/app/workout_companion_app.dart';

void main() {
  testWidgets(
    'App launches to the Developer Home screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const WorkoutCompanionApp());

      // StartupPage is shown first.
      expect(find.text('Workout Companion'), findsOneWidget);

      // Wait for the delayed navigation to Developer Home.
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      expect(find.text('Development Menu'), findsOneWidget);

      expect(find.text('Exercise Library'), findsOneWidget);
      expect(find.text('Workout Plans'), findsOneWidget);

      expect(find.text('Workout Days'), findsOneWidget);
      expect(find.text('Exercise Groups'), findsOneWidget);
      expect(find.text('Workout Execution'), findsOneWidget);
    },
  );
}