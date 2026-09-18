import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../domain/entities/ritmo_builtin_workouts.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_sequence_definition.dart';
import '../../domain/entities/workout_sequence_step.dart';
import '../../domain/entities/workout_target_type.dart';
import '../widgets/workout_exercise_form.dart';
import '../widgets/workout_sequence_editor.dart';

class EditWorkoutExerciseScreen extends StatefulWidget {
  const EditWorkoutExerciseScreen({
    super.key,
    required this.workoutExercise,
    required this.exerciseName,
  });

  final WorkoutExercise workoutExercise;
  final String exerciseName;

  @override
  State<EditWorkoutExerciseScreen> createState() =>
      _EditWorkoutExerciseScreenState();
}

class _EditWorkoutExerciseScreenState extends State<EditWorkoutExerciseScreen> {
  late final TextEditingController _targetValueController;
  late final TextEditingController _notesController;
  late int _sets;
  late int _restSeconds;
  late WorkoutTargetType _targetType;
  WorkoutSequenceDefinition? _sequenceDefinition;

  @override
  void initState() {
    super.initState();
    final workoutExercise = widget.workoutExercise;

    _sets = workoutExercise.sets ?? 3;
    _restSeconds = workoutExercise.restInSeconds ?? 60;
    _targetType = workoutExercise.targetType;
    _sequenceDefinition = workoutExercise.sequenceDefinition;
    _targetValueController = TextEditingController(
      text: _initialTargetValue(workoutExercise),
    )..addListener(_refreshCounterSummary);
    _notesController = TextEditingController(text: workoutExercise.notes);
  }

  @override
  void dispose() {
    _targetValueController.removeListener(_refreshCounterSummary);
    _targetValueController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  void _refreshCounterSummary() {
    if (mounted) {
      setState(() {});
    }
  }

  void _save() {
    final updated = _buildWorkoutExercise();
    final validationMessage = validateWorkoutSequenceDefinitionForEditor(
      workoutExercise: updated,
      sequenceDefinition: updated.sequenceDefinition,
    );

    if (validationMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationMessage)));
      return;
    }

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    if (RitmoBuiltinWorkouts.isBuiltinWorkoutId(widget.workoutExercise.id)) {
      return _BuiltinWorkoutDetails(
        workoutExercise: widget.workoutExercise,
        exerciseName: widget.exerciseName,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('EDIT WORKOUT'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: WorkoutExerciseForm(
            workoutExercise: _buildWorkoutExercise(),
            exerciseName: widget.exerciseName,
            sets: _sets,
            restSeconds: _restSeconds,
            targetType: _targetType,
            targetValueController: _targetValueController,
            notesController: _notesController,
            sequenceDefinition: _sequenceDefinition,
            onSetsChanged: (value) => setState(() => _sets = value),
            onRestChanged: (value) => setState(() => _restSeconds = value),
            onTargetTypeChanged: (value) {
              setState(() {
                _targetType = value;
                _targetValueController.clear();
              });
            },
            onSequenceChanged: (value) =>
                setState(() => _sequenceDefinition = value),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 18),
        child: RitmoActionButton(label: 'SAVE WORKOUT', onPressed: _save),
      ),
    );
  }

  WorkoutExercise _buildWorkoutExercise() {
    return WorkoutExercise(
      id: widget.workoutExercise.id,
      workoutGroupId: widget.workoutExercise.workoutGroupId,
      exerciseId: widget.workoutExercise.exerciseId,
      displayOrder: widget.workoutExercise.displayOrder,
      sets: _sets,
      targetType: _targetType,
      repetitions: _targetType == WorkoutTargetType.repetitions
          ? widget.workoutExercise.repetitions
          : null,
      durationInSeconds: _targetType == WorkoutTargetType.duration
          ? int.tryParse(_targetValueController.text.trim())
          : null,
      restInSeconds: _restSeconds,
      sessionRepetitions: widget.workoutExercise.sessionRepetitions,
      weight: widget.workoutExercise.weight,
      weightUnit: widget.workoutExercise.weightUnit,
      rpe: widget.workoutExercise.rpe,
      tempoType: widget.workoutExercise.tempoType,
      customTempo: widget.workoutExercise.customTempo,
      notes: _notesController.text.trim(),
      sequenceDefinition: _normalizedSequenceDefinition,
      isArchived: widget.workoutExercise.isArchived,
    );
  }

  WorkoutSequenceDefinition? get _normalizedSequenceDefinition {
    if (_sequenceDefinition == null || _sequenceDefinition!.steps.isEmpty) {
      return null;
    }

    return _sequenceDefinition;
  }

  String _initialTargetValue(WorkoutExercise workoutExercise) {
    switch (workoutExercise.targetType) {
      case WorkoutTargetType.repetitions:
        return workoutExercise.repetitions?.toString() ?? '';
      case WorkoutTargetType.duration:
        return workoutExercise.durationInSeconds?.toString() ?? '';
      default:
        return '';
    }
  }
}

