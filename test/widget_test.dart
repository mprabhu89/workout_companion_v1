import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/app/workout_companion_app.dart';

void main() {
  testWidgets('Workout Companion launches successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WorkoutCompanionApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Workout Companion'), findsOneWidget);
  });
}