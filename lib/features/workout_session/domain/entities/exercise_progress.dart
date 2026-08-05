enum ExerciseProgressStatus {
  notStarted,
  inProgress,
  completed,
  skipped,
}

class ExerciseProgress {
  const ExerciseProgress({
    required this.id,
    required this.sessionId,
    required this.workoutExerciseId,
    this.currentSet = 1,
    this.completedSets = 0,
    this.completedRepetitions = 0,
    this.elapsedSeconds = 0,
    this.status = ExerciseProgressStatus.notStarted,
  });

  final String id;

  final String sessionId;

  final String workoutExerciseId;

  final int currentSet;

  final int completedSets;

  final int completedRepetitions;

  final int elapsedSeconds;

  final ExerciseProgressStatus status;

  ExerciseProgress copyWith({
    String? id,
    String? sessionId,
    String? workoutExerciseId,
    int? currentSet,
    int? completedSets,
    int? completedRepetitions,
    int? elapsedSeconds,
    ExerciseProgressStatus? status,
  }) {
    return ExerciseProgress(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      workoutExerciseId:
          workoutExerciseId ?? this.workoutExerciseId,
      currentSet: currentSet ?? this.currentSet,
      completedSets:
          completedSets ?? this.completedSets,
      completedRepetitions:
          completedRepetitions ??
              this.completedRepetitions,
      elapsedSeconds:
          elapsedSeconds ?? this.elapsedSeconds,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseProgress &&
          id == other.id &&
          sessionId == other.sessionId &&
          workoutExerciseId ==
              other.workoutExerciseId &&
          currentSet == other.currentSet &&
          completedSets == other.completedSets &&
          completedRepetitions ==
              other.completedRepetitions &&
          elapsedSeconds == other.elapsedSeconds &&
          status == other.status;

  @override
  int get hashCode => Object.hash(
        id,
        sessionId,
        workoutExerciseId,
        currentSet,
        completedSets,
        completedRepetitions,
        elapsedSeconds,
        status,
      );

  @override
  String toString() {
    return 'ExerciseProgress('
        'exerciseId: $workoutExerciseId, '
        'status: $status'
        ')';
  }
}