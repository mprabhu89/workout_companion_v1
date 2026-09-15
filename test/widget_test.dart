import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/app/router/app_router.dart';
import 'package:workout_companion_v1/app/workout_companion_app.dart';

import 'support/completing_startup_video_player.dart';

void main() {
  testWidgets('Dashboard renders the RITMO lobby without module numbers', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('THE ULTIMATE WORKOUT COMPANION'), findsOneWidget);
    expect(find.text('CHOOSE YOUR PATH'), findsOneWidget);
    expect(find.text('SELECT MODULE'), findsNothing);
    expect(find.text('01'), findsNothing);
    expect(find.text('02'), findsNothing);
    expect(find.text('03'), findsNothing);
    expect(find.text('04'), findsNothing);
    expect(find.text('05'), findsNothing);
    expect(find.text('SWIPE TO EXPLORE'), findsOneWidget);
    expect(find.byTooltip('Previous module'), findsNothing);
    expect(find.byTooltip('Next module'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -480));
    await tester.pumpAndSettle();
    expect(find.text('TRAINING DATA'), findsOneWidget);
    expect(find.text('YOUR JOURNEY STARTS HERE'), findsOneWidget);
  });

  testWidgets('carousel arrows and swiping change the active module', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Next module'));
    await tester.pumpAndSettle();
    expect(find.text('Workout Plans'), findsWidgets);
    expect(find.byTooltip('Previous module'), findsOneWidget);
    expect(find.byTooltip('Next module'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(-500, 0), 1200);
    await tester.pumpAndSettle();
    expect(find.text('Progress'), findsWidgets);

    await tester.tap(find.byTooltip('Next module'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Next module'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);
    expect(find.byTooltip('Previous module'), findsOneWidget);
    expect(find.byTooltip('Next module'), findsNothing);
  });

  testWidgets('ENTER opens the selected module through its existing route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Next module'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('lobby-card-Workout Plans')),
        matching: find.text('ENTER'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.text('Workout Plans'), findsWidgets);
    expect(
      find.text(
        'No workout plans yet.\nTap + to create your first workout plan.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Dashboard keeps developer tools secondary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    expect(find.text('Developer tools'), findsOneWidget);

    await tester.tap(find.text('Developer tools'));
    await tester.pumpAndSettle();
    expect(find.text('Development Menu'), findsOneWidget);
  });

  testWidgets('RITMO lobby has no narrow portrait overflow', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();
    await tester.fling(find.byType(PageView), const Offset(-500, 0), 1200);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('ENTER'), findsWidgets);
  });

}

WorkoutCompanionApp _testApp() {
  return WorkoutCompanionApp(
    router: createAppRouter(
      startupVideoPlayerFactory: CompletingStartupVideoPlayer.new,
    ),
  );
}
