import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../domain/entities/workout_exercise.dart';
import 'create_workout_flow_screen.dart';
import 'edit_workout_exercise_screen.dart';

/// Manages canonical, reusable workout definitions independently of plans.
class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  late Future<List<WorkoutExercise>> _workouts;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _workouts = RepositoryRegistry.workoutExerciseRepository
        .getAllWorkoutExercises();
  }

  Future<void> _createWorkout() async {
    final created = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(builder: (_) => const CreateWorkoutFlowScreen()),
    );
    if (created == null) {
      return;
    }
    if (mounted) {
      setState(_reload);
    }
  }

  Future<void> _editWorkout(WorkoutExercise workout) async {
    final exercise = await RepositoryRegistry.exerciseRepository
        .getExerciseById(workout.exerciseId);
    if (!mounted) {
      return;
    }

    final updated = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => EditWorkoutExerciseScreen(
          workoutExercise: workout,
          exerciseName: exercise?.name ?? 'Workout',
        ),
      ),
    );
    if (updated == null) {
      return;
    }

    await RepositoryRegistry.workoutExerciseRepository
        .saveWorkoutExercise(updated);
    if (mounted) {
      setState(_reload);
    }
  }

  Future<void> _archiveWorkout(WorkoutExercise workout) async {
    final confirmed = await AppDeleteConfirmationDialog.show(
      context,
      title: 'Archive Workout',
      message: 'Archive this workout? It will be removed from the Workout Library.',
      deleteButtonText: 'Archive',
    );
    if (!confirmed) {
      return;
    }

    await RepositoryRegistry.workoutExerciseRepository.saveWorkoutExercise(
      workout.copyWith(isArchived: true),
    );
    if (mounted) {
      setState(_reload);
    }
  }

  Future<String> _exerciseName(String exerciseId) async {
    final exercise = await RepositoryRegistry.exerciseRepository
        .getExerciseById(exerciseId);
    return exercise?.name ?? 'Unknown workout';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Library')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createWorkout,
        icon: const Icon(Icons.add),
        label: const Text('Create Workout'),
      ),
      body: FutureBuilder<List<WorkoutExercise>>(
        future: _workouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const AppEmptyState(
              title: 'Workout Library unavailable',
              message: 'Try opening the library again.',
            );
          }
          final workouts = snapshot.data ?? const <WorkoutExercise>[];
          if (workouts.isEmpty) {
            return const AppEmptyState(
              title: 'No workouts yet',
              message: 'Create a workout to reuse it in any workout group.',
              icon: Icons.fitness_center_outlined,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: workouts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                child: ListTile(
                  onTap: () => _editWorkout(workout),
                  leading: const Icon(Icons.fitness_center_outlined),
                  title: FutureBuilder<String>(
                    future: _exerciseName(workout.exerciseId),
                    builder: (_, name) => Text(name.data ?? 'Loading...'),
                  ),
                  subtitle: Text(_summary(workout)),
                  trailing: IconButton(
                    tooltip: 'Archive workout',
                    icon: const Icon(Icons.archive_outlined),
                    onPressed: () => _archiveWorkout(workout),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _summary(WorkoutExercise workout) {
    final parts = <String>[];
    if (workout.sets != null) {
      parts.add('${workout.sets} sets');
    }
    if (workout.sequenceDefinition != null) {
      parts.add('${workout.sequenceDefinition!.steps.length} sequence steps');
    }
    return parts.isEmpty ? 'Workout configuration' : parts.join(' | ');
  }
}
