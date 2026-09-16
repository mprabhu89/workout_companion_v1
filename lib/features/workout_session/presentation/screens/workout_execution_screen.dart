import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../settings/domain/entities/voice_preferences.dart';
import '../../../settings/domain/services/voice_preferences_store.dart';
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
    this.enableKeepScreenAwake,
    this.disableKeepScreenAwake,
  });

  final WorkoutSession session;
  final WorkoutSessionController? controller;
  final VoiceCoachService? voiceCoach;
  final WorkoutHistoryRepository? workoutHistoryRepository;
  final Future<void> Function()? enableKeepScreenAwake;
  final Future<void> Function()? disableKeepScreenAwake;

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
    unawaited(_setKeepScreenAwake(enabled: true));
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
    unawaited(_setKeepScreenAwake(enabled: false));
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

  Future<void> _setKeepScreenAwake({required bool enabled}) async {
    try {
      await (enabled
          ? widget.enableKeepScreenAwake ?? WakelockPlus.enable
          : widget.disableKeepScreenAwake ?? WakelockPlus.disable)();
    } catch (_) {
      // Screen-awake support is optional and must never affect training.
    }
  }

  void _refresh() {
    if (!mounted) {
      return;
    }
    setState(() {});
    if (_controller.session.status != WorkoutSessionStatus.completed) {
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
      setState(() => _voiceEnabled = preferences.isEnabled);
    }
    unawaited(_applyVoicePreferences(preferences));
  }

  Future<void> _applyVoicePreferences(VoicePreferences preferences) {
    return _voiceCoach.applyPreferences(
      preferences,
      workoutPlanCategory: _controller.session.workoutPlanCategory,
    );
  }

  void _checkWorkoutCompleted() {
    final session = _controller.session;
    if (session.status != WorkoutSessionStatus.completed ||
        _completionHandled) {
      return;
    }
    _completionHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_completeWorkout(session));
    });
  }

  Future<void> _completeWorkout(WorkoutSession session) async {
    if (!mounted) {
      return;
    }

    // Keep the coach alive until the platform has completed the final utterance.
    await _announceCurrentSessionState();
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
    setState(() => _allowExit = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmEndWorkout() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End workout?'),
        content: const Text('This will complete the current workout.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep Training'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('End Workout'),
          ),
        ],
      ),
    );
    if (shouldEnd == true) {
      _controller.finishWorkout();
    }
  }

  void _togglePause() {
    if (_controller.isPaused) {
      _controller.resume();
      unawaited(_voiceCoach.resume());
    } else {
      _controller.pause();
      unawaited(_voiceCoach.pause());
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _controller.session;
    _checkWorkoutCompleted();
    if (session.workoutExercises.isEmpty) {
      return _EmptyWorkoutScreen(onBack: () => Navigator.of(context).pop());
    }

    final currentExercise = session.currentExercise;
    final exercise = _exercisesById[currentExercise.exerciseId];
    final exerciseName = exercise?.name ?? currentExercise.exerciseId;
    return PopScope<Object?>(
      canPop: _canLeaveScreen,
      onPopInvokedWithResult: (didPop, _) {
        unawaited(_handleBackNavigation(didPop));
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF05090C),
        body: RitmoCyberpunkBackground(
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  child: _ActiveTrainingBody(
                    session: session,
                    controller: _controller,
                    workoutName: session.workoutPlanName ?? 'Workout',
                    exerciseName: exerciseName,
                    voiceEnabled: _voiceEnabled,
                    onToggleVoice: _toggleVoice,
                    onBack: () {
                      if (_canLeaveScreen) {
                        Navigator.of(context).pop();
                      } else {
                        unawaited(_handleBackNavigation(false));
                      }
                    },
                    onTogglePause: _togglePause,
                    onStart: _controller.startCountdown,
                    onPrevious: session.hasPreviousExercise
                        ? _controller.previousExercise
                        : null,
                    onNext: session.hasNextExercise
                        ? _controller.nextExercise
                        : _controller.finishWorkout,
                  ),
                ),
                if (_controller.isPaused)
                  _PausedTrainingOverlay(
                    onResume: _togglePause,
                    onEndWorkout: _confirmEndWorkout,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveTrainingBody extends StatelessWidget {
  const _ActiveTrainingBody({
    required this.session,
    required this.controller,
    required this.workoutName,
    required this.exerciseName,
    required this.voiceEnabled,
    required this.onToggleVoice,
    required this.onBack,
    required this.onTogglePause,
    required this.onStart,
    required this.onPrevious,
    required this.onNext,
  });

  final WorkoutSession session;
  final WorkoutSessionController controller;
  final String workoutName;
  final String exerciseName;
  final bool voiceEnabled;
  final VoidCallback onToggleVoice;
  final VoidCallback onBack;
  final VoidCallback onTogglePause;
  final VoidCallback onStart;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final progress = session.totalExercises == 0
        ? 0.0
        : session.currentExerciseNumber / session.totalExercises;
    return Column(
      children: [
        _ActiveTrainingHeader(
          workoutName: workoutName,
          exerciseName: exerciseName,
          voiceEnabled: voiceEnabled,
          onToggleVoice: onToggleVoice,
          onBack: onBack,
        ),
        const SizedBox(height: 12),
        if (session.totalRoundsForCurrentExercise > 1)
          _RoundProgress(
            currentRound: session.currentExerciseRound,
            totalRounds: session.totalRoundsForCurrentExercise,
          ),
        if (session.totalRoundsForCurrentExercise > 1)
          const SizedBox(height: 12),
        Expanded(
          child: _ActiveStatePanel(
            event: controller.isSequenceExerciseInProgress
                ? controller.activeSequenceEvent
                : null,
            remainingSeconds: session.remainingSeconds,
            iterationNumber: controller.activeSequenceIteration,
            iterationTotal: controller.activeSequenceIterationTotal,
            isLegacyExercise: !controller.isSequenceExerciseInProgress,
          ),
        ),
        const SizedBox(height: 12),
        _ExerciseProgress(
          progress: progress,
          current: session.currentExerciseNumber,
          total: session.totalExercises,
        ),
        const SizedBox(height: 14),
        if (session.status == WorkoutSessionStatus.notStarted)
          RitmoActionButton(label: 'START', onPressed: onStart, isPulsing: true)
        else
          _TrainingControls(
            onPrevious: onPrevious,
            onPause: onTogglePause,
            onNext: onNext,
          ),
      ],
    );
  }
}

class _ActiveTrainingHeader extends StatelessWidget {
  const _ActiveTrainingHeader({
    required this.workoutName,
    required this.exerciseName,
    required this.voiceEnabled,
    required this.onToggleVoice,
    required this.onBack,
  });

  final String workoutName;
  final String exerciseName;
  final bool voiceEnabled;
  final VoidCallback onToggleVoice;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Back',
              onPressed: onBack,
              color: ritmoCyan,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const SizedBox(width: 2),
            const Expanded(
              child: Text(
                'RITMO // ACTIVE TRAINING',
                style: TextStyle(
                  color: ritmoCyan,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.25,
                ),
              ),
            ),
            _VoiceStatus(enabled: voiceEnabled, onTap: onToggleVoice),
            const SizedBox(width: 8),
            const Text(
              'LIVE',
              style: TextStyle(
                color: ritmoOrange,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          workoutName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          exerciseName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFFABC2C8)),
        ),
      ],
    );
  }
}

