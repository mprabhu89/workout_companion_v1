import '../../../workout_exercise/domain/entities/workout_exercise.dart';

enum WorkoutSessionStatus {
  notStarted,
  countdown,
  exercising,
  resting,
  paused,
  completed,
}

class WorkoutSession {
  const WorkoutSession({
    required this.workoutExercises,
    this.workoutPlanId,
    this.workoutPlanName,
    this.workoutDayId,
    this.workoutDayName,
    this.startedAt,
    this.completedAt,
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.remainingSeconds = 0,
    this.status = WorkoutSessionStatus.notStarted,
  });

  final List<WorkoutExercise> workoutExercises;
  final String? workoutPlanId;
  final String? workoutPlanName;
  final String? workoutDayId;
  final String? workoutDayName;
  final DateTime? startedAt;
  final DateTime? completedAt;

  final int currentExerciseIndex;

  final int currentSet;

  final int remainingSeconds;

  final WorkoutSessionStatus status;

  WorkoutExercise get currentExercise =>
      workoutExercises[currentExerciseIndex];

  bool get hasNextExercise =>
      currentExerciseIndex < workoutExercises.length - 1;

  bool get hasPreviousExercise =>
      currentExerciseIndex > 0;

  WorkoutSession copyWith({
    List<WorkoutExercise>? workoutExercises,
    String? workoutPlanId,
    String? workoutPlanName,
    String? workoutDayId,
    String? workoutDayName,
    DateTime? startedAt,
    DateTime? completedAt,
    int? currentExerciseIndex,
    int? currentSet,
    int? remainingSeconds,
    WorkoutSessionStatus? status,
  }) {
    return WorkoutSession(
      workoutExercises:
          workoutExercises ?? this.workoutExercises,
      workoutPlanId: workoutPlanId ?? this.workoutPlanId,
      workoutPlanName: workoutPlanName ?? this.workoutPlanName,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      workoutDayName: workoutDayName ?? this.workoutDayName,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      currentExerciseIndex:
          currentExerciseIndex ??
          this.currentExerciseIndex,
      currentSet:
          currentSet ?? this.currentSet,
      remainingSeconds:
          remainingSeconds ??
          this.remainingSeconds,
      status:
          status ?? this.status,
    );
  }
}
