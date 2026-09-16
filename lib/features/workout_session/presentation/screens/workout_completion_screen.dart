import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../workout_history/domain/entities/completed_workout_session.dart';

class WorkoutCompletionScreen extends StatelessWidget {
  const WorkoutCompletionScreen({super.key, required this.session});

  final CompletedWorkoutSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  'MISSION COMPLETE',
                  style: TextStyle(
                    color: ritmoCyan,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/branding/ritmo_mascot_success.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 14),
                Text(
                  'Workout Complete',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  session.workoutPlanName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFABC2C8)),
                ),
                if (session.workoutDayName != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    session.workoutDayName!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ritmoOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                RitmoHudPanel(
                  glowStrength: 0.38,
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryMetric(
                          label: 'EXERCISES',
                          value:
                              '${session.completedExercises} / ${session.totalExercises}',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 38,
                        color: const Color(0xFF31535C),
                      ),
                      Expanded(
                        child: _SummaryMetric(
                          label: 'TRAINING TIME',
                          value: '${session.durationInSeconds}s',
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                RitmoActionButton(
                  label: 'Back to Day Overview',
                  onPressed: () => Navigator.of(context).pop(),
                  isPulsing: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF9EB8BE),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
