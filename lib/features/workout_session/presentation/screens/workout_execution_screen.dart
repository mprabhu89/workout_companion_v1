import 'package:flutter/material.dart';
import '../controllers/workout_session_controller.dart';
import '../../domain/entities/workout_session.dart';

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

  @override
  Widget build(BuildContext context) {
    final session = _controller.session;

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
                session.currentExercise.exerciseId,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: 8),

              Text(
                '${session.currentExercise.sets ?? 1} Sets • '
                '${session.currentExercise.repetitions ?? 0} Reps',
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
                  onPressed: () {
                    _controller.startCountdown();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('START'),
                )
              else
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: const Icon(
                        Icons.skip_previous,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        if (_controller.isPaused) {
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
                      onPressed: null,
                      icon: const Icon(
                        Icons.skip_next,
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