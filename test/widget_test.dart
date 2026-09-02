import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/app/router/app_router.dart';
import 'package:workout_companion_v1/app/workout_companion_app.dart';

import 'support/completing_startup_video_player.dart';

void main() {
  testWidgets('App launches to the Dashboard screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);

    expect(find.text('Workout Companion'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Start Workout'), findsOneWidget);
    expect(find.text('Workout Plans'), findsOneWidget);
    expect(find.text('Workout History'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byTooltip('More options'), findsOneWidget);
    expect(find.text('No workout history yet'), findsOneWidget);
  });

  testWidgets(
    'Dashboard opens Workout History and keeps developer tools secondary',
    (WidgetTester tester) async {
      await tester.pumpWidget(_testApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Workout History'));
      await tester.pumpAndSettle();

      expect(find.text('No workout history yet'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('More options'));
      await tester.pumpAndSettle();
      expect(find.text('Developer tools'), findsOneWidget);

      await tester.tap(find.text('Developer tools'));
      await tester.pumpAndSettle();
      expect(find.text('Development Menu'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
    },
  );

  testWidgets('Dashboard opens Workout Plans', (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
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

  testWidgets('Dashboard Workout Plans card opens Workout Plan Library', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workout Plans'));
    await tester.pumpAndSettle();

    expect(find.text('Workout Plans'), findsWidgets);
    expect(
      find.text(
        'No workout plans yet.\nTap + to create your first workout plan.',
      ),
      findsOneWidget,
    );
  });
}

WorkoutCompanionApp _testApp() {
  return WorkoutCompanionApp(
    router: createAppRouter(
      startupVideoPlayerFactory: CompletingStartupVideoPlayer.new,
    ),
  );
}
