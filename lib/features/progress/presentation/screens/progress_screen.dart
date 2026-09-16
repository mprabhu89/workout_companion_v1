import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../workout_history/domain/entities/completed_workout_session.dart';
import '../../../workout_history/presentation/screens/workout_history_screen.dart';
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
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(title: const Text('PROGRESS')),
      body: RitmoCyberpunkBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const AppLoadingIndicator(
                message: 'Loading performance data...',
              );
            }
            if (_controller.errorMessage != null) {
              return _ProgressError(
                message: _controller.errorMessage!,
                onRetry: _controller.loadProgress,
              );
            }
            final summary = _controller.summary;
            if (summary == null) {
              return const _ProgressEmpty();
            }
            return _ProgressContent(
              summary: summary,
              sessions: _controller.sessions,
            );
          },
        ),
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({required this.summary, required this.sessions});

  final WorkoutProgressSummary summary;
  final List<CompletedWorkoutSession> sessions;

  @override
  Widget build(BuildContext context) {
    final metrics = summary.overall;
    final completedSessions = sessions
        .where((session) => session.wasCompleted)
        .toList(growable: false);
    if (!summary.hasPlannedWorkouts && completedSessions.isEmpty) {
      return const _ProgressEmpty();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      children: [
        const RitmoHudSectionHeading(title: 'PERFORMANCE HUD'),
        const SizedBox(height: 6),
        const Text(
          'TRAINING ACTIVITY OVERVIEW',
          style: TextStyle(
            color: Color(0xFF89A9AF),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        _TrainingSummary(
          metrics: metrics,
          hasPlannedWorkouts: summary.hasPlannedWorkouts,
        ),
        const SizedBox(height: 16),
        if (completedSessions.isEmpty)
          const _ActivityInsufficient()
        else
          _ActivityPanel(sessions: completedSessions),
        if (!summary.hasPlannedWorkouts) ...[
          const SizedBox(height: 16),
          const _NoActivePlans(),
        ],
        if (summary.plans.isNotEmpty) ...[
          const SizedBox(height: 22),
          const RitmoHudSectionHeading(title: 'TRAINING PROGRAMS'),
          const SizedBox(height: 10),
          ...summary.plans.map(
            (plan) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PlanProgressCard(
                progress: plan,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlanProgressDetailsScreen(progress: plan),
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        RitmoActionButton(
          label: 'VIEW HISTORY',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WorkoutHistoryScreen()),
          ),
        ),
      ],
    );
  }
}

class _TrainingSummary extends StatelessWidget {
  const _TrainingSummary({
    required this.metrics,
    required this.hasPlannedWorkouts,
  });

  final WorkoutProgressMetrics metrics;
  final bool hasPlannedWorkouts;

  @override
  Widget build(BuildContext context) {
    final values = <_ProgressMetric>[
      _ProgressMetric(
        label: 'ACTUAL SESSIONS',
        value: '${metrics.actualSessions}',
      ),
      _ProgressMetric(
        label: 'TRAINING TIME',
        value: _formatDuration(metrics.totalDurationInSeconds),
      ),
      if (hasPlannedWorkouts)
        _ProgressMetric(
          label: 'PLAN COMPLETION',
          value: '${metrics.completionPercentage.toStringAsFixed(0)}%',
          supporting:
              '${metrics.completedPlannedWorkouts}/${metrics.plannedWorkouts} PLANNED',
        ),
    ];

    return RitmoHudPanel(
      glowStrength: 0.38,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TRAINING SUMMARY',
            style: TextStyle(
              color: ritmoCyan,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final useColumns =
                  constraints.maxWidth >= 300 && values.length == 3;
              if (useColumns) {
                return Row(
                  children: [
                    for (var index = 0; index < values.length; index++) ...[
                      Expanded(child: values[index]),
                      if (index < values.length - 1)
                        Container(
                          width: 1,
                          height: 48,
                          color: const Color(0xFF31535C),
                        ),
                    ],
                  ],
                );
              }
              return Wrap(spacing: 22, runSpacing: 14, children: values);
            },
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.value,
    this.supporting,
  });

  final String label;
  final String value;
  final String? supporting;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF88AAB0),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFD8FCFF),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (supporting != null) ...[
          const SizedBox(height: 2),
          Text(
            supporting!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF9FC1C7), fontSize: 10),
          ),
        ],
      ],
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({required this.sessions});

  final List<CompletedWorkoutSession> sessions;

  @override
  Widget build(BuildContext context) {
    final days = _recentDays();
    final counts = <DateTime, int>{for (final day in days) day: 0};
    for (final session in sessions) {
      final date = DateUtils.dateOnly(session.completedAt.toLocal());
      if (counts.containsKey(date)) {
        counts[date] = counts[date]! + 1;
      }
    }
    final highestCount = counts.values.fold(
      1,
      (highest, count) => count > highest ? count : highest,
    );
    final activityCount = counts.values.fold(
      0,
      (total, count) => total + count,
    );

    return RitmoHudPanel(
      glowStrength: 0.25,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TRAINING ACTIVITY',
            style: TextStyle(
              color: ritmoCyan,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '$activityCount COMPLETED SESSIONS IN THE LAST 7 DAYS',
            style: const TextStyle(
              color: Color(0xFF9FC1C7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 124,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final day in days)
                  Expanded(
                    child: _ActivityBar(
                      day: day,
                      count: counts[day]!,
                      highestCount: highestCount,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _recentDays() {
    final today = DateUtils.dateOnly(DateTime.now());
    return List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );
  }
}

class _ActivityBar extends StatelessWidget {
  const _ActivityBar({
    required this.day,
    required this.count,
    required this.highestCount,
  });

  final DateTime day;
  final int count;
  final int highestCount;

  @override
  Widget build(BuildContext context) {
    final fraction = count / highestCount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$count',
            key: Key(
              'activity-count-${day.toIso8601String().substring(0, 10)}',
            ),
            style: TextStyle(
              color: count > 0
                  ? const Color(0xFFD8FCFF)
                  : const Color(0xFF6C858A),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                height: 18 + (58 * fraction),
                decoration: BoxDecoration(
                  color: count > 0 ? ritmoCyan : const Color(0xFF243A40),
                  boxShadow: count > 0
                      ? [
                          BoxShadow(
                            color: ritmoCyan.withValues(alpha: 0.25),
                            blurRadius: 9,
                          ),
                        ]
                      : const [],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _weekdayLabel(day),
            style: const TextStyle(
              color: Color(0xFF89A9AF),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(DateTime value) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return labels[value.weekday - 1];
  }
}

class _ActivityInsufficient extends StatelessWidget {
  const _ActivityInsufficient();

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      glowStrength: 0.18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BUILD YOUR PERFORMANCE DATA',
            style: TextStyle(
              color: Color(0xFFD8FCFF),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Complete training sessions and RITMO will track your activity.',
            style: TextStyle(color: Color(0xFFAAC5CA)),
          ),
        ],
      ),
    );
  }
}

class _NoActivePlans extends StatelessWidget {
  const _NoActivePlans();

  @override
  Widget build(BuildContext context) {
    return const RitmoHudPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NO ACTIVE WORKOUT PLANS',
            style: TextStyle(color: ritmoOrange, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 5),
          Text(
            'Create active non-rest workout days to track plan completion.',
            style: TextStyle(color: Color(0xFFAAC5CA)),
          ),
        ],
      ),
    );
  }
}

class _PlanProgressCard extends StatelessWidget {
  const _PlanProgressCard({required this.progress, required this.onTap});

  final WorkoutPlanProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = progress.metrics;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: ritmoCyan.withValues(alpha: 0.12),
        child: RitmoHudPanel(
          padding: const EdgeInsets.all(14),
          glowStrength: 0.16,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.plan.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${metrics.completedPlannedWorkouts} / ${metrics.plannedWorkouts} PLANNED WORKOUTS',
                      style: const TextStyle(
                        color: Color(0xFF9FC1C7),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${metrics.completionPercentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: ritmoCyan,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: ritmoCyan),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressEmpty extends StatelessWidget {
  const _ProgressEmpty();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: RitmoHudPanel(
            glowStrength: 0.32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/branding/ritmo_mascot_ready.png',
                  height: 112,
                ),
                const SizedBox(height: 16),
                const Text(
                  'BUILD YOUR PERFORMANCE DATA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD8FCFF),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete training sessions and RITMO will track your activity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFAAC5CA)),
                ),
              ],
            ),
          ),
        ),
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
        child: RitmoHudPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFFF8C8C),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              RitmoActionButton(label: 'RETRY', onPressed: onRetry),
            ],
          ),
        ),
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
