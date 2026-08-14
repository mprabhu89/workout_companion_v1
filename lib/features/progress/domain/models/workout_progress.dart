import '../../../workout_day/domain/entities/workout_day.dart';
import '../../../workout_plan/domain/entities/workout_plan.dart';

class WorkoutProgressSummary {
  const WorkoutProgressSummary({required this.overall, required this.plans});

  final WorkoutProgressMetrics overall;
  final List<WorkoutPlanProgress> plans;

  bool get hasPlannedWorkouts => overall.plannedWorkouts > 0;
}

class WorkoutProgressMetrics {
  const WorkoutProgressMetrics({
    required this.completedPlannedWorkouts,
    required this.plannedWorkouts,
    required this.actualSessions,
    required this.totalDurationInSeconds,
  });

  final int completedPlannedWorkouts;
  final int plannedWorkouts;
  final int actualSessions;
  final int totalDurationInSeconds;

  double get completionPercentage {
    if (plannedWorkouts == 0) {
      return 0;
    }

    return completedPlannedWorkouts / plannedWorkouts * 100;
  }
}

class WorkoutPlanProgress {
  const WorkoutPlanProgress({
    required this.plan,
    required this.metrics,
    required this.days,
  });

  final WorkoutPlan plan;
  final WorkoutProgressMetrics metrics;
  final List<WorkoutDayProgress> days;
}

class WorkoutDayProgress {
  const WorkoutDayProgress({
    required this.day,
    required this.completedSessionCount,
  });

  final WorkoutDay day;
  final int completedSessionCount;

  bool get isCompleted => completedSessionCount > 0;
}
