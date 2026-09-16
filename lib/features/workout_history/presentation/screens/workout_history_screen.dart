import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../domain/entities/completed_workout_session.dart';
import '../../domain/services/workout_statistics_service.dart';
import '../controllers/workout_history_controller.dart';
import 'workout_history_details_screen.dart';
import 'workout_statistics_screen.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key, this.controller});

  final WorkoutHistoryController? controller;

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  late final WorkoutHistoryController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        WorkoutHistoryController.create(
          repository: RepositoryRegistry.workoutHistoryRepository,
          statisticsService: const WorkoutStatisticsService(),
        );
    _controller.loadSessions();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
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
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('HISTORY'),
        actions: [
          IconButton(
            onPressed: _openStatistics,
            tooltip: 'Statistics',
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      body: RitmoCyberpunkBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const AppLoadingIndicator(
                message: 'Loading training archive...',
              );
            }
            if (_controller.errorMessage != null) {
              return _ArchiveError(
                message: _controller.errorMessage!,
                onRetry: _controller.loadSessions,
              );
            }
            if (_controller.sessions.isEmpty) {
              return const _ArchiveEmpty();
            }
            return _ArchiveRecords(
              sessions: _controller.sessions,
              onRefresh: _controller.loadSessions,
              onOpenSession: _openSession,
            );
          },
        ),
      ),
    );
  }
}

class _ArchiveRecords extends StatelessWidget {
  const _ArchiveRecords({
    required this.sessions,
    required this.onRefresh,
    required this.onOpenSession,
  });

  final List<CompletedWorkoutSession> sessions;
  final Future<void> Function() onRefresh;
  final ValueChanged<CompletedWorkoutSession> onOpenSession;

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries(context, sessions);
    final completedSessions = sessions
        .where((session) => session.wasCompleted)
        .toList(growable: false);
    final completedDuration = completedSessions.fold<int>(
      0,
      (total, session) => total + session.durationInSeconds,
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        itemCount: entries.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RitmoHudSectionHeading(title: 'TRAINING ARCHIVE'),
                  SizedBox(height: 6),
                  Text(
                    'YOUR COMPLETED TRAINING RECORD',
                    style: TextStyle(
                      color: Color(0xFF89A9AF),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            );
          }
          if (index == 1) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _ArchiveSummary(
                completedSessions: completedSessions.length,
                totalDurationInSeconds: completedDuration,
              ),
            );
          }

          final entry = entries[index - 2];
          if (entry.label != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                entry.label!,
                style: const TextStyle(
                  color: ritmoOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ArchiveSessionCard(
              session: entry.session!,
              onTap: () => onOpenSession(entry.session!),
            ),
          );
        },
      ),
    );
  }

  List<_ArchiveEntry> _buildEntries(
    BuildContext context,
    List<CompletedWorkoutSession> source,
  ) {
    final sorted = [...source]
      ..sort((left, right) {
        final byCompletion = right.completedAt.compareTo(left.completedAt);
        return byCompletion != 0 ? byCompletion : right.id.compareTo(left.id);
      });
    final entries = <_ArchiveEntry>[];
    DateTime? previousDate;
    final now = DateUtils.dateOnly(DateTime.now());
    for (final session in sorted) {
      final date = DateUtils.dateOnly(session.completedAt.toLocal());
      if (previousDate != date) {
        entries.add(_ArchiveEntry.label(_dateLabel(context, date, now)));
        previousDate = date;
      }
      entries.add(_ArchiveEntry.session(session));
    }
    return entries;
  }

  String _dateLabel(BuildContext context, DateTime date, DateTime now) {
    if (date == now) return 'TODAY';
    if (date == now.subtract(const Duration(days: 1))) return 'YESTERDAY';
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }
}

class _ArchiveSummary extends StatelessWidget {
  const _ArchiveSummary({
    required this.completedSessions,
    required this.totalDurationInSeconds,
  });

  final int completedSessions;
  final int totalDurationInSeconds;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      glowStrength: 0.3,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: _ArchiveMetric(
              label: 'COMPLETED SESSIONS',
              value: '$completedSessions',
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFF31535C)),
          Expanded(
            child: _ArchiveMetric(
              label: 'TRAINING TIME',
              value: _formatDuration(totalDurationInSeconds),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveMetric extends StatelessWidget {
  const _ArchiveMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFD8FCFF),
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ArchiveSessionCard extends StatelessWidget {
  const _ArchiveSessionCard({required this.session, required this.onTap});

  final CompletedWorkoutSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completedAt = session.completedAt.toLocal();
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(completedAt));
    final completed = session.wasCompleted;

    return Semantics(
      button: true,
      label: 'Open session record for ${session.workoutPlanName}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: ritmoCyan.withValues(alpha: 0.12),
          child: RitmoHudPanel(
            padding: const EdgeInsets.all(14),
            glowStrength: completed ? 0.18 : 0.05,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  completed ? Icons.check_circle_outline : Icons.timelapse,
                  color: completed ? ritmoCyan : const Color(0xFF9AB0B4),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.workoutPlanName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      if (session.workoutDayName case final dayName?) ...[
                        const SizedBox(height: 3),
                        Text(
                          dayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF9FC1C7)),
                        ),
                      ],
                      const SizedBox(height: 9),
                      Text(
                        '$time  //  ${_formatDuration(session.durationInSeconds)}  //  '
                        '${session.completedExercises}/${session.totalExercises} EXERCISES',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFB7D1D6),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        completed ? 'COMPLETED' : 'INCOMPLETE',
                        style: TextStyle(
                          color: completed
                              ? ritmoCyan
                              : const Color(0xFF9AB0B4),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.9,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: ritmoCyan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchiveEmpty extends StatelessWidget {
  const _ArchiveEmpty();

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
                  'YOUR JOURNEY STARTS HERE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD8FCFF),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete your first training session to build your Training Archive.',
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

class _ArchiveError extends StatelessWidget {
  const _ArchiveError({required this.message, required this.onRetry});

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

class _ArchiveEntry {
  const _ArchiveEntry._({this.label, this.session});

  const _ArchiveEntry.label(String label) : this._(label: label);
  const _ArchiveEntry.session(CompletedWorkoutSession session)
    : this._(session: session);

  final String? label;
  final CompletedWorkoutSession? session;
}

String _formatDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  if (duration.inHours > 0) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }
  if (duration.inMinutes > 0) return '${duration.inMinutes}m';
  return '${duration.inSeconds}s';
}
