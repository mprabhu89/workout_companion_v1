import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../domain/models/workout_progress.dart';

class PlanProgressDetailsScreen extends StatelessWidget {
  const PlanProgressDetailsScreen({super.key, required this.progress});

  final WorkoutPlanProgress progress;

  @override
  Widget build(BuildContext context) {
    final metrics = progress.metrics;
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('PLAN PROGRESS'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RitmoCyberpunkBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            const RitmoHudSectionHeading(title: 'PERFORMANCE HUD'),
            const SizedBox(height: 14),
            RitmoHudPanel(
              glowStrength: 0.28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress.plan.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Metric(
                    label: 'PLANNED COMPLETION',
                    value:
                        '${metrics.completedPlannedWorkouts} / ${metrics.plannedWorkouts}',
                  ),
                  _Metric(
                    label: 'COMPLETION',
                    value:
                        '${metrics.completionPercentage.toStringAsFixed(0)}%',
                  ),
                  _Metric(
                    label: 'ACTUAL SESSIONS',
                    value: '${metrics.actualSessions}',
                  ),
                  _Metric(
                    label: 'TRAINING TIME',
                    value: _formatDuration(metrics.totalDurationInSeconds),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const RitmoHudSectionHeading(title: 'TRAINING DAYS'),
            const SizedBox(height: 10),
            ...progress.days.map(
              (dayProgress) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RitmoHudPanel(
                  padding: const EdgeInsets.all(14),
                  glowStrength: dayProgress.isCompleted ? 0.18 : 0.05,
                  child: Row(
                    children: [
                      Icon(
                        dayProgress.isCompleted
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        color: dayProgress.isCompleted
                            ? ritmoCyan
                            : const Color(0xFF78959B),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          dayProgress.day.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFD8FCFF),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '${dayProgress.completedSessionCount} SESSIONS',
                        style: const TextStyle(
                          color: Color(0xFFAAC5CA),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.isLast = false,
  });
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 13),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF88AAB0),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFD8FCFF),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

String _formatDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  if (duration.inHours > 0) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }
  if (duration.inMinutes > 0) return '${duration.inMinutes}m';
  return '${duration.inSeconds}s';
}
