import 'package:flutter/material.dart';

import '../../../workout_history/domain/entities/completed_workout_session.dart';

class WorkoutCompletionScreen extends StatelessWidget {
  const WorkoutCompletionScreen({
    super.key,
    required this.session,
  });

  final CompletedWorkoutSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Complete')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, size: 80),
            const SizedBox(height: 20),
            Text(
              session.workoutPlanName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (session.workoutDayName != null) ...[
              const SizedBox(height: 4),
              Text(session.workoutDayName!, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 32),
            _SummaryRow(
              label: 'Exercises completed',
              value: '${session.completedExercises} of ${session.totalExercises}',
            ),
            _SummaryRow(
              label: 'Duration',
              value: '${session.durationInSeconds} seconds',
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
