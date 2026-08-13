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
    this.currentExerciseRound = 1,
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

  final int currentExerciseRound;

  final int currentSet;

  final int remainingSeconds;

  final WorkoutSessionStatus status;

  bool get hasExercises => workoutExercises.isNotEmpty;

  int get totalExercises => workoutExercises.length;

  int get currentExerciseNumber =>
      hasExercises ? currentExerciseIndex + 1 : 0;

  int get totalRoundsForCurrentExercise =>
      hasExercises
          ? currentExercise.sessionRepetitions
          : 0;

  int get completedExerciseCount {
    if (!hasExercises) {
      return 0;
    }

    if (status == WorkoutSessionStatus.completed) {
      return workoutExercises.length;
    }

    return currentExerciseIndex
        .clamp(
          0,
          workoutExercises.length,
        )
        .toInt();
  }

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
    int? currentExerciseRound,
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
      currentExerciseRound:
          currentExerciseRound ??
          this.currentExerciseRound,
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