class _VoiceStatus extends StatelessWidget {
  const _VoiceStatus({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: enabled ? 'Voice on' : 'Voice off',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                enabled ? Icons.volume_up_outlined : Icons.volume_off_outlined,
                color: enabled ? ritmoCyan : const Color(0xFF83999E),
                size: 16,
              ),
              const SizedBox(width: 3),
              Text(
                'VOICE // ${enabled ? 'ON' : 'OFF'}',
                style: TextStyle(
                  color: enabled
                      ? const Color(0xFFD7FCFF)
                      : const Color(0xFF83999E),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundProgress extends StatelessWidget {
  const _RoundProgress({required this.currentRound, required this.totalRounds});

  final int currentRound;
  final int totalRounds;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      glowStrength: 0.18,
      child: Row(
        children: [
          const Icon(Icons.repeat_rounded, color: ritmoOrange, size: 18),
          const SizedBox(width: 8),
          const Text(
            'ROUND',
            style: TextStyle(
              color: Color(0xFF9EB8BE),
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          Text(
            'Round $currentRound of $totalRounds',
            style: const TextStyle(
              color: Color(0xFFD7FCFF),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveStatePanel extends StatelessWidget {
  const _ActiveStatePanel({
    required this.event,
    required this.remainingSeconds,
    required this.iterationNumber,
    required this.iterationTotal,
    required this.isLegacyExercise,
  });

  final WorkoutSequenceEvent? event;
  final int remainingSeconds;
  final int? iterationNumber;
  final int? iterationTotal;
  final bool isLegacyExercise;

  @override
  Widget build(BuildContext context) {
    final content = _StateContent.from(
      event: event,
      remainingSeconds: remainingSeconds,
      iterationNumber: iterationNumber,
      iterationTotal: iterationTotal,
      isLegacyExercise: isLegacyExercise,
    );
    return RitmoHudPanel(
      padding: const EdgeInsets.all(22),
      glowStrength: content.glowStrength,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          child: _StateHero(key: ValueKey(content.identity), content: content),
        ),
      ),
    );
  }
}

class _StateHero extends StatelessWidget {
  const _StateHero({super.key, required this.content});

  final _StateContent content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          content.label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: content.accent,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        if (content.assetPath != null) ...[
          Image.asset(content.assetPath!, height: 96, fit: BoxFit.contain),
          const SizedBox(height: 10),
        ],
        if (content.isNumber)
          TweenAnimationBuilder<double>(
            key: ValueKey('${content.identity}-pulse'),
            tween: Tween(begin: 0.94, end: 1),
            duration: const Duration(milliseconds: 170),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Text(
              content.primary,
              textAlign: TextAlign.center,
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 76,
                fontWeight: FontWeight.w900,
                height: 0.95,
              ),
            ),
          )
        else
          Text(
            content.primary,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
        if (content.unit != null) ...[
          const SizedBox(height: 10),
          Text(
            content.unit!,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: const Color(0xFFABC2C8),
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
        if (content.iterationText != null) ...[
          const SizedBox(height: 12),
          Text(
            content.iterationText!,
            style: const TextStyle(
              color: ritmoOrange,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ],
    );
  }
}

class _StateContent {
  const _StateContent({
    required this.identity,
    required this.label,
    required this.primary,
    required this.accent,
    required this.glowStrength,
    this.unit,
    this.iterationText,
    this.assetPath,
    this.isNumber = false,
  });

  factory _StateContent.from({
    required WorkoutSequenceEvent? event,
    required int remainingSeconds,
    required int? iterationNumber,
    required int? iterationTotal,
    required bool isLegacyExercise,
  }) {
    final iterationText = iterationNumber != null && iterationTotal != null
        ? 'REP $iterationNumber / $iterationTotal  //  SEQUENCE LOOP ACTIVE'
        : null;
    if (event == null) {
      return _StateContent(
        identity: 'legacy-$remainingSeconds-$isLegacyExercise',
        label: isLegacyExercise ? 'ACTIVE TRAINING' : 'PREPARING',
        primary: remainingSeconds.toString().padLeft(2, '0'),
        unit: remainingSeconds > 0 ? 'SECONDS' : 'READY',
        accent: ritmoCyan,
        glowStrength: 0.32,
        isNumber: true,
      );
    }
    switch (event.type) {
      case WorkoutSequenceEventType.guide:
        return _StateContent(
          identity: 'guide-${event.guideText}-$iterationNumber',
          label: 'GUIDANCE',
          primary: event.guideText ?? '',
          accent: ritmoCyan,
          glowStrength: 0.52,
          iterationText: iterationText,
        );
      case WorkoutSequenceEventType.count:
        return _StateContent(
          identity: 'count-${event.countValue}-$iterationNumber',
          label: 'COUNT',
          primary: '${event.countValue ?? 0}',
          unit: 'NATURAL COACH COUNT',
          accent: ritmoCyan,
          glowStrength: 0.58,
          iterationText: iterationText,
          isNumber: true,
        );
      case WorkoutSequenceEventType.countSeconds:
        return _StateContent(
          identity: 'seconds-${event.countValue}-$iterationNumber',
          label: 'TIMED COUNT',
          primary: '${event.countValue ?? 0}'.padLeft(2, '0'),
          unit: 'SECONDS',
          accent: ritmoCyan,
          glowStrength: 0.65,
          isNumber: true,
        );
      case WorkoutSequenceEventType.relax:
        return _StateContent(
          identity: 'relax-$remainingSeconds-$iterationNumber',
          label: 'RECOVERY',
          primary: remainingSeconds.toString().padLeft(2, '0'),
          unit: 'SECONDS  //  BREATHE. RESET. GET READY.',
          accent: const Color(0xFF80D9D4),
          glowStrength: 0.34,
          assetPath: 'assets/branding/ritmo_mascot_rest.png',
          isNumber: true,
        );
      case WorkoutSequenceEventType.end:
        return const _StateContent(
          identity: 'end',
          label: 'FINALIZING',
          primary: 'TRAINING COMPLETE',
          accent: ritmoOrange,
          glowStrength: 0.34,
        );
    }
  }

  final String identity;
  final String label;
  final String primary;
  final Color accent;
  final double glowStrength;
  final String? unit;
  final String? iterationText;
  final String? assetPath;
  final bool isNumber;
}

class _ExerciseProgress extends StatelessWidget {
  const _ExerciseProgress({
    required this.progress,
    required this.current,
    required this.total,
  });

  final double progress;
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'WORKOUT PROGRESS',
              style: TextStyle(
                color: Color(0xFF9EB8BE),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Text(
              '$current / $total',
              style: const TextStyle(
                color: Color(0xFFD7FCFF),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 5,
            color: ritmoCyan,
            backgroundColor: const Color(0xFF173037),
          ),
        ),
      ],
    );
  }
}

class _TrainingControls extends StatelessWidget {
  const _TrainingControls({
    required this.onPrevious,
    required this.onPause,
    required this.onNext,
  });

  final VoidCallback? onPrevious;
  final VoidCallback onPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HudIconControl(
          icon: Icons.skip_previous_rounded,
          label: 'Previous exercise',
          onPressed: onPrevious,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RitmoActionButton(
            label: 'II  PAUSE',
            onPressed: onPause,
            isPulsing: true,
          ),
        ),
        const SizedBox(width: 10),
        _HudIconControl(
          icon: Icons.skip_next_rounded,
          label: 'Next exercise',
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _HudIconControl extends StatelessWidget {
  const _HudIconControl({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: 48,
        height: 48,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: ritmoCyan,
            side: const BorderSide(color: Color(0xFF426E77)),
            padding: EdgeInsets.zero,
          ),
          child: Icon(icon),
        ),
      ),
    );
  }
}

class _PausedTrainingOverlay extends StatelessWidget {
  const _PausedTrainingOverlay({
    required this.onResume,
    required this.onEndWorkout,
  });

  final VoidCallback onResume;
  final VoidCallback onEndWorkout;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xE805090C),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: RitmoHudPanel(
              glowStrength: 0.52,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TRAINING PAUSED',
                    style: TextStyle(
                      color: ritmoCyan,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(
                    'assets/branding/ritmo_mascot_rest.png',
                    height: 118,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Your current training state is ready when you are.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFABC2C8)),
                  ),
                  const SizedBox(height: 20),
                  RitmoActionButton(
                    label: 'RESUME TRAINING',
                    onPressed: onResume,
                    isPulsing: true,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: onEndWorkout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF8C8C),
                        side: const BorderSide(color: Color(0xFFB65555)),
                      ),
                      child: const Text('END WORKOUT'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyWorkoutScreen extends StatelessWidget {
  const _EmptyWorkoutScreen({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: RitmoHudPanel(
                glowStrength: 0.2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      color: ritmoCyan,
                      size: 62,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'NO EXERCISES FOUND',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add an executable workout before starting this training day.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    RitmoActionButton(label: 'BACK', onPressed: onBack),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
