import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../../workout_day/domain/entities/workout_day.dart';
import '../../../workout_day/domain/repositories/workout_day_repository.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../../workout_group/domain/entities/workout_group.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
import '../../../workout_group_workout_reference/domain/repositories/workout_group_workout_reference_repository.dart';
import '../../../workout_plan/domain/entities/workout_plan.dart';
import '../../../workout_plan/domain/repositories/workout_plan_repository.dart';
import '../services/workout_day_training_launcher.dart';

/// Read-only program/day selection and briefing before active training begins.
class StartTrainingScreen extends StatefulWidget {
  const StartTrainingScreen({
    super.key,
    this.workoutPlanRepository,
    this.workoutDayRepository,
    this.workoutGroupRepository,
    this.workoutExerciseRepository,
    this.referenceRepository,
    this.exerciseRepository,
    this.trainingLauncher,
  });

  final WorkoutPlanRepository? workoutPlanRepository;
  final WorkoutDayRepository? workoutDayRepository;
  final WorkoutGroupRepository? workoutGroupRepository;
  final WorkoutExerciseRepository? workoutExerciseRepository;
  final WorkoutGroupWorkoutReferenceRepository? referenceRepository;
  final ExerciseRepository? exerciseRepository;
  final WorkoutDayTrainingLauncher? trainingLauncher;

  @override
  State<StartTrainingScreen> createState() => _StartTrainingScreenState();
}

class _StartTrainingScreenState extends State<StartTrainingScreen> {
  late final WorkoutPlanRepository _workoutPlanRepository;
  late final WorkoutDayRepository _workoutDayRepository;
  late final WorkoutGroupRepository _workoutGroupRepository;
  late final WorkoutExerciseRepository _workoutExerciseRepository;
  late final WorkoutGroupWorkoutReferenceRepository _referenceRepository;
  late final ExerciseRepository _exerciseRepository;
  late final WorkoutDayTrainingLauncher _trainingLauncher;

  List<WorkoutPlan> _plans = const [];
  List<WorkoutDay> _days = const [];
  List<_TrainingBlock> _blocks = const [];
  WorkoutPlan? _selectedPlan;
  WorkoutDay? _selectedDay;
  var _isLoading = true;
  var _isLaunching = false;

  @override
  void initState() {
    super.initState();
    _workoutPlanRepository =
        widget.workoutPlanRepository ??
        RepositoryRegistry.workoutPlanRepository;
    _workoutDayRepository =
        widget.workoutDayRepository ?? RepositoryRegistry.workoutDayRepository;
    _workoutGroupRepository =
        widget.workoutGroupRepository ??
        RepositoryRegistry.workoutGroupRepository;
    _workoutExerciseRepository =
        widget.workoutExerciseRepository ??
        RepositoryRegistry.workoutExerciseRepository;
    _referenceRepository =
        widget.referenceRepository ??
        RepositoryRegistry.workoutGroupWorkoutReferenceRepository;
    _exerciseRepository =
        widget.exerciseRepository ?? RepositoryRegistry.exerciseRepository;
    _trainingLauncher =
        widget.trainingLauncher ??
        WorkoutDayTrainingLauncher(
          workoutGroupRepository: _workoutGroupRepository,
          workoutExerciseRepository: _workoutExerciseRepository,
          referenceRepository: _referenceRepository,
        );
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final plans = (await _workoutPlanRepository.getAllWorkoutPlans())
        .where((plan) => !plan.isArchived)
        .toList(growable: false);
    if (!mounted) {
      return;
    }
    setState(() {
      _plans = plans;
      _selectedPlan = plans.isEmpty ? null : plans.first;
      _selectedDay = null;
      _days = const [];
      _blocks = const [];
      _isLoading = false;
    });
    if (plans.isNotEmpty) {
      await _selectPlan(plans.first);
    }
  }

  Future<void> _selectPlan(WorkoutPlan plan) async {
    setState(() {
      _selectedPlan = plan;
      _selectedDay = null;
      _days = const [];
      _blocks = const [];
    });
    final days = (await _workoutDayRepository.getWorkoutDays(
      workoutPlanId: plan.id,
    )).where((day) => !day.isArchived).toList(growable: false);
    if (!mounted || _selectedPlan?.id != plan.id) {
      return;
    }
    setState(() => _days = days);
    if (days.isNotEmpty) {
      await _selectDay(days.first);
    }
  }