class _BuiltinWorkoutDetails extends StatelessWidget {
  const _BuiltinWorkoutDetails({
    required this.workoutExercise,
    required this.exerciseName,
  });

  final WorkoutExercise workoutExercise;
  final String exerciseName;

  @override
  Widget build(BuildContext context) {
    final steps = workoutExercise.sequenceDefinition?.steps ?? const [];
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('RITMO SAMPLE'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              const RitmoHudSectionHeading(title: 'READ-ONLY WORKOUT'),
              const SizedBox(height: 14),
              RitmoHudPanel(
                glowStrength: 0.24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'RITMO SAMPLE',
                      style: TextStyle(
                        color: ritmoOrange,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('This RITMO-provided workout is read-only.'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              RitmoHudPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WORKOUT PARAMETERS',
                      style: TextStyle(
                        color: ritmoCyan,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${workoutExercise.sets ?? '-'} SETS  //  ${workoutExercise.repetitions ?? '-'} REPS  //  ${workoutExercise.restInSeconds ?? '-'}s REST',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const RitmoHudSectionHeading(title: 'SEQUENCE DEFINITION'),
              const SizedBox(height: 10),
              for (var index = 0; index < steps.length; index += 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RitmoHudPanel(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}'.padLeft(2, '0'),
                          style: const TextStyle(
                            color: ritmoOrange,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _stepLabel(steps[index]).toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFD8FCFF),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _stepSummary(steps[index]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _stepLabel(WorkoutSequenceStep step) {
    switch (step.type) {
      case WorkoutSequenceStepType.guide:
        return 'Guide';
      case WorkoutSequenceStepType.count:
        return 'Count';
      case WorkoutSequenceStepType.countSeconds:
        return 'Count Seconds';
      case WorkoutSequenceStepType.counter:
        return 'Reps - Counter';
      case WorkoutSequenceStepType.relax:
        return 'Relax';
      case WorkoutSequenceStepType.sequenceBreak:
        return 'Break';
      case WorkoutSequenceStepType.end:
        return 'End';
    }
  }

  String _stepSummary(WorkoutSequenceStep step) {
    switch (step.type) {
      case WorkoutSequenceStepType.guide:
        return step.text ?? '';
      case WorkoutSequenceStepType.count:
      case WorkoutSequenceStepType.countSeconds:
        final direction =
            step.countDirection == WorkoutCountDirection.descending
            ? 'descending'
            : 'ascending';
        return '${step.count ?? 0} $direction';
      case WorkoutSequenceStepType.counter:
        return '${step.repetitionCount ?? 0} repetitions';
      case WorkoutSequenceStepType.relax:
        return '${step.durationInSeconds ?? 0} seconds';
      case WorkoutSequenceStepType.sequenceBreak:
        return 'End set';
      case WorkoutSequenceStepType.end:
        return 'End workout';
    }
  }
}
