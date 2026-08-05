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
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.remainingSeconds = 0,
    this.status = WorkoutSessionStatus.notStarted,
  });

  final List<WorkoutExercise> workoutExercises;

  final int currentExerciseIndex;

  final int currentSet;

  final int remainingSeconds;

  final WorkoutSessionStatus status;

  WorkoutExercise get currentExercise =>
      workoutExercises[currentExerciseIndex];

  bool get hasNextExercise =>
      currentExerciseIndex < workoutExercises.length - 1;

  WorkoutSession copyWith({
    List<WorkoutExercise>? workoutExercises,
    int? currentExerciseIndex,
    int? currentSet,
    int? remainingSeconds,
    WorkoutSessionStatus? status,
  }) {
    return WorkoutSession(
      workoutExercises:
          workoutExercises ?? this.workoutExercises,
      currentExerciseIndex:
          currentExerciseIndex ??
          this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      remainingSeconds:
          remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
    );
  }
}