import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../workout_history/domain/entities/completed_workout_session.dart';
import 'workout_completion_screen.dart';
import '../../domain/entities/workout_session.dart';
import '../controllers/workout_session_controller.dart';

class WorkoutExecutionScreen extends StatefulWidget {
  const WorkoutExecutionScreen({
    super.key,
    required this.session,
  });

  final WorkoutSession session;

  @override
  State<WorkoutExecutionScreen> createState() =>
      _WorkoutExecutionScreenState();
}

class _WorkoutExecutionScreenState
    extends State<WorkoutExecutionScreen> {
  late final WorkoutSessionController _controller;
  bool _completionHandled = false;

  @override
  void initState() {
    super.initState();

    _controller = WorkoutSessionController(
      session: widget.session,
    );

    _controller.addListener(_refresh);
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _checkWorkoutCompleted() {
    final session = _controller.session;

    if (session.status != WorkoutSessionStatus.completed) {
      return;
    }

    if (_completionHandled) {
      return;
    }
    _completionHandled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      final completedAt =
          session.completedAt ?? DateTime.now();
      final startedAt = session.startedAt ?? completedAt;
      final completedExercises = (session.currentExerciseIndex + 1)
          .clamp(0, session.workoutExercises.length)
          .toInt();
      final completedSession = CompletedWorkoutSession(
        id: const Uuid().v4(),
        workoutPlanId: session.workoutPlanId ?? '',
        workoutPlanName:
            session.workoutPlanName ?? 'Workout',
        workoutDayId: session.workoutDayId,
        workoutDayName: session.workoutDayName,
        startedAt: startedAt,
        completedAt: completedAt,
        durationInSeconds:
            completedAt.difference(startedAt).inSeconds,
        completedExercises: completedExercises,
        totalExercises: session.workoutExercises.length,
        wasCompleted: true,
      );

      await RepositoryRegistry.workoutHistoryRepository
          .saveSession(completedSession);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WorkoutCompletionScreen(
            session: completedSession,
          ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final session = _controller.session;
    _checkWorkoutCompleted();
    if (session.workoutExercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Workout'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fitness_center,
                  size: 72,
                ),
                const SizedBox(height: 24),
                Text(
                  'No exercises found',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please add at least one exercise before starting this workout.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentExercise =
        session.currentExercise;

    final progress =
        (session.currentExerciseIndex + 1) /
        session.workoutExercises.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                currentExercise.exerciseId,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '${currentExercise.sets ?? 1} Sets • '
                '${currentExercise.repetitions ?? 0} Reps',
              ),

              const SizedBox(height: 40),

              Text(
                session.remainingSeconds
                    .toString()
                    .padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              LinearProgressIndicator(
                value: progress,
              ),

              const SizedBox(height: 12),

              Text(
                'Exercise ${session.currentExerciseIndex + 1}'
                ' of ${session.workoutExercises.length}',
              ),

              const Spacer(),

              if (session.status ==
                  WorkoutSessionStatus.notStarted)
                FilledButton.icon(
                  onPressed:
                      _controller.startCountdown,
                  icon: const Icon(
                    Icons.play_arrow,
                  ),
                  label: const Text('START'),
                )
              else
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed:
                          _controller
                                  .session
                                  .hasPreviousExercise
                              ? _controller
                                  .previousExercise
                              : null,
                      icon: const Icon(
                        Icons.skip_previous,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        if (_controller
                            .isPaused) {
                          _controller.resume();
                        } else {
                          _controller.pause();
                        }
                      },
                      icon: Icon(
                        _controller.isPaused
                            ? Icons.play_arrow
                            : Icons.pause,
                      ),
                      label: Text(
                        _controller.isPaused
                            ? 'Resume'
                            : 'Pause',
                      ),
                    ),
                    IconButton(
                      onPressed:
                          _controller
                                  .session
                                  .hasNextExercise
                              ? _controller
                                  .nextExercise
                              : _controller
                                  .finishWorkout,
                      icon: Icon(
                        _controller
                                .session
                                .hasNextExercise
                            ? Icons.skip_next
                            : Icons.check_circle,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
