import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../domain/entities/completed_workout_session.dart';

class WorkoutHistoryDetailsScreen extends StatelessWidget {
  const WorkoutHistoryDetailsScreen({super.key, required this.session});

  final CompletedWorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final completedAt = session.completedAt.toLocal();
    final startedAt = session.startedAt.toLocal();
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(title: const Text('SESSION RECORD')),
      body: RitmoCyberpunkBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: [
            const RitmoHudSectionHeading(title: 'SESSION RECORD'),
            const SizedBox(height: 16),
            RitmoHudPanel(
              glowStrength: 0.28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.workoutPlanName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (session.workoutDayName case final dayName?) ...[
                    const SizedBox(height: 5),
                    Text(dayName, style: const TextStyle(color: ritmoCyan)),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    session.wasCompleted ? 'COMPLETED' : 'INCOMPLETE',
                    style: TextStyle(
                      color: session.wasCompleted
                          ? ritmoCyan
                          : const Color(0xFF9AB0B4),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            RitmoHudPanel(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _DetailValue(
                    label: 'COMPLETED',
                    value: _formatDateTime(localizations, completedAt),
                  ),
                  _DetailValue(
                    label: 'STARTED',
                    value: _formatDateTime(localizations, startedAt),
                  ),
                  _DetailValue(
                    label: 'TRAINING TIME',
                    value: _formatDuration(session.durationInSeconds),
                  ),
                  _DetailValue(
                    label: 'EXERCISES',
                    value:
                        '${session.completedExercises} / ${session.totalExercises}',
                    isLast: session.notes.isEmpty,
                  ),
                  if (session.notes.isNotEmpty)
                    _DetailValue(
                      label: 'NOTES',
                      value: session.notes,
                      isLast: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(MaterialLocalizations localizations, DateTime value) {
    return '${localizations.formatMediumDate(value)}  //  '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(value))}';
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({
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
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF88AAB0),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(color: Color(0xFFD8FCFF))),
        ],
      ),
    );
  }
}

String _formatDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  if (duration.inHours > 0) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }
  if (duration.inMinutes > 0) return '${duration.inMinutes}m';
  return '${duration.inSeconds}s';
}
