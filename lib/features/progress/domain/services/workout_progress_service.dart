import '../../../workout_day/domain/entities/workout_day.dart';
import '../../../workout_history/domain/entities/completed_workout_session.dart';
import '../../../workout_plan/domain/entities/workout_plan.dart';
import '../models/workout_progress.dart';

class WorkoutProgressService {
  const WorkoutProgressService();

  WorkoutProgressSummary calculate({
    required List<WorkoutPlan> workoutPlans,
    required Map<String, List<WorkoutDay>> workoutDaysByPlanId,
    required List<CompletedWorkoutSession> workoutSessions,
  }) {
    final completedSessions = workoutSessions
        .where((session) => session.wasCompleted)
        .toList(growable: false);
    final activePlans = workoutPlans
        .where((plan) => !plan.isArchived)
        .toList(growable: false);

    final plans = activePlans
        .map(
          (plan) => _planProgress(
            plan: plan,
            workoutDays: workoutDaysByPlanId[plan.id] ?? const [],
            completedSessions: completedSessions,
          ),
        )
        .toList(growable: false);

    return WorkoutProgressSummary(
      overall: WorkoutProgressMetrics(
        completedPlannedWorkouts: plans.fold(
          0,
          (total, plan) => total + plan.metrics.completedPlannedWorkouts,
        ),
        plannedWorkouts: plans.fold(
          0,
          (total, plan) => total + plan.metrics.plannedWorkouts,
        ),
        actualSessions: completedSessions.length,
        totalDurationInSeconds: completedSessions.fold(
          0,
          (total, session) => total + session.durationInSeconds,
        ),
      ),
      plans: plans,
    );
  }

  WorkoutPlanProgress _planProgress({
    required WorkoutPlan plan,
    required List<WorkoutDay> workoutDays,
    required List<CompletedWorkoutSession> completedSessions,
  }) {
    final activeDays = workoutDays.where((day) => !day.isArchived).toList()
      ..sort((left, right) => left.dayNumber.compareTo(right.dayNumber));
    final planSessions = completedSessions
        .where((session) => session.workoutPlanId == plan.id)
        .toList(growable: false);
    final days = activeDays
        .map(
          (day) => WorkoutDayProgress(
            day: day,
            completedSessionCount: day.isRestDay
                ? 0
                : planSessions
                      .where((session) => session.workoutDayId == day.id)
                      .length,
          ),
        )
        .toList(growable: false);
    final plannedDays = days.where((day) => !day.day.isRestDay);

    return WorkoutPlanProgress(
      plan: plan,
      metrics: WorkoutProgressMetrics(
        completedPlannedWorkouts: plannedDays
            .where((day) => day.isCompleted)
            .length,
        plannedWorkouts: plannedDays.length,
        actualSessions: planSessions.length,
        totalDurationInSeconds: planSessions.fold(
          0,
          (total, session) => total + session.durationInSeconds,
        ),
      ),
      days: days,
    );
  }
}
