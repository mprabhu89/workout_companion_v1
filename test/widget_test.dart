import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/app/workout_companion_app.dart';

void main() {
  testWidgets(
    'Exercise Library is the initial screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const WorkoutCompanionApp());

      // Allow GoRouter to complete navigation.
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      expect(find.text('Exercise Library'), findsOneWidget);

      expect(find.byType(FloatingActionButton), findsOneWidget);

      expect(
        find.text('No exercises yet.\nTap + to create your first exercise.'),
        findsOneWidget,
      );
    },
  );
}