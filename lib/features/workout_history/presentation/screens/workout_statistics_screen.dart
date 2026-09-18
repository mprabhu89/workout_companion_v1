import 'package:flutter/material.dart';

import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../controllers/workout_history_controller.dart';

class WorkoutStatisticsScreen extends StatelessWidget {
  const WorkoutStatisticsScreen({super.key, required this.controller});

  final WorkoutHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('TRAINING STATISTICS'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RitmoCyberpunkBackground(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            if (controller.isLoading) {
              return const AppLoadingIndicator(
                message: 'Loading training data...',
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              children: [
                const RitmoHudSectionHeading(title: 'TRAINING ARCHIVE'),
                const SizedBox(height: 14),
                _StatisticHudCard(
                  title: 'TOTAL WORKOUTS',
                  value: '${controller.totalWorkouts}',
                ),
                _StatisticHudCard(
                  title: 'COMPLETED WORKOUTS',
                  value: '${controller.completedWorkouts}',
                ),
                _StatisticHudCard(
                  title: 'COMPLETION RATE',
                  value:
                      '${(controller.completionRate * 100).toStringAsFixed(1)}%',
                ),
                _StatisticHudCard(
                  title: 'TOTAL TRAINING TIME',
                  value: _formatDuration(controller.totalDurationInSeconds),
                ),
                _StatisticHudCard(
                  title: 'AVERAGE WORKOUT',
                  value: _formatDuration(
                    controller.averageWorkoutDuration.round(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatisticHudCard extends StatelessWidget {
  const _StatisticHudCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: RitmoHudPanel(
      padding: const EdgeInsets.all(14),
      glowStrength: 0.12,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFA9C6CB),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.9,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFD8FCFF),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
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
