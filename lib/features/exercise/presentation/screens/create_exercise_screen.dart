import 'package:flutter/material.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/enums/difficulty_level.dart';
import '../../domain/enums/equipment_type.dart';
import '../../domain/enums/muscle_group.dart';
import '../widgets/exercise_form.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({
    super.key,
  });

  @override
  State<CreateExerciseScreen> createState() =>
      _CreateExerciseScreenState();
}

class _CreateExerciseScreenState
    extends State<CreateExerciseScreen> {
  final _nameController = TextEditingController();

  final _descriptionController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Exercise name is required.',
          ),
        ),
      );
      return;
    }

    final exercise = Exercise(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      name: name,
      description: _descriptionController.text.trim(),
      instructions: '',
      muscleGroup: MuscleGroup.fullBody,
      equipment: EquipmentType.bodyweight,
      difficulty: DifficultyLevel.beginner,
      isCustom: true,
      isArchived: false,
    );

    Navigator.of(context).pop(exercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Exercise',
        ),
      ),
      body: ExerciseForm(
        nameController: _nameController,
        descriptionController:
            _descriptionController,
        onSave: _save,
        saveButtonText: 'Create Exercise',
      ),
    );
  }
}