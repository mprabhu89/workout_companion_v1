import 'package:flutter/material.dart';

import '../../domain/models/workout_progress.dart';

class PlanProgressDetailsScreen extends StatelessWidget {
  const PlanProgressDetailsScreen({super.key, required this.progress});

  final WorkoutPlanProgress progress;

  @override
  Widget build(BuildContext context) {
    final metrics = progress.metrics;

    return Scaffold(
      appBar: AppBar(title: const Text('Plan Progress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            progress.plan.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _MetricRow(
                    label: 'Completed Planned Workouts',
                    value:
                        '${metrics.completedPlannedWorkouts} / ${metrics.plannedWorkouts}',
                  ),
                  _MetricRow(
                    label: 'Completion',
                    value:
                        '${metrics.completionPercentage.toStringAsFixed(0)}%',
                  ),
                  _MetricRow(
                    label: 'Actual Sessions',
                    value: '${metrics.actualSessions}',
                  ),
                  _MetricRow(
                    label: 'Total Workout Time',
                    value: _formatDuration(metrics.totalDurationInSeconds),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Workout Days', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...progress.days.map((dayProgress) => _DayProgressCard(dayProgress)),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    if (minutes > 0) {
      return '${minutes}m';
    }
    return '${duration.inSeconds}s';
  }
}

class _DayProgressCard extends StatelessWidget {
  const _DayProgressCard(this.progress);

  final WorkoutDayProgress progress;

  @override
  Widget build(BuildContext context) {
    final day = progress.day;
    final status = day.isRestDay
        ? 'Rest Day'
        : progress.isCompleted
        ? progress.completedSessionCount > 1
              ? 'Completed ${progress.completedSessionCount} times'
              : 'Completed'
        : 'Not Completed';

    return Card(
      child: ListTile(
        title: Text('Day ${day.dayNumber}: ${day.name}'),
        subtitle: day.description.isEmpty ? null : Text(day.description),
        trailing: Text(status),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
