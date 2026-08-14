import 'package:flutter/material.dart';

import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_sequence_definition.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Workout Exercise')),
      body: SafeArea(
        child: WorkoutExerciseForm(
          workoutExercise: _buildWorkoutExercise(),
          exerciseName: widget.exerciseName,
          sets: _sets,
          restSeconds: _restSeconds,
          targetType: _targetType,
          targetValueController: _targetValueController,
          notesController: _notesController,
          sequenceDefinition: _sequenceDefinition,
          onSetsChanged: (value) {
            setState(() {
              _sets = value;
            });
          },
          onRestChanged: (value) {
            setState(() {
              _restSeconds = value;
            });
          },
          onTargetTypeChanged: (value) {
            setState(() {
              _targetType = value;
              _targetValueController.clear();
            });
          },
          onSequenceChanged: (value) {
            setState(() {
              _sequenceDefinition = value;
            });
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _save,
          child: const Text('Save Workout Exercise'),
        ),
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
