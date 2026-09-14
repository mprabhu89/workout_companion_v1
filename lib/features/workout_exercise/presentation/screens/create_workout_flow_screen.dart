import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/enums/difficulty_level.dart';
import '../../../exercise/domain/enums/equipment_type.dart';
import '../../../exercise/domain/enums/muscle_group.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_target_type.dart';
import '../../domain/repositories/workout_exercise_repository.dart';
import 'create_workout_exercise_screen.dart';

/// Creates a custom exercise and its canonical workout only after final save.
class CreateWorkoutFlowScreen extends StatefulWidget {
  const CreateWorkoutFlowScreen({
    super.key,
    this.exerciseRepository,
    this.workoutExerciseRepository,
  });

  final ExerciseRepository? exerciseRepository;
  final WorkoutExerciseRepository? workoutExerciseRepository;

  @override
  State<CreateWorkoutFlowScreen> createState() => _CreateWorkoutFlowScreenState();
}

class _CreateWorkoutFlowScreenState extends State<CreateWorkoutFlowScreen> {
  final _workoutNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _workoutNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _defineExercise() async {
    final workoutName = _workoutNameController.text.trim();
    if (workoutName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout name is required.')),
      );
      return;
    }

    final workout = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => _DefineExerciseScreen(
          workoutName: workoutName,
          description: _descriptionController.text.trim(),
          exerciseRepository:
              widget.exerciseRepository ?? RepositoryRegistry.exerciseRepository,
          workoutExerciseRepository: widget.workoutExerciseRepository ??
              RepositoryRegistry.workoutExerciseRepository,
        ),
      ),
    );
    if (workout != null && mounted) {
      Navigator.of(context).pop(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Name Your Workout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Create a reusable workout with your own name.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _workoutNameController,
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Workout Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _defineExercise,
            child: const Text('Next: Define Exercise'),
          ),
        ],
      ),
    );
  }
}

class _DefineExerciseScreen extends StatefulWidget {
  const _DefineExerciseScreen({
    required this.workoutName,
    required this.description,
    required this.exerciseRepository,
    required this.workoutExerciseRepository,
  });

  final String workoutName;
  final String description;
  final ExerciseRepository exerciseRepository;
  final WorkoutExerciseRepository workoutExerciseRepository;

  @override
  State<_DefineExerciseScreen> createState() => _DefineExerciseScreenState();
}

class _DefineExerciseScreenState extends State<_DefineExerciseScreen> {
  static const _uuid = Uuid();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _configureWorkout() async {
    final exercise = Exercise(
      id: _uuid.v4(),
      name: widget.workoutName,
      description: widget.description,
      instructions: _instructionsController.text.trim(),
      muscleGroup: MuscleGroup.fullBody,
      equipment: EquipmentType.bodyweight,
      difficulty: DifficultyLevel.beginner,
      isCustom: true,
    );
    final configured = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutExerciseScreen(
          exerciseName: exercise.name,
          workoutExercise: WorkoutExercise(
            id: _uuid.v4(),
            exerciseId: exercise.id,
            displayOrder: 0,
            targetType: WorkoutTargetType.repetitions,
            sets: 3,
            repetitions: 10,
            restInSeconds: 60,
          ),
        ),
      ),
    );
    if (configured == null) {
      return;
    }

    await widget.exerciseRepository.saveExercise(exercise);
    await widget.workoutExerciseRepository.saveWorkoutExercise(configured);
    if (mounted) {
      Navigator.of(context).pop(configured);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Define Exercise')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.workoutName, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('This will be saved as a custom exercise in your Workout Library.'),
          const SizedBox(height: 20),
          TextField(
            controller: _instructionsController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Instructions (optional)',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _configureWorkout,
            child: const Text('Next: Configure Workout'),
          ),
        ],
      ),
    );
  }
}
