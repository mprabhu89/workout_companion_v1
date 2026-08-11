import 'package:flutter/material.dart';

import '../../domain/entities/completed_workout_session.dart';

class WorkoutHistoryDetailsScreen extends StatelessWidget {
  const WorkoutHistoryDetailsScreen({super.key, required this.session});

  final CompletedWorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final completedAt = session.completedAt.toLocal();
    final startedAt = session.startedAt.toLocal();
    final date = MaterialLocalizations.of(
      context,
    ).formatMediumDate(completedAt);
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(completedAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            session.workoutPlanName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (session.workoutDayName != null) ...[
            const SizedBox(height: 4),
            Text(session.workoutDayName!),
          ],
          const SizedBox(height: 24),
          _DetailRow(
            label: 'Status',
            value: session.wasCompleted ? 'Completed' : 'Incomplete',
          ),
          _DetailRow(label: 'Completed', value: '$date at $time'),
          _DetailRow(
            label: 'Started',
            value: _formatDateTime(context, startedAt),
          ),
          _DetailRow(
            label: 'Duration',
            value: '${session.durationInSeconds} seconds',
          ),
          _DetailRow(
            label: 'Exercises',
            value: '${session.completedExercises} of ${session.totalExercises}',
          ),
          if (session.notes.isNotEmpty)
            _DetailRow(label: 'Notes', value: session.notes),
        ],
      ),
    );
  }

  String _formatDateTime(BuildContext context, DateTime value) {
    final localizations = MaterialLocalizations.of(context);
    return '${localizations.formatMediumDate(value)} at '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(value))}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
