import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_companion_v1/app/router/app_router.dart';
import 'package:workout_companion_v1/app/workout_companion_app.dart';
import 'package:workout_companion_v1/core/di/repository_registry.dart';
import 'package:workout_companion_v1/features/workout_day/data/repositories/in_memory_workout_day_repository.dart';
import 'package:workout_companion_v1/features/workout_day/domain/entities/workout_day.dart';
import 'package:workout_companion_v1/features/workout_history/data/repositories/in_memory_workout_history_repository.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_plan/data/repositories/in_memory_workout_plan_repository.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/entities/workout_plan.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_difficulty.dart';

import 'support/completing_startup_video_player.dart';

void main() {
  testWidgets(
    'Dashboard renders the compact RITMO lobby without redundant hints',
    (WidgetTester tester) async {
      await tester.pumpWidget(_testApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('THE ULTIMATE WORKOUT COMPANION'), findsOneWidget);
      expect(find.text('CHOOSE YOUR PATH'), findsNothing);
      expect(find.text('SELECT MODULE'), findsNothing);
      expect(find.text('01'), findsNothing);
      expect(find.text('02'), findsNothing);
      expect(find.text('03'), findsNothing);
      expect(find.text('04'), findsNothing);
      expect(find.text('05'), findsNothing);
      expect(find.text('SWIPE TO EXPLORE'), findsNothing);
      expect(find.byTooltip('Previous module'), findsNothing);
      expect(find.byTooltip('Next module'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -480));
      await tester.pumpAndSettle();
      expect(find.text('QUICK START'), findsOneWidget);
      expect(find.text('No training plan yet.'), findsOneWidget);
      expect(find.text('TRAINING DATA'), findsOneWidget);
      expect(find.text('YOUR JOURNEY STARTS HERE'), findsOneWidget);
    },
  );

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

    expect(find.text('WORKOUT PLANS'), findsWidgets);
    expect(find.text('TRAINING PROGRAMS'), findsOneWidget);
    expect(find.text('BUILD YOUR FIRST PROGRAM'), findsOneWidget);
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

  testWidgets(
    'Quick Start offers active plan days without scheduling assumptions',
    (WidgetTester tester) async {
      final originalPlanRepository = RepositoryRegistry.workoutPlanRepository;
      final originalDayRepository = RepositoryRegistry.workoutDayRepository;
      final planRepository = InMemoryWorkoutPlanRepository();
      final dayRepository = InMemoryWorkoutDayRepository();
      RepositoryRegistry.workoutPlanRepository = planRepository;
      RepositoryRegistry.workoutDayRepository = dayRepository;
      addTearDown(() {
        RepositoryRegistry.workoutPlanRepository = originalPlanRepository;
        RepositoryRegistry.workoutDayRepository = originalDayRepository;
      });

      await planRepository.saveWorkoutPlan(
        const WorkoutPlan(
          id: 'plan-quick-start',
          name: 'Strength Program',
          description: '',
          category: WorkoutPlanCategory.generalFitness,
          difficulty: WorkoutPlanDifficulty.beginner,
          estimatedDurationInMinutes: 30,
        ),
      );
      await planRepository.saveWorkoutPlan(
        const WorkoutPlan(
          id: 'plan-mobility',
          name: 'Mobility Program',
          description: '',
          category: WorkoutPlanCategory.generalFitness,
          difficulty: WorkoutPlanDifficulty.beginner,
          estimatedDurationInMinutes: 20,
        ),
      );
      await dayRepository.saveWorkoutDay(
        const WorkoutDay(
          id: 'day-rest',
          workoutPlanId: 'plan-quick-start',
          dayNumber: 1,
          name: 'Recovery',
          description: '',
          isRestDay: true,
        ),
      );
      await dayRepository.saveWorkoutDay(
        const WorkoutDay(
          id: 'day-mobility',
          workoutPlanId: 'plan-mobility',
          dayNumber: 1,
          name: 'Mobility Flow',
          description: '',
        ),
      );
      await dayRepository.saveWorkoutDay(
        const WorkoutDay(
          id: 'day-training',
          workoutPlanId: 'plan-quick-start',
          dayNumber: 2,
          name: 'Push Training',
          description: '',
        ),
      );

      await tester.pumpWidget(_testApp());
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.textContaining('Mobility Program'), findsOneWidget);
      expect(find.textContaining('Mobility Flow'), findsOneWidget);
      expect(find.text('START'), findsOneWidget);

      await tester.tap(find.byTooltip('Quick Start setup'));
      await tester.pumpAndSettle();
      expect(find.text('QUICK START SETUP'), findsOneWidget);
      expect(find.text('PROGRAM'), findsOneWidget);
      expect(find.text('TRAINING DAY'), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<WorkoutPlan>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Strength Program').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('DONE'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Strength Program'), findsOneWidget);
      expect(find.textContaining('Push Training'), findsOneWidget);
    },
  );

  testWidgets('Training Data keeps compact real metrics and View All access', (
    WidgetTester tester,
  ) async {
    final originalHistoryRepository =
        RepositoryRegistry.workoutHistoryRepository;
    final historyRepository = InMemoryWorkoutHistoryRepository();
    RepositoryRegistry.workoutHistoryRepository = historyRepository;
    addTearDown(
      () => RepositoryRegistry.workoutHistoryRepository =
          originalHistoryRepository,
    );
    await historyRepository.saveSession(
      CompletedWorkoutSession(
        id: 'training-data-session',
        workoutPlanId: 'plan',
        workoutPlanName: 'Plan',
        startedAt: DateTime(2026, 1, 1, 8),
        completedAt: DateTime(2026, 1, 1, 8, 2),
        durationInSeconds: 120,
        completedExercises: 2,
        totalExercises: 2,
        wasCompleted: true,
      ),
    );

    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(find.text('WORKOUTS'), findsOneWidget);
    expect(find.text('TRAINING TIME'), findsOneWidget);
    expect(find.text('COMPLETION'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2m'), findsOneWidget);
    expect(find.text('100.0%'), findsOneWidget);

    await tester.tap(find.text('VIEW ALL'));
    await tester.pumpAndSettle();
    expect(find.text('Workout Statistics'), findsOneWidget);
  });
}

WorkoutCompanionApp _testApp() {
  return WorkoutCompanionApp(
    router: createAppRouter(
      startupVideoPlayerFactory: CompletingStartupVideoPlayer.new,
    ),
  );
}
