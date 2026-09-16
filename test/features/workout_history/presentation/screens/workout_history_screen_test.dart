import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_history/data/repositories/in_memory_workout_history_repository.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_history/domain/services/workout_statistics_service.dart';
import 'package:workout_companion_v1/features/workout_history/presentation/controllers/workout_history_controller.dart';
import 'package:workout_companion_v1/features/workout_history/presentation/screens/workout_history_screen.dart';

void main() {
  testWidgets(
    'renders factual archive records in chronological date groups and opens read-only detail',
    (tester) async {
      final repository = InMemoryWorkoutHistoryRepository();
      final now = DateUtils.dateOnly(
        DateTime.now(),
      ).add(const Duration(hours: 12));
      await repository.saveSession(
        _session(
          'older',
          'Mobility Plan',
          now.subtract(const Duration(days: 1, hours: 2)),
        ),
      );
      await repository.saveSession(
        _session(
          'latest',
          'Strength Plan',
          now.subtract(const Duration(minutes: 30)),
        ),
      );
      final controller = WorkoutHistoryController.create(
        repository: repository,
        statisticsService: const WorkoutStatisticsService(),
      );

      await tester.pumpWidget(
        MaterialApp(home: WorkoutHistoryScreen(controller: controller)),
      );
      await tester.pumpAndSettle();

      expect(find.text('HISTORY'), findsOneWidget);
      expect(find.text('TRAINING ARCHIVE'), findsOneWidget);
      expect(find.text('COMPLETED SESSIONS'), findsOneWidget);
      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('YESTERDAY'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Strength Plan')).dy,
        lessThan(tester.getTopLeft(find.text('Mobility Plan')).dy),
      );
      expect(find.textContaining('EXERCISES'), findsNWidgets(2));
      expect(find.text('SETS'), findsNothing);
      expect(find.text('CALORIES'), findsNothing);

      await tester.tap(find.text('Strength Plan'));
      await tester.pumpAndSettle();

      expect(find.text('SESSION RECORD'), findsNWidgets(2));
      expect(find.text('TRAINING TIME'), findsOneWidget);
      expect(find.text('EXERCISES'), findsOneWidget);
      expect(find.text('EDIT'), findsNothing);
    },
  );

  testWidgets(
    'renders the Training Archive empty state without zero-filled metrics',
    (tester) async {
      final controller = WorkoutHistoryController.create(
        repository: InMemoryWorkoutHistoryRepository(),
        statisticsService: const WorkoutStatisticsService(),
      );

      await tester.pumpWidget(
        MaterialApp(home: WorkoutHistoryScreen(controller: controller)),
      );
      await tester.pumpAndSettle();

      expect(find.text('YOUR JOURNEY STARTS HERE'), findsOneWidget);
      expect(find.text('COMPLETED SESSIONS'), findsNothing);
      expect(find.text('TRAINING TIME'), findsNothing);
    },
  );

  testWidgets('keeps archive cards within a narrow portrait viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = InMemoryWorkoutHistoryRepository();
    await repository.saveSession(
      _session(
        'long',
        'A Long Training Program Name That Must Stay Readable',
        DateUtils.dateOnly(DateTime.now()).add(const Duration(hours: 12)),
      ),
    );
    final controller = WorkoutHistoryController.create(
      repository: repository,
      statisticsService: const WorkoutStatisticsService(),
    );

    await tester.pumpWidget(
      MaterialApp(home: WorkoutHistoryScreen(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

CompletedWorkoutSession _session(
  String id,
  String planName,
  DateTime completedAt,
) {
  return CompletedWorkoutSession(
    id: id,
    workoutPlanId: '$id-plan',
    workoutPlanName: planName,
    workoutDayId: '$id-day',
    workoutDayName: '$planName Day',
    startedAt: completedAt.subtract(const Duration(minutes: 25)),
    completedAt: completedAt,
    durationInSeconds: 1500,
    completedExercises: 3,
    totalExercises: 3,
    wasCompleted: true,
  );
}