  Future<void> _selectDay(WorkoutDay day) async {
    setState(() {
      _selectedDay = day;
      _blocks = const [];
    });
    if (day.isRestDay) {
      return;
    }

    final exercises = await _exerciseRepository.getExercises();
    final exerciseNames = {
      for (final exercise in exercises) exercise.id: exercise.name,
    };
    final groups = await _workoutGroupRepository.getWorkoutGroups(day.id);
    final blocks = <_TrainingBlock>[];
    for (final group in groups) {
      final references = await _referenceRepository.getReferences(group.id);
      final workouts = references.isEmpty
          ? await _workoutExerciseRepository.getWorkoutExercises(group.id)
          : (await Future.wait(
                  references.map(
                    (reference) => _workoutExerciseRepository
                        .getWorkoutExerciseById(reference.workoutExerciseId),
                  ),
                ))
                .whereType<WorkoutExercise>()
                .map(
                  (workout) => workout.copyWith(
                    workoutGroupId: group.id,
                    displayOrder: references
                        .firstWhere(
                          (reference) =>
                              reference.workoutExerciseId == workout.id,
                        )
                        .displayOrder,
                  ),
                )
                .toList(growable: false);
      blocks.add(
        _TrainingBlock(
          group: group,
          workouts: workouts
              .where((workout) => !workout.isArchived)
              .toList(growable: false),
          exerciseNames: exerciseNames,
        ),
      );
    }
    if (!mounted || _selectedDay?.id != day.id) {
      return;
    }
    setState(() => _blocks = blocks);
  }

  int get _workoutCount =>
      _blocks.fold(0, (count, block) => count + block.workouts.length);

