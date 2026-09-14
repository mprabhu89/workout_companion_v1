import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/presentation/screens/create_workout_flow_screen.dart';
import '../../../workout_exercise/presentation/screens/edit_workout_exercise_screen.dart';
import '../../../workout_group_workout_reference/domain/entities/workout_group_workout_reference.dart';

class WorkoutGroupWorkoutsScreen extends StatefulWidget {
  const WorkoutGroupWorkoutsScreen({
    super.key,
    required this.workoutGroupId,
    required this.workoutGroupName,
  });

  final String workoutGroupId;
  final String workoutGroupName;

  @override
  State<WorkoutGroupWorkoutsScreen> createState() =>
      _WorkoutGroupWorkoutsScreenState();
}

class _WorkoutGroupWorkoutsScreenState extends State<WorkoutGroupWorkoutsScreen> {
  static const _uuid = Uuid();
  late Future<List<_GroupWorkout>> _workouts;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _workouts = _loadWorkouts();
  }

  Future<List<_GroupWorkout>> _loadWorkouts() async {
    final references = await RepositoryRegistry
        .workoutGroupWorkoutReferenceRepository
        .getReferences(widget.workoutGroupId);
    final workouts = <_GroupWorkout>[];
    for (final reference in references) {
      final workout = await RepositoryRegistry.workoutExerciseRepository
          .getWorkoutExerciseById(reference.workoutExerciseId);
      if (workout != null && !workout.isArchived) {
        workouts.add(_GroupWorkout(reference: reference, workout: workout));
      }
    }
    return workouts;
  }

  Future<void> _attachFromLibrary() async {
    final existing = await RepositoryRegistry
        .workoutGroupWorkoutReferenceRepository
        .getReferences(widget.workoutGroupId);
    if (!mounted) {
      return;
    }
    final selected = await showModalBottomSheet<List<WorkoutExercise>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _WorkoutLibraryPicker(
        attachedWorkoutIds: existing.map((reference) => reference.workoutExerciseId).toSet(),
      ),
    );
    if (selected == null || selected.isEmpty) {
      return;
    }

    var nextOrder = await RepositoryRegistry
        .workoutGroupWorkoutReferenceRepository
        .getNextDisplayOrder(widget.workoutGroupId);
    for (final workout in selected) {
      final exists = await RepositoryRegistry
          .workoutGroupWorkoutReferenceRepository
          .hasReference(
            workoutGroupId: widget.workoutGroupId,
            workoutExerciseId: workout.id,
          );
      if (!exists) {
        await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
            .saveReference(
          WorkoutGroupWorkoutReference(
            id: _uuid.v4(),
            workoutGroupId: widget.workoutGroupId,
            workoutExerciseId: workout.id,
            displayOrder: nextOrder++,
          ),
        );
      }
    }
    if (mounted) {
      setState(_reload);
    }
  }

  Future<void> _createWorkout() async {
    final created = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(builder: (_) => const CreateWorkoutFlowScreen()),
    );
    if (created == null) {
      return;
    }

    final order = await RepositoryRegistry
        .workoutGroupWorkoutReferenceRepository
        .getNextDisplayOrder(widget.workoutGroupId);
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository.saveReference(
      WorkoutGroupWorkoutReference(
        id: _uuid.v4(),
        workoutGroupId: widget.workoutGroupId,
        workoutExerciseId: created.id,
        displayOrder: order,
      ),
    );
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

  Future<void> _removeWorkout(_GroupWorkout groupWorkout) async {
    final confirmed = await AppDeleteConfirmationDialog.show(
      context,
      title: 'Remove Workout',
      message: 'Remove this workout from ${widget.workoutGroupName}? It remains in the Workout Library.',
      deleteButtonText: 'Remove',
    );
    if (!confirmed) {
      return;
    }
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
        .archiveReference(groupWorkout.reference.id);
    if (mounted) {
      setState(_reload);
    }
  }

  Future<void> _move(List<_GroupWorkout> workouts, int index, int direction) async {
    final target = index + direction;
    if (target < 0 || target >= workouts.length) {
      return;
    }
    final current = workouts[index].reference;
    final other = workouts[target].reference;
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
        .saveReference(current.copyWith(displayOrder: other.displayOrder));
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
        .saveReference(other.copyWith(displayOrder: current.displayOrder));
    if (mounted) {
      setState(_reload);
    }
  }

  Future<String> _exerciseName(WorkoutExercise workout) async {
    final exercise = await RepositoryRegistry.exerciseRepository
        .getExerciseById(workout.exerciseId);
    return exercise?.name ?? 'Unknown workout';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.workoutGroupName)),
      body: FutureBuilder<List<_GroupWorkout>>(
        future: _workouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final workouts = snapshot.data ?? const <_GroupWorkout>[];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _attachFromLibrary,
                        icon: const Icon(Icons.library_add_outlined),
                        label: const Text('Add from Library'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _createWorkout,
                        icon: const Icon(Icons.add),
                        label: const Text('Create New'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: workouts.isEmpty
                    ? const AppEmptyState(
                        title: 'No workouts in this group',
                        message: 'Add a workout from the library or create a new one.',
                        icon: Icons.fitness_center_outlined,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: workouts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final groupWorkout = workouts[index];
                          return Card(
                            child: ListTile(
                              onTap: () => _editWorkout(groupWorkout.workout),
                              title: FutureBuilder<String>(
                                future: _exerciseName(groupWorkout.workout),
                                builder: (_, name) => Text(name.data ?? 'Loading...'),
                              ),
                              subtitle: Text('Workout ${index + 1}'),
                              trailing: Wrap(
                                spacing: 0,
                                children: [
                                  IconButton(
                                    tooltip: 'Move up',
                                    onPressed: index == 0 ? null : () => _move(workouts, index, -1),
                                    icon: const Icon(Icons.arrow_upward),
                                  ),
                                  IconButton(
                                    tooltip: 'Move down',
                                    onPressed: index == workouts.length - 1 ? null : () => _move(workouts, index, 1),
                                    icon: const Icon(Icons.arrow_downward),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove from group',
                                    onPressed: () => _removeWorkout(groupWorkout),
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupWorkout {
  const _GroupWorkout({required this.reference, required this.workout});

  final WorkoutGroupWorkoutReference reference;
  final WorkoutExercise workout;
}

class _WorkoutLibraryPicker extends StatefulWidget {
  const _WorkoutLibraryPicker({required this.attachedWorkoutIds});

  final Set<String> attachedWorkoutIds;

  @override
  State<_WorkoutLibraryPicker> createState() => _WorkoutLibraryPickerState();
}

class _WorkoutLibraryPickerState extends State<_WorkoutLibraryPicker> {
  final Set<String> _selectedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<WorkoutExercise>>(
        future: RepositoryRegistry.workoutExerciseRepository.getAllWorkoutExercises(),
        builder: (context, snapshot) {
          final workouts = (snapshot.data ?? const <WorkoutExercise>[])
              .where((workout) => !widget.attachedWorkoutIds.contains(workout.id))
              .toList();
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.72,
            child: Column(
              children: [
                const ListTile(title: Text('Add from Workout Library')),
                Expanded(
                  child: snapshot.connectionState != ConnectionState.done
                      ? const Center(child: CircularProgressIndicator())
                      : workouts.isEmpty
                          ? const AppEmptyState(
                              title: 'No available workouts',
                              message: 'Create a workout in the Workout Library first.',
                            )
                          : ListView.builder(
                              itemCount: workouts.length,
                              itemBuilder: (context, index) {
                                final workout = workouts[index];
                                return CheckboxListTile(
                                  value: _selectedIds.contains(workout.id),
                                  title: FutureBuilder<String>(
                                    future: RepositoryRegistry.exerciseRepository
                                        .getExerciseById(workout.exerciseId)
                                        .then((exercise) => exercise?.name ?? 'Unknown workout'),
                                    builder: (_, name) => Text(name.data ?? 'Loading...'),
                                  ),
                                  onChanged: (selected) => setState(() {
                                    if (selected ?? false) {
                                      _selectedIds.add(workout.id);
                                    } else {
                                      _selectedIds.remove(workout.id);
                                    }
                                  }),
                                );
                              },
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilledButton(
                    onPressed: _selectedIds.isEmpty
                        ? null
                        : () => Navigator.of(context).pop(
                              workouts.where((workout) => _selectedIds.contains(workout.id)).toList(),
                            ),
                    child: const Text('Add selected workouts'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
