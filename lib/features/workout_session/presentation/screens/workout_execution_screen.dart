import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../settings/domain/entities/voice_preferences.dart';
import '../../../settings/domain/services/voice_preferences_store.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_history/domain/entities/completed_workout_session.dart';
import '../../../workout_history/domain/repositories/workout_history_repository.dart';
import '../../domain/entities/workout_sequence_event.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/services/voice_coach_service.dart';
import '../controllers/workout_session_controller.dart';
import 'workout_completion_screen.dart';

class WorkoutExecutionScreen extends StatefulWidget {
  const WorkoutExecutionScreen({
    super.key,
    required this.session,
    this.controller,
    this.voiceCoach,
    this.workoutHistoryRepository,
  });

  final WorkoutSession session;
  final WorkoutSessionController? controller;
  final VoiceCoachService? voiceCoach;
  final WorkoutHistoryRepository? workoutHistoryRepository;

  @override
  State<WorkoutExecutionScreen> createState() => _WorkoutExecutionScreenState();
}

class _WorkoutExecutionScreenState extends State<WorkoutExecutionScreen> {
  late final WorkoutSessionController _controller;
  late final VoiceCoachService _voiceCoach;
  late final WorkoutHistoryRepository _workoutHistoryRepository;
  late final VoicePreferencesStore _voicePreferencesStore;
  final Map<String, Exercise> _exercisesById = {};

  bool _completionHandled = false;
  bool _allowExit = false;
  bool _isExitDialogVisible = false;
  bool _voiceEnabled = true;
  late final bool _ownsController;
  late final bool _ownsVoiceCoach;

