import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../domain/models/workout_progress.dart';
import '../../domain/services/workout_progress_service.dart';
import '../controllers/workout_progress_controller.dart';
import 'plan_progress_details_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, this.controller});

  final WorkoutProgressController? controller;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final WorkoutProgressController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        WorkoutProgressController(
          workoutPlanRepository: RepositoryRegistry.workoutPlanRepository,
          workoutDayRepository: RepositoryRegistry.workoutDayRepository,
          workoutHistoryRepository: RepositoryRegistry.workoutHistoryRepository,
          progressService: const WorkoutProgressService(),
        );
    _controller.loadProgress();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const AppLoadingIndicator(message: 'Loading progress...');
          }

          if (_controller.errorMessage != null) {
            return _ProgressError(
              message: _controller.errorMessage!,
              onRetry: _controller.loadProgress,
            );
          }

          final summary = _controller.summary;
          if (summary == null || !summary.hasPlannedWorkouts) {
            return const AppEmptyState(
              title: 'No active workout plans',
              message: 'Create active non-rest workout days to track progress.',
              icon: Icons.insights_outlined,
            );
          }

          return _ProgressContent(summary: summary);
        },
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({required this.summary});

  final WorkoutProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final metrics = summary.overall;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Overall Completion',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ProgressMetricRow(
                  label: 'Completed Planned Workouts',
                  value:
                      '${metrics.completedPlannedWorkouts} / ${metrics.plannedWorkouts}',
                ),
                _ProgressMetricRow(
                  label: 'Completion',
                  value: '${metrics.completionPercentage.toStringAsFixed(0)}%',
                ),
                _ProgressMetricRow(
                  label: 'Actual Sessions',
                  value: '${metrics.actualSessions}',
                ),
                _ProgressMetricRow(
                  label: 'Total Workout Time',
                  value: _formatDuration(metrics.totalDurationInSeconds),
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Workout Plans', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...summary.plans.map(
          (plan) => Card(
            child: ListTile(
              title: Text(plan.plan.name),
              subtitle: Text(
                '${plan.metrics.completedPlannedWorkouts} / ${plan.metrics.plannedWorkouts} completed',
              ),
              trailing: Text(
                '${plan.metrics.completionPercentage.toStringAsFixed(0)}%',
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlanProgressDetailsScreen(progress: plan),
                ),
              ),
            ),
          ),
        ),
      ],
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

class _ProgressMetricRow extends StatelessWidget {
  const _ProgressMetricRow({
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

class _ProgressError extends StatelessWidget {
  const _ProgressError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Progress unavailable'),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
