import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_card.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../domain/entities/completed_workout_session.dart';
import '../../domain/services/workout_statistics_service.dart';
import '../controllers/workout_history_controller.dart';
import 'workout_history_details_screen.dart';
import 'workout_statistics_screen.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  late final WorkoutHistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WorkoutHistoryController.create(
      repository: RepositoryRegistry.workoutHistoryRepository,
      statisticsService: const WorkoutStatisticsService(),
    )..loadSessions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openStatistics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutStatisticsScreen(controller: _controller),
      ),
    );
  }

  void _openSession(CompletedWorkoutSession session) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutHistoryDetailsScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        actions: [
          IconButton(
            onPressed: _openStatistics,
            tooltip: 'Statistics',
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const AppLoadingIndicator(
              message: 'Loading workout history...',
            );
          }

          if (_controller.errorMessage != null) {
            return _HistoryError(
              message: _controller.errorMessage!,
              onRetry: _controller.loadSessions,
            );
          }

          if (_controller.sessions.isEmpty) {
            return const AppEmptyState(
              title: 'No workout history yet',
              message: 'Completed workouts will appear here.',
              icon: Icons.history,
            );
          }

          return RefreshIndicator(
            onRefresh: _controller.loadSessions,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _controller.sessions.length,
              itemBuilder: (context, index) {
                final session = _controller.sessions[index];
                return _HistoryCard(
                  session: session,
                  onTap: () => _openSession(session),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.session, required this.onTap});

  final CompletedWorkoutSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localDate = session.completedAt.toLocal();
    final date = MaterialLocalizations.of(context).formatMediumDate(localDate);
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(localDate));
    final day = session.workoutDayName;
    final status = session.wasCompleted ? 'Completed' : 'Incomplete';
    final title = day == null || day.isEmpty
        ? session.workoutPlanName
        : '${session.workoutPlanName} - $day';

    return AppListCard(
      title: title,
      subtitle:
          '$date at $time\n${session.durationInSeconds} sec - '
          '${session.completedExercises}/${session.totalExercises} exercises - '
          '$status',
      leading: Icon(
        session.wasCompleted ? Icons.check_circle : Icons.timelapse,
        color: session.wasCompleted
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.message, required this.onRetry});

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
            const Icon(Icons.error_outline, size: 56),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
