import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/services/workout_export_permission.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../domain/entities/ritmo_builtin_workouts.dart';
import '../../domain/entities/workout_exercise.dart';
import '../admin/workout_json_export.dart';
import 'create_workout_flow_screen.dart';
import 'edit_workout_exercise_screen.dart';

/// Manages canonical, reusable workout definitions independently of plans.
class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({
    super.key,
    this.exportPermission,
  });

  /// Injected only by internal tooling or tests. Production defaults to no
  /// export permission while debug builds retain the diagnostic action.
  final WorkoutExportPermission? exportPermission;

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  late Future<List<WorkoutExercise>> _workouts;
  late final WorkoutExportPermission _exportPermission;

  @override
  void initState() {
    super.initState();
    _exportPermission =
        widget.exportPermission ?? const DevelopmentWorkoutExportPermission();
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
    if (RitmoBuiltinWorkouts.isBuiltinWorkoutId(workout.id)) {
      return;
    }
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

  Future<void> _exportWorkoutJson(WorkoutExercise workout) async {
    if (!_exportPermission.canExportWorkoutJson) {
      return;
    }

    final persistedWorkout = await RepositoryRegistry.workoutExerciseRepository
            .getWorkoutExerciseById(workout.id) ??
        workout;
    final linkedExercise = await RepositoryRegistry.exerciseRepository
        .getExerciseById(persistedWorkout.exerciseId);
    final json = WorkoutJsonExport.encode(
      workoutExercise: persistedWorkout,
      linkedExercise: linkedExercise,
    );

    debugPrint('===== RITMO WORKOUT EXPORT START =====');
    debugPrint(json);
    debugPrint('===== RITMO WORKOUT EXPORT END =====');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout exported to debug console')),
      );
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
              final isBuiltin =
                  RitmoBuiltinWorkouts.isBuiltinWorkoutId(workout.id);
              return Card(
                child: ListTile(
                  onTap: () => _editWorkout(workout),
                  leading: const Icon(Icons.fitness_center_outlined),
                  title: FutureBuilder<String>(
                    future: _exerciseName(workout.exerciseId),
                    builder: (_, name) => Text(name.data ?? 'Loading...'),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_summary(workout)),
                      if (isBuiltin)
                        const Text(
                          'RITMO Sample',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_exportPermission.canExportWorkoutJson)
                        PopupMenuButton<String>(
                          tooltip: 'Workout actions',
                          icon: const Icon(Icons.more_vert),
                          onSelected: (_) => _exportWorkoutJson(workout),
                          itemBuilder: (context) => const [
                            PopupMenuItem<String>(
                              value: 'export',
                              child: Text('Export Workout JSON'),
                            ),
                          ],
                        ),
                      if (!isBuiltin)
                        IconButton(
                          tooltip: 'Archive workout',
                          icon: const Icon(Icons.archive_outlined),
                          onPressed: () => _archiveWorkout(workout),
                        ),
                    ],
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
