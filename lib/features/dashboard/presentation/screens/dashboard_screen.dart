import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../workout_history/domain/services/workout_statistics_service.dart';
import '../../../workout_history/presentation/controllers/workout_history_controller.dart';
import '../../../workout_history/presentation/screens/workout_statistics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final WorkoutHistoryController _historyController;

  @override
  void initState() {
    super.initState();
    _historyController = WorkoutHistoryController.create(
      repository: RepositoryRegistry.workoutHistoryRepository,
      statisticsService: const WorkoutStatisticsService(),
    )..loadSessions();
  }

  @override
  void dispose() {
    _historyController.dispose();
    super.dispose();
  }

  void _openStatistics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutStatisticsScreen(controller: _historyController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Companion'),
        actions: [
          IconButton(
            onPressed: () => context.push('/developer'),
            tooltip: 'Developer tools',
            icon: const Icon(Icons.developer_mode_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _historyController.loadSessions,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Dashboard', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Start your next session, review recent progress, or manage your workout plans.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('/workout-plans'),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Workout'),
            ),
            const SizedBox(height: 16),
            _DashboardLinkCard(
              icon: Icons.assignment_outlined,
              title: 'Workout Plans',
              subtitle: 'Build plans and choose a workout day to start.',
              onTap: () => context.push('/workout-plans'),
            ),
            _DashboardLinkCard(
              icon: Icons.history,
              title: 'Workout History',
              subtitle: 'Review completed workouts and session details.',
              onTap: () => context.push('/workout-history'),
            ),
            const SizedBox(height: 16),
            _StatisticsSummary(
              controller: _historyController,
              onOpenStatistics: _openStatistics,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardLinkCard extends StatelessWidget {
  const _DashboardLinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _StatisticsSummary extends StatelessWidget {
  const _StatisticsSummary({
    required this.controller,
    required this.onOpenStatistics,
  });

  final WorkoutHistoryController controller;
  final VoidCallback onOpenStatistics;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const SizedBox(
            height: 180,
            child: AppLoadingIndicator(message: 'Loading statistics...'),
          );
        }

        if (controller.errorMessage != null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Statistics unavailable'),
                  const SizedBox(height: 8),
                  Text(controller.errorMessage!),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: controller.loadSessions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.sessions.isEmpty) {
          return const SizedBox(
            height: 220,
            child: AppEmptyState(
              title: 'No workout history yet',
              message: 'Complete a workout to see your dashboard statistics.',
              icon: Icons.insights_outlined,
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Statistics',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: onOpenStatistics,
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _StatisticRow(
                  label: 'Completed Workouts',
                  value: '${controller.completedWorkouts}',
                ),
                _StatisticRow(
                  label: 'Total Duration',
                  value: _formatDuration(controller.totalDurationInSeconds),
                ),
                _StatisticRow(
                  label: 'Average Workout',
                  value: _formatDuration(
                    controller.averageWorkoutDuration.round(),
                  ),
                ),
                _StatisticRow(
                  label: 'Completion Rate',
                  value:
                      '${(controller.completionRate * 100).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),
        );
      },
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

class _StatisticRow extends StatelessWidget {
  const _StatisticRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
