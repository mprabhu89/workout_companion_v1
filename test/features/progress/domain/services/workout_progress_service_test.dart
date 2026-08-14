import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/progress/domain/models/workout_progress.dart';
import 'package:workout_companion_v1/features/progress/domain/services/workout_progress_service.dart';
import 'package:workout_companion_v1/features/workout_day/domain/entities/workout_day.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/entities/workout_plan.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_difficulty.dart';

void main() {
  const service = WorkoutProgressService();

  group('WorkoutProgressService', () {
    test('handles empty plans and history safely', () {
      final summary = service.calculate(
        workoutPlans: const [],
        workoutDaysByPlanId: const {},
        workoutSessions: const [],
      );

      expect(summary.overall.plannedWorkouts, 0);
      expect(summary.overall.completedPlannedWorkouts, 0);
      expect(summary.overall.completionPercentage, 0);
      expect(summary.overall.actualSessions, 0);
      expect(summary.hasPlannedWorkouts, isFalse);
    });

    test('shows no completed days for a plan with no history', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [_day('day-1', 'plan-1', 1)],
      );

      expect(summary.plans.single.metrics.plannedWorkouts, 1);
      expect(summary.plans.single.metrics.completedPlannedWorkouts, 0);
      expect(summary.plans.single.metrics.completionPercentage, 0);
    });

    test('counts a completed planned day only once', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [_day('day-1', 'plan-1', 1), _day('day-2', 'plan-1', 2)],
        sessions: [
          _session('session-1', 'plan-1', 'day-1'),
          _session('session-2', 'plan-1', 'day-1'),
        ],
      );

      expect(summary.plans.single.metrics.completedPlannedWorkouts, 1);
      expect(summary.plans.single.metrics.plannedWorkouts, 2);
    });

    test(
      'repeated sessions increase actual sessions but not plan completion',
      () {
        final summary = _calculate(
          plans: [_plan('plan-1')],
          days: [_day('day-1', 'plan-1', 1)],
          sessions: [
            _session('session-1', 'plan-1', 'day-1'),
            _session('session-2', 'plan-1', 'day-1'),
            _session('session-3', 'plan-1', 'day-1'),
          ],
        );

        expect(summary.plans.single.metrics.actualSessions, 3);
        expect(summary.plans.single.metrics.completedPlannedWorkouts, 1);
        expect(summary.plans.single.days.single.completedSessionCount, 3);
      },
    );

    test('excludes rest days from planned completion totals', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [
          _day('day-workout', 'plan-1', 1),
          _day('day-rest', 'plan-1', 2, isRestDay: true),
        ],
        sessions: [_session('session-1', 'plan-1', 'day-rest')],
      );

      expect(summary.plans.single.metrics.plannedWorkouts, 1);
      expect(summary.plans.single.metrics.completedPlannedWorkouts, 0);
      expect(summary.plans.single.days.last.completedSessionCount, 0);
    });

    test('excludes archived workout days from planned totals', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [
          _day('day-active', 'plan-1', 1),
          _day('day-archived', 'plan-1', 2, isArchived: true),
        ],
        sessions: [_session('session-1', 'plan-1', 'day-archived')],
      );

      expect(summary.plans.single.metrics.plannedWorkouts, 1);
      expect(summary.plans.single.metrics.completedPlannedWorkouts, 0);
      expect(summary.plans.single.days, hasLength(1));
    });

    test('excludes archived plans from overall planned totals', () {
      final summary = _calculate(
        plans: [_plan('plan-active'), _plan('plan-archived', isArchived: true)],
        days: [
          _day('day-active', 'plan-active', 1),
          _day('day-archived-plan', 'plan-archived', 1),
        ],
        sessions: [_session('session-1', 'plan-archived', 'day-archived-plan')],
      );

      expect(summary.plans, hasLength(1));
      expect(summary.overall.plannedWorkouts, 1);
      expect(summary.overall.completedPlannedWorkouts, 0);
    });

    test('aggregates multiple active plans independently', () {
      final summary = _calculate(
        plans: [_plan('plan-1'), _plan('plan-2')],
        days: [_day('day-1', 'plan-1', 1), _day('day-2', 'plan-2', 1)],
        sessions: [_session('session-1', 'plan-2', 'day-2')],
      );

      expect(summary.overall.plannedWorkouts, 2);
      expect(summary.overall.completedPlannedWorkouts, 1);
      expect(summary.overall.completionPercentage, 50);
    });

    test('counts only completed history records', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [_day('day-1', 'plan-1', 1)],
        sessions: [
          _session('completed', 'plan-1', 'day-1'),
          _session('incomplete', 'plan-1', 'day-1', wasCompleted: false),
        ],
      );

      expect(summary.overall.actualSessions, 1);
      expect(summary.overall.completedPlannedWorkouts, 1);
    });

    test('sums completed session durations', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [_day('day-1', 'plan-1', 1)],
        sessions: [
          _session('session-1', 'plan-1', 'day-1', duration: 60),
          _session('session-2', 'plan-1', 'day-1', duration: 120),
          _session(
            'incomplete',
            'plan-1',
            'day-1',
            duration: 999,
            wasCompleted: false,
          ),
        ],
      );

      expect(summary.overall.totalDurationInSeconds, 180);
      expect(summary.plans.single.metrics.totalDurationInSeconds, 180);
    });

    test('uses zero percentage when no planned workout days exist', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [_day('day-rest', 'plan-1', 1, isRestDay: true)],
      );

      expect(summary.overall.completionPercentage, 0);
      expect(summary.plans.single.metrics.completionPercentage, 0);
    });

    test('orders plan detail days by day number', () {
      final summary = _calculate(
        plans: [_plan('plan-1')],
        days: [
          _day('day-3', 'plan-1', 3),
          _day('day-1', 'plan-1', 1),
          _day('day-2', 'plan-1', 2),
        ],
      );

      expect(summary.plans.single.days.map((progress) => progress.day.id), [
        'day-1',
        'day-2',
        'day-3',
      ]);
    });
  });
}