  Future<void> _launchTraining() async {
    final plan = _selectedPlan;
    final day = _selectedDay;
    if (_isLaunching ||
        plan == null ||
        day == null ||
        day.isRestDay ||
        _workoutCount == 0) {
      return;
    }
    setState(() => _isLaunching = true);
    final launched = await _trainingLauncher.launch(
      context: context,
      workoutPlanId: plan.id,
      workoutPlanName: plan.name,
      workoutPlanCategory: plan.category,
      workoutDay: day,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isLaunching = false);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This training day has no executable workouts yet.'),
        ),
      );
    }
  }

  Future<void> _openWorkoutPlans() async {
    await context.push('/workout-plans');
    if (mounted) {
      await _loadPlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('START TRAINING')),
      body: RitmoCyberpunkBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: ritmoCyan))
            : SafeArea(
                child: _plans.isEmpty
                    ? _NoPrograms(onOpenPlans: _openWorkoutPlans)
                    : _buildTerminal(),
              ),
      ),
    );
  }

  Widget _buildTerminal() {
    final plan = _selectedPlan!;
    final day = _selectedDay;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        const RitmoHudSectionHeading(title: 'TRAINING TERMINAL'),
        const SizedBox(height: 8),
        const Text(
          'SELECT YOUR MISSION',
          style: TextStyle(
            color: Color(0xFF88AAB0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        _SelectionField<WorkoutPlan>(
          label: 'PROGRAM',
          value: plan,
          items: _plans,
          labelFor: (item) => item.name,
          onChanged: (value) {
            if (value != null) _selectPlan(value);
          },
        ),
        const SizedBox(height: 12),
        if (_days.isEmpty)
          _TerminalStatus(
            title: 'NO TRAINING DAYS AVAILABLE',
            message: 'Open this workout plan to configure training days.',
            actionLabel: 'OPEN WORKOUT PLAN',
            onAction: _openWorkoutPlans,
          )
        else ...[
          _SelectionField<WorkoutDay>(
            label: 'TRAINING DAY',
            value: day,
            items: _days,
            labelFor: (item) =>
                'DAY ${item.dayNumber.toString().padLeft(2, '0')}  //  ${item.name}',
            onChanged: (value) {
              if (value != null) _selectDay(value);
            },
          ),
          const SizedBox(height: 18),
          if (day != null) _buildBriefing(plan, day),
        ],
      ],
    );
  }

  Widget _buildBriefing(WorkoutPlan plan, WorkoutDay day) {
    if (day.isRestDay) {
      return _TerminalStatus(
        title: 'REST DAY',
        message:
            'This training day is reserved for recovery. Select another day to train.',
        actionLabel: 'OPEN WORKOUT PLAN',
        onAction: _openWorkoutPlans,
      );
    }
    if (_workoutCount == 0) {
      return _TerminalStatus(
        title: 'TRAINING NOT READY',
        message:
            'This training day does not contain workouts that can be started.',
        actionLabel: 'OPEN WORKOUT PLAN',
        onAction: _openWorkoutPlans,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RitmoHudSectionHeading(title: 'TRAINING BRIEFING'),
        const SizedBox(height: 12),
        RitmoHudPanel(
          glowStrength: 0.34,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'DAY ${day.dayNumber.toString().padLeft(2, '0')}  //  ${day.name}',
                style: const TextStyle(
                  color: ritmoCyan,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _BriefMetric(label: 'SESSIONS', value: '${_blocks.length}'),
                  const SizedBox(width: 18),
                  _BriefMetric(label: 'WORKOUTS', value: '$_workoutCount'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ..._blocks.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TrainingBlockCard(
              block: entry.value,
              position: entry.key + 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        RitmoActionButton(
          key: const Key('start-training-launch'),
          label: _isLaunching ? 'PREPARING TRAINING...' : 'START TRAINING',
          onPressed: _isLaunching ? null : _launchTraining,
          isPulsing: !_isLaunching,
        ),
      ],
    );
  }
}

class _SelectionField<T> extends StatelessWidget {
  const _SelectionField({
    required this.label,
    required this.value,
    required this.items,
    required this.labelFor,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T item) labelFor;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      glowStrength: 0.2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF101B20),
          iconEnabledColor: ritmoCyan,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(labelFor(item), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(growable: false),
          onChanged: onChanged,
          selectedItemBuilder: (context) => items
              .map(
                (item) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$label  //  ${labelFor(item)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFD8FCFF),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _BriefMetric extends StatelessWidget {
  const _BriefMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF88AAB0),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TrainingBlockCard extends StatelessWidget {
  const _TrainingBlockCard({required this.block, required this.position});

  final _TrainingBlock block;
  final int position;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.all(13),
      glowStrength: 0.16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SESSION ${position.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: ritmoOrange,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            block.group.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          ...block.workouts.map(
            (workout) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                '${block.exerciseNameFor(workout)}  //  ${_summary(workout)}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFFB7D1D6)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _summary(WorkoutExercise workout) {
    final parts = <String>[];
    if (workout.sets != null) {
      parts.add('${workout.sets} SETS');
    }
    if (workout.repetitions != null) {
      parts.add('${workout.repetitions} REPS');
    }
    if (workout.durationInSeconds != null) {
      parts.add('${workout.durationInSeconds}s');
    }
    if (workout.restInSeconds != null) {
      parts.add('${workout.restInSeconds}s REST');
    }
    return parts.isEmpty ? 'CONFIGURED' : parts.join(' / ');
  }
}

class _TerminalStatus extends StatelessWidget {
  const _TerminalStatus({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      glowStrength: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD8FCFF),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 7),
          Text(message),
          const SizedBox(height: 16),
          RitmoActionButton(label: actionLabel, onPressed: onAction),
        ],
      ),
    );
  }
}

class _NoPrograms extends StatelessWidget {
  const _NoPrograms({required this.onOpenPlans});

  final VoidCallback onOpenPlans;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _TerminalStatus(
          title: 'NO TRAINING PROGRAMS AVAILABLE',
          message: 'Build a workout plan before entering training mode.',
          actionLabel: 'OPEN WORKOUT PLANS',
          onAction: onOpenPlans,
        ),
      ),
    );
  }
}

class _TrainingBlock {
  const _TrainingBlock({
    required this.group,
    required this.workouts,
    required this.exerciseNames,
  });

  final WorkoutGroup group;
  final List<WorkoutExercise> workouts;
  final Map<String, String> exerciseNames;

  String exerciseNameFor(WorkoutExercise workout) =>
      exerciseNames[workout.exerciseId] ?? 'Unknown Workout';
}
