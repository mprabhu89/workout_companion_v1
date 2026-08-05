class WorkoutExecutionView {
  const WorkoutExecutionView({
    required this.exerciseName,
    required this.subtitle,
    required this.currentSetText,
    required this.timerText,
    required this.progress,
    required this.progressText,
    required this.isPaused,
  });

  final String exerciseName;

  final String subtitle;

  final String currentSetText;

  final String timerText;

  /// Value between 0 and 1
  final double progress;

  final String progressText;

  final bool isPaused;
}