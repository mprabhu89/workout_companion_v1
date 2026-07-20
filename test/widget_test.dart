import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/main.dart';

void main() {
  testWidgets('Workout Companion launches successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WorkoutCompanionApp());

    expect(find.text('Workout Companion'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}