  @override
  void initState() {
    super.initState();

    _ownsVoiceCoach = widget.voiceCoach == null;
    _voiceCoach = widget.voiceCoach ?? RepositoryRegistry.createVoiceCoach();
    _voicePreferencesStore = RepositoryRegistry.voicePreferencesStore;
    _voiceEnabled = _voicePreferencesStore.preferences.isEnabled;
    _voicePreferencesStore.addListener(_onVoicePreferencesChanged);
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        WorkoutSessionController(
          session: widget.session,
          voiceCoach: _voiceCoach,
        );
    unawaited(_applyVoicePreferences(_voicePreferencesStore.preferences));
    _workoutHistoryRepository =
        widget.workoutHistoryRepository ??
        RepositoryRegistry.workoutHistoryRepository;

    _controller.addListener(_refresh);
    _loadExercises();
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _voicePreferencesStore.removeListener(_onVoicePreferencesChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsVoiceCoach) {
      unawaited(_voiceCoach.dispose());
    }
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
      unawaited(_announceCurrentSessionState());
    }
  }

  Future<void> _loadExercises() async {
    final exercises = await RepositoryRegistry.exerciseRepository
        .getExercises();

    if (!mounted) {
      return;
    }

    setState(() {
      _exercisesById
        ..clear()
        ..addEntries(
          exercises.map((exercise) => MapEntry(exercise.id, exercise)),
        );
    });
  }

  Future<void> _announceCurrentSessionState() async {
    final session = _controller.session;

    if (session.workoutExercises.isEmpty) {
      return;
    }

    final currentWorkoutExercise = session.currentExercise;
    final hasSequenceDefinition =
        currentWorkoutExercise.sequenceDefinition != null &&
        currentWorkoutExercise.sequenceDefinition!.steps.isNotEmpty;

    if (hasSequenceDefinition &&
        (session.status == WorkoutSessionStatus.countdown ||
            session.status == WorkoutSessionStatus.exercising)) {
      return;
    }

    final nextWorkoutExercise = session.hasNextExercise
        ? session.workoutExercises[session.currentExerciseIndex + 1]
        : null;

    await _voiceCoach.announceSessionState(
      session: session,
      currentExercise: _exercisesById[currentWorkoutExercise.exerciseId],
      nextExercise: nextWorkoutExercise == null
          ? null
          : _exercisesById[nextWorkoutExercise.exerciseId],
    );
  }

  Future<void> _toggleVoice() async {
    await _voicePreferencesStore.update(
      _voicePreferencesStore.preferences.copyWith(
        isEnabled: !_voicePreferencesStore.preferences.isEnabled,
      ),
    );
  }

  void _onVoicePreferencesChanged() {
    final preferences = _voicePreferencesStore.preferences;
    if (mounted) {
      setState(() {
        _voiceEnabled = preferences.isEnabled;
      });
    }
    unawaited(_applyVoicePreferences(preferences));
  }

  Future<void> _applyVoicePreferences(
    VoicePreferences preferences,
  ) {
    return _voiceCoach.applyPreferences(
      preferences,
      workoutPlanCategory: _controller.session.workoutPlanCategory,
    );
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

      final completedAt = session.completedAt ?? DateTime.now();
      final startedAt = session.startedAt ?? completedAt;
      final completedSession = CompletedWorkoutSession(
        id: const Uuid().v4(),
        workoutPlanId: session.workoutPlanId ?? '',
        workoutPlanName: session.workoutPlanName ?? 'Workout',
        workoutDayId: session.workoutDayId,
        workoutDayName: session.workoutDayName,
        startedAt: startedAt,
        completedAt: completedAt,
        durationInSeconds: completedAt.difference(startedAt).inSeconds,
        completedExercises: session.completedExerciseCount,
        totalExercises: session.totalExercises,
        wasCompleted: true,
      );

      await _workoutHistoryRepository.saveSession(completedSession);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WorkoutCompletionScreen(session: completedSession),
        ),
      );
    });
  }

  bool get _canLeaveScreen =>
      _allowExit ||
      _controller.session.status == WorkoutSessionStatus.notStarted;

  Future<void> _handleBackNavigation(bool didPop) async {
    if (didPop || _isExitDialogVisible || _completionHandled) {
      return;
    }

    _isExitDialogVisible = true;
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Leave workout?'),
        content: const Text(
          'Your active workout will be cancelled and will not be saved to history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep Workout'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Leave Workout'),
          ),
        ],
      ),
    );
    _isExitDialogVisible = false;

    if (!mounted || shouldLeave != true) {
      return;
    }

    setState(() {
      _allowExit = true;
    });
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _controller.session;
    _checkWorkoutCompleted();

    if (session.workoutExercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fitness_center, size: 72),
                const SizedBox(height: 24),
                Text(
                  'No exercises found',
                  style: Theme.of(context).textTheme.headlineSmall,
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

    final currentExercise = session.currentExercise;
    final exercise = _exercisesById[currentExercise.exerciseId];
    final exerciseName = exercise?.name ?? currentExercise.exerciseId;
    final hasSequenceDefinition =
        currentExercise.sequenceDefinition != null &&
        currentExercise.sequenceDefinition!.steps.isNotEmpty;

    final progress = session.currentExerciseNumber / session.totalExercises;

    return PopScope<Object?>(
      canPop: _canLeaveScreen,
      onPopInvokedWithResult: (didPop, _) {
        unawaited(_handleBackNavigation(didPop));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout'),
          actions: [
            IconButton(
              onPressed: _toggleVoice,
              tooltip: _voiceEnabled
                  ? 'Disable voice coach'
                  : 'Enable voice coach',
              icon: Icon(
                _voiceEnabled
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  exerciseName,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  hasSequenceDefinition
                      ? 'Guided sequence exercise'
                      : _buildLegacyExerciseSummary(currentExercise),
                ),
                const SizedBox(height: 8),
                Text(
                  'Completed ${session.completedExerciseCount}'
                  ' of ${session.totalExercises}',
                ),
                if (session.totalRoundsForCurrentExercise > 1) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Round ${session.currentExerciseRound}'
                    ' of ${session.totalRoundsForCurrentExercise}',
                  ),
                ],
                const SizedBox(height: 40),
                if (_controller.isSequenceExerciseInProgress)
                  _SequenceExecutionPanel(
                    event: _controller.activeSequenceEvent,
                    iterationNumber: _controller.activeSequenceIteration,
                    iterationTotal: _controller.activeSequenceIterationTotal,
                    remainingSeconds: session.remainingSeconds,
                  )
                else
                  Text(
                    session.remainingSeconds.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 40),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 12),
                Text(
                  'Exercise ${session.currentExerciseNumber}'
                  ' of ${session.totalExercises}',
                ),
                const Spacer(),
                if (session.status == WorkoutSessionStatus.notStarted)
                  FilledButton.icon(
                    onPressed: _controller.startCountdown,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('START'),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _controller.session.hasPreviousExercise
                            ? _controller.previousExercise
                            : null,
                        icon: const Icon(Icons.skip_previous),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          if (_controller.isPaused) {
                            _controller.resume();
                            unawaited(_voiceCoach.resume());
                          } else {
                            _controller.pause();
                            unawaited(_voiceCoach.pause());
                          }
                        },
                        icon: Icon(
                          _controller.isPaused ? Icons.play_arrow : Icons.pause,
                        ),
                        label: Text(_controller.isPaused ? 'Resume' : 'Pause'),
                      ),
                      IconButton(
                        onPressed: _controller.session.hasNextExercise
                            ? _controller.nextExercise
                            : _controller.finishWorkout,
                        icon: Icon(
                          _controller.session.hasNextExercise
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
      ),
    );
  }

  String _buildLegacyExerciseSummary(WorkoutExercise workoutExercise) {
    final parts = <String>[];

    if (workoutExercise.sets != null) {
      parts.add('${workoutExercise.sets} Sets');
    }

    if (workoutExercise.repetitions != null) {
      parts.add('${workoutExercise.repetitions} Reps');
    }

    if (workoutExercise.durationInSeconds != null) {
      parts.add('${workoutExercise.durationInSeconds} sec');
    }

    return parts.isEmpty ? 'Workout exercise' : parts.join(' - ');
  }
}

class _SequenceExecutionPanel extends StatelessWidget {
  const _SequenceExecutionPanel({
    required this.event,
    required this.iterationNumber,
    required this.iterationTotal,
    required this.remainingSeconds,
  });

  final WorkoutSequenceEvent? event;
  final int? iterationNumber;
  final int? iterationTotal;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return const SizedBox.shrink();
    }

    final repetitionText = iterationNumber != null && iterationTotal != null
        ? 'Repetition $iterationNumber of $iterationTotal'
        : null;

    String label;
    Widget primaryContent;

    switch (event!.type) {
      case WorkoutSequenceEventType.guide:
        label = 'Guide';
        primaryContent = Text(
          event!.guideText ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        );
        break;
      case WorkoutSequenceEventType.count:
        label = 'Count';
        primaryContent = Text(
          '${event!.countValue ?? 0}',
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        );
        break;
      case WorkoutSequenceEventType.countSeconds:
        label = 'Count Seconds';
        primaryContent = Text(
          '${event!.countValue ?? 0}',
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        );
        break;
      case WorkoutSequenceEventType.relax:
        label = 'Relax';
        primaryContent = Text(
          remainingSeconds.toString().padLeft(2, '0'),
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        );
        break;
      case WorkoutSequenceEventType.end:
        label = 'End';
        primaryContent = const SizedBox.shrink();
        break;
    }

    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        if (repetitionText != null) ...[
          const SizedBox(height: 8),
          Text(repetitionText),
        ],
        const SizedBox(height: 16),
        primaryContent,
      ],
    );
  }
}
