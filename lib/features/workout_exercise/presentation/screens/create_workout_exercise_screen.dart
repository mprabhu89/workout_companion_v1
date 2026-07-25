import 'package:flutter/material.dart';

import '../../domain/entities/workout_target_type.dart';
import '../widgets/workout_exercise_form.dart';

class CreateWorkoutExerciseScreen extends StatefulWidget {
  const CreateWorkoutExerciseScreen({
    super.key,
    required this.exerciseName,
  });

  final String exerciseName;

  @override
  State<CreateWorkoutExerciseScreen> createState() =>
      _CreateWorkoutExerciseScreenState();
}

class _CreateWorkoutExerciseScreenState
    extends State<CreateWorkoutExerciseScreen> {
  final _targetValueController = TextEditingController();
  final _notesController = TextEditingController();

  int _sets = 3;
  int _restSeconds = 60;

  WorkoutTargetType _targetType =
      WorkoutTargetType.repetitions;

  @override
  void dispose() {
    _targetValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveWorkoutExercise() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Workout Exercise save will be implemented in the next step.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Exercise'),
      ),
      body: SafeArea(
        child: WorkoutExerciseForm(
          exerciseName: widget.exerciseName,
          sets: _sets,
          restSeconds: _restSeconds,
          targetType: _targetType,
          targetValueController: _targetValueController,
          notesController: _notesController,
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
          onChangeExercise: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Exercise selection will be connected next.',
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: _saveWorkoutExercise,
          icon: const Icon(Icons.save),
          label: const Text('Save Workout Exercise'),
        ),
      ),
    );
  }
}