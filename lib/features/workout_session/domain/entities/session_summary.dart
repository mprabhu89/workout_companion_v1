class SessionSummary {
  const SessionSummary({
    required this.sessionId,
    required this.startedAt,
    required this.completedAt,
    required this.totalWorkoutSeconds,
    required this.totalExercises,
    required this.completedExercises,
    required this.skippedExercises,
    required this.totalSetsCompleted,
    required this.totalRepetitionsCompleted,
  });

  final String sessionId;

  final DateTime startedAt;
  final DateTime completedAt;

  /// Total workout duration in seconds.
  final int totalWorkoutSeconds;

  final int totalExercises;
  final int completedExercises;
  final int skippedExercises;

  final int totalSetsCompleted;
  final int totalRepetitionsCompleted;

  double get completionPercentage {
    if (totalExercises == 0) {
      return 0;
    }

    return (completedExercises / totalExercises) * 100;
  }

  Duration get totalDuration =>
      Duration(seconds: totalWorkoutSeconds);

  SessionSummary copyWith({
    String? sessionId,
    DateTime? startedAt,
    DateTime? completedAt,
    int? totalWorkoutSeconds,
    int? totalExercises,
    int? completedExercises,
    int? skippedExercises,
    int? totalSetsCompleted,
    int? totalRepetitionsCompleted,
  }) {
    return SessionSummary(
      sessionId: sessionId ?? this.sessionId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalWorkoutSeconds:
          totalWorkoutSeconds ?? this.totalWorkoutSeconds,
      totalExercises:
          totalExercises ?? this.totalExercises,
      completedExercises:
          completedExercises ?? this.completedExercises,
      skippedExercises:
          skippedExercises ?? this.skippedExercises,
      totalSetsCompleted:
          totalSetsCompleted ?? this.totalSetsCompleted,
      totalRepetitionsCompleted:
          totalRepetitionsCompleted ??
              this.totalRepetitionsCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionSummary &&
          sessionId == other.sessionId &&
          startedAt == other.startedAt &&
          completedAt == other.completedAt &&
          totalWorkoutSeconds ==
              other.totalWorkoutSeconds &&
          totalExercises == other.totalExercises &&
          completedExercises ==
              other.completedExercises &&
          skippedExercises ==
              other.skippedExercises &&
          totalSetsCompleted ==
              other.totalSetsCompleted &&
          totalRepetitionsCompleted ==
              other.totalRepetitionsCompleted;

  @override
  int get hashCode => Object.hash(
        sessionId,
        startedAt,
        completedAt,
        totalWorkoutSeconds,
        totalExercises,
        completedExercises,
        skippedExercises,
        totalSetsCompleted,
        totalRepetitionsCompleted,
      );

  @override
  String toString() {
    return 'SessionSummary('
        'sessionId: $sessionId, '
        'completion: ${completionPercentage.toStringAsFixed(1)}%'
        ')';
  }
}