class WorkoutStatisticsView {
  const WorkoutStatisticsView({
    required this.totalWorkouts,
    required this.totalDuration,
    required this.averageDuration,
    required this.completionRate,
  });

  final int totalWorkouts;

  final Duration totalDuration;

  final Duration averageDuration;

  final double completionRate;

  String get formattedCompletionRate =>
      '${(completionRate * 100).toStringAsFixed(1)}%';

  String get formattedTotalDuration {
    final hours = totalDuration.inHours;
    final minutes =
        totalDuration.inMinutes.remainder(60);

    return '${hours}h ${minutes}m';
  }

  String get formattedAverageDuration {
    final minutes =
        averageDuration.inMinutes;

    final seconds =
        averageDuration.inSeconds.remainder(60);

    return '${minutes}m ${seconds}s';
  }
}