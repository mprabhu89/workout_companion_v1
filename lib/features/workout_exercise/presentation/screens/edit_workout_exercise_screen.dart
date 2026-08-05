import 'package:flutter/material.dart';

import '../../domain/entities/workout_exercise.dart';

class EditWorkoutExerciseScreen extends StatefulWidget {
  const EditWorkoutExerciseScreen({
    super.key,
    required this.workoutExercise,
  });

  final WorkoutExercise workoutExercise;

  @override
  State<EditWorkoutExerciseScreen> createState() =>
      _EditWorkoutExerciseScreenState();
}

class _EditWorkoutExerciseScreenState
    extends State<EditWorkoutExerciseScreen> {
  late final TextEditingController _setsController;
  late final TextEditingController _repetitionsController;
  late final TextEditingController _restController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();

    _setsController = TextEditingController(
      text: widget.workoutExercise.sets?.toString() ?? '',
    );

    _repetitionsController = TextEditingController(
      text: widget.workoutExercise.repetitions?.toString() ?? '',
    );

    _restController = TextEditingController(
      text:
          widget.workoutExercise.restInSeconds?.toString() ??
          '',
    );

    _notesController = TextEditingController(
      text: widget.workoutExercise.notes,
    );
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repetitionsController.dispose();
    _restController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  void _save() {
    final updated = widget.workoutExercise.copyWith(
      sets: int.tryParse(_setsController.text),
      repetitions:
          int.tryParse(_repetitionsController.text),
      restInSeconds:
          int.tryParse(_restController.text),
      notes: _notesController.text.trim(),
    );

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Workout Exercise',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _setsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Sets',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _repetitionsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Repetitions',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _restController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Rest (seconds)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Notes',
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}