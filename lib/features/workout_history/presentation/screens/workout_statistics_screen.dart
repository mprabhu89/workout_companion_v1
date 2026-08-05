import 'package:flutter/material.dart';

import '../controllers/workout_history_controller.dart';

class WorkoutStatisticsScreen extends StatelessWidget {
  const WorkoutStatisticsScreen({
    super.key,
    required this.controller,
  });

  final WorkoutHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Statistics'),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatisticCard(
                title: 'Total Workouts',
                value:
                    '${controller.totalWorkouts}',
              ),
              _StatisticCard(
                title: 'Completed Workouts',
                value:
                    '${controller.completedWorkouts}',
              ),
              _StatisticCard(
                title: 'Completion Rate',
                value:
                    '${(controller.completionRate * 100).toStringAsFixed(1)}%',
              ),
              _StatisticCard(
                title: 'Total Duration',
                value:
                    '${controller.totalDurationInSeconds} sec',
              ),
              _StatisticCard(
                title: 'Average Workout',
                value:
                    '${controller.averageWorkoutDuration.toStringAsFixed(1)} sec',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
      ),
    );
  }
}