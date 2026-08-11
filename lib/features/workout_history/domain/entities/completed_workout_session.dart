class CompletedWorkoutSession {
  const CompletedWorkoutSession({
    required this.id,
    required this.workoutPlanId,
    required this.workoutPlanName,
    required this.startedAt,
    required this.completedAt,
    required this.durationInSeconds,
    required this.completedExercises,
    required this.totalExercises,
    required this.wasCompleted,
    this.workoutDayId,
    this.workoutDayName,
    this.notes = '',
  });

  final String id;

  final String workoutPlanId;

  final String workoutPlanName;

  final DateTime startedAt;

  final DateTime completedAt;

  final int durationInSeconds;

  final int completedExercises;

  final int totalExercises;

  final bool wasCompleted;
  final String? workoutDayId;
  final String? workoutDayName;

  final String notes;

  Duration get duration =>
      Duration(seconds: durationInSeconds);

  double get completionPercentage {
    if (totalExercises == 0) {
      return 0;
    }

    return completedExercises / totalExercises;
  }
}
