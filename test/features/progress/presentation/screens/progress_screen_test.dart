import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/app/router/app_router.dart';
import 'package:workout_companion_v1/app/workout_companion_app.dart';
import 'package:workout_companion_v1/core/di/repository_registry.dart';
import 'package:workout_companion_v1/features/progress/domain/services/workout_progress_service.dart';
import 'package:workout_companion_v1/features/progress/presentation/controllers/workout_progress_controller.dart';
import 'package:workout_companion_v1/features/progress/presentation/screens/progress_screen.dart';
import 'package:workout_companion_v1/features/workout_day/data/repositories/in_memory_workout_day_repository.dart';
import 'package:workout_companion_v1/features/workout_day/domain/entities/workout_day.dart';
import 'package:workout_companion_v1/features/workout_history/data/repositories/in_memory_workout_history_repository.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_plan/data/repositories/in_memory_workout_plan_repository.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/entities/workout_plan.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_difficulty.dart';

import '../../../../support/completing_startup_video_player.dart';

void main() {
  testWidgets('renders overall progress and opens plan details', (
    tester,
  ) async {
    final planRepository = InMemoryWorkoutPlanRepository();
    final dayRepository = InMemoryWorkoutDayRepository();
    final historyRepository = InMemoryWorkoutHistoryRepository();
    await _seedProgressData(
      planRepository: planRepository,
      dayRepository: dayRepository,
      historyRepository: historyRepository,
    );
    final controller = WorkoutProgressController(
      workoutPlanRepository: planRepository,
      workoutDayRepository: dayRepository,
      workoutHistoryRepository: historyRepository,
      progressService: const WorkoutProgressService(),
    );

    await tester.pumpWidget(
      MaterialApp(home: ProgressScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('PERFORMANCE HUD'), findsOneWidget);
    expect(find.text('TRAINING SUMMARY'), findsOneWidget);
    expect(find.text('2/3 PLANNED'), findsOneWidget);
    expect(find.text('67%'), findsNWidgets(2));
    expect(find.text('ACTUAL SESSIONS'), findsOneWidget);
    expect(find.text('TRAINING ACTIVITY'), findsOneWidget);
    expect(find.text('Strength Plan'), findsOneWidget);

    await tester.tap(find.text('Strength Plan'));
    await tester.pumpAndSettle();

    expect(find.text('Plan Progress'), findsOneWidget);
    expect(find.text('Completed 2 times'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Not Completed'), findsOneWidget);
    expect(find.text('Rest Day'), findsOneWidget);
  });

  testWidgets('renders a safe empty state without planned workouts', (
    tester,
  ) async {
    final controller = WorkoutProgressController(
      workoutPlanRepository: InMemoryWorkoutPlanRepository(),
      workoutDayRepository: InMemoryWorkoutDayRepository(),
      workoutHistoryRepository: InMemoryWorkoutHistoryRepository(),
      progressService: const WorkoutProgressService(),
    );

    await tester.pumpWidget(
      MaterialApp(home: ProgressScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('BUILD YOUR PERFORMANCE DATA'), findsOneWidget);
  });

  testWidgets('Dashboard opens Progress', (tester) async {
    RepositoryRegistry.workoutPlanRepository = InMemoryWorkoutPlanRepository();
    RepositoryRegistry.workoutDayRepository = InMemoryWorkoutDayRepository();
    RepositoryRegistry.workoutHistoryRepository =
        InMemoryWorkoutHistoryRepository();

    await tester.pumpWidget(
      WorkoutCompanionApp(
        router: createAppRouter(
          startupVideoPlayerFactory: CompletingStartupVideoPlayer.new,
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (var index = 0; index < 4; index += 1) {
      await tester.fling(find.byType(PageView), const Offset(-500, 0), 1200);
      await tester.pumpAndSettle();
    }
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('lobby-card-Progress')),
        matching: find.text('ENTER'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.text('PROGRESS'), findsOneWidget);
    expect(find.text('BUILD YOUR PERFORMANCE DATA'), findsOneWidget);
  });

  testWidgets('derives recent activity bars from completed session dates', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final historyRepository = InMemoryWorkoutHistoryRepository();
    final now = DateUtils.dateOnly(
      DateTime.now(),
    ).add(const Duration(hours: 12));
    await historyRepository.saveSession(_sessionAt('today-1', now));
    await historyRepository.saveSession(
      _sessionAt('today-2', now.subtract(const Duration(hours: 1))),
    );
    await historyRepository.saveSession(
      _sessionAt('yesterday', now.subtract(const Duration(days: 1))),
    );
    final controller = WorkoutProgressController(
      workoutPlanRepository: InMemoryWorkoutPlanRepository(),
      workoutDayRepository: InMemoryWorkoutDayRepository(),
      workoutHistoryRepository: historyRepository,
      progressService: const WorkoutProgressService(),
    );

    await tester.pumpWidget(
      MaterialApp(home: ProgressScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    final todayKey = Key('activity-count-${_dayKey(now)}');
    final yesterdayKey = Key(
      'activity-count-${_dayKey(now.subtract(const Duration(days: 1)))}',
    );
    expect(
      find.text('3 COMPLETED SESSIONS IN THE LAST 7 DAYS'),
      findsOneWidget,
    );
    expect(find.byKey(todayKey), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(todayKey)).data, '2');
    expect(find.byKey(yesterdayKey), findsOneWidget);

    RepositoryRegistry.workoutHistoryRepository = historyRepository;
    await tester.tap(find.text('VIEW HISTORY'));
    await tester.pumpAndSettle();
    expect(find.text('TRAINING ARCHIVE'), findsOneWidget);
  });

  testWidgets('keeps the Performance HUD within a narrow portrait viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final historyRepository = InMemoryWorkoutHistoryRepository();
    await historyRepository.saveSession(
      _sessionAt(
        'narrow',
        DateUtils.dateOnly(DateTime.now()).add(const Duration(hours: 12)),
      ),
    );
    final controller = WorkoutProgressController(
      workoutPlanRepository: InMemoryWorkoutPlanRepository(),
      workoutDayRepository: InMemoryWorkoutDayRepository(),
      workoutHistoryRepository: historyRepository,
      progressService: const WorkoutProgressService(),
    );

    await tester.pumpWidget(
      MaterialApp(home: ProgressScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

CompletedWorkoutSession _sessionAt(String id, DateTime completedAt) {
  return CompletedWorkoutSession(
    id: id,
    workoutPlanId: 'historic-plan',
    workoutPlanName: 'Historic Plan',
    workoutDayId: 'historic-day',
    workoutDayName: 'Historic Day',
    startedAt: completedAt.subtract(const Duration(minutes: 20)),
    completedAt: completedAt,
    durationInSeconds: 1200,
    completedExercises: 2,
    totalExercises: 2,
    wasCompleted: true,
  );
}

String _dayKey(DateTime dateTime) {
  final date = DateUtils.dateOnly(dateTime.toLocal());
  return date.toIso8601String().substring(0, 10);
}

Future<void> _seedProgressData({
  required InMemoryWorkoutPlanRepository planRepository,
  required InMemoryWorkoutDayRepository dayRepository,
  required InMemoryWorkoutHistoryRepository historyRepository,
}) async {
  const planId = 'plan-1';
  await planRepository.saveWorkoutPlan(
    WorkoutPlan(
      id: planId,
      name: 'Strength Plan',
      description: '',
      category: WorkoutPlanCategory.strength,
      difficulty: WorkoutPlanDifficulty.beginner,
      estimatedDurationInMinutes: 30,
    ),
  );
  await dayRepository.saveWorkoutDay(
    const WorkoutDay(
      id: 'day-1',
      workoutPlanId: planId,
      dayNumber: 1,
      name: 'Workout One',
      description: '',
    ),
  );
  await dayRepository.saveWorkoutDay(
    const WorkoutDay(
      id: 'day-2',
      workoutPlanId: planId,
      dayNumber: 2,
      name: 'Recovery',
      description: '',
      isRestDay: true,
    ),
  );
  await dayRepository.saveWorkoutDay(
    const WorkoutDay(
      id: 'day-3',
      workoutPlanId: planId,
      dayNumber: 3,
      name: 'Workout Two',
      description: '',
    ),
  );
  await dayRepository.saveWorkoutDay(
    const WorkoutDay(
      id: 'day-4',
      workoutPlanId: planId,
      dayNumber: 4,
      name: 'Workout Three',
      description: '',
    ),
  );
  await historyRepository.saveSession(_session('session-1', 'day-1'));
  await historyRepository.saveSession(_session('session-2', 'day-1'));
  await historyRepository.saveSession(_session('session-3', 'day-3'));
}

CompletedWorkoutSession _session(String id, String dayId) {
  final startedAt = DateTime.utc(2026, 1, 1);
  return CompletedWorkoutSession(
    id: id,
    workoutPlanId: 'plan-1',
    workoutPlanName: 'Strength Plan',
    workoutDayId: dayId,
    workoutDayName: dayId,
    startedAt: startedAt,
    completedAt: startedAt.add(const Duration(minutes: 30)),
    durationInSeconds: 1800,
    completedExercises: 2,
    totalExercises: 2,
    wasCompleted: true,
  );
}