WorkoutProgressSummary _calculate({
  required List<WorkoutPlan> plans,
  required List<WorkoutDay> days,
  List<CompletedWorkoutSession> sessions = const [],
}) {
  final daysByPlanId = <String, List<WorkoutDay>>{};
  for (final day in days) {
    daysByPlanId.putIfAbsent(day.workoutPlanId, () => []).add(day);
  }

  return const WorkoutProgressService().calculate(
    workoutPlans: plans,
    workoutDaysByPlanId: daysByPlanId,
    workoutSessions: sessions,
  );
}

WorkoutPlan _plan(String id, {bool isArchived = false}) {
  return WorkoutPlan(
    id: id,
    name: id,
    description: '',
    category: WorkoutPlanCategory.strength,
    difficulty: WorkoutPlanDifficulty.beginner,
    estimatedDurationInMinutes: 30,
    isArchived: isArchived,
  );
}

WorkoutDay _day(
  String id,
  String workoutPlanId,
  int dayNumber, {
  bool isRestDay = false,
  bool isArchived = false,
}) {
  return WorkoutDay(
    id: id,
    workoutPlanId: workoutPlanId,
    dayNumber: dayNumber,
    name: id,
    description: '',
    isRestDay: isRestDay,
    isArchived: isArchived,
  );
}

CompletedWorkoutSession _session(
  String id,
  String workoutPlanId,
  String workoutDayId, {
  int duration = 60,
  bool wasCompleted = true,
}) {
  final startedAt = DateTime.utc(2026, 1, 1);
  return CompletedWorkoutSession(
    id: id,
    workoutPlanId: workoutPlanId,
    workoutPlanName: workoutPlanId,
    workoutDayId: workoutDayId,
    workoutDayName: workoutDayId,
    startedAt: startedAt,
    completedAt: startedAt.add(Duration(seconds: duration)),
    durationInSeconds: duration,
    completedExercises: 1,
    totalExercises: 1,
    wasCompleted: wasCompleted,
  );
}
