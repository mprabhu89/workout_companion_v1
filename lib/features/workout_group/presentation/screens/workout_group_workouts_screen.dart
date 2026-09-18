import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/presentation/screens/create_workout_flow_screen.dart';
import '../../../workout_exercise/presentation/screens/edit_workout_exercise_screen.dart';
import '../../../workout_group_workout_reference/domain/entities/workout_group_workout_reference.dart';
import '../../../workout_plan/presentation/widgets/training_program_hud_widgets.dart';

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

class _WorkoutGroupWorkoutsScreenState
    extends State<WorkoutGroupWorkoutsScreen> {
  static const _uuid = Uuid();
  late Future<List<_GroupWorkout>> _workouts;

  @override
  void initState() {
    super.initState();
    _workouts = _loadWorkouts();
  }

  /// Replaces the rendered snapshot only after the membership read completes.
  /// This keeps the Session list synchronized when a child route returns.
  Future<void> _refreshWorkouts() async {
    final refreshed = await _loadWorkouts();
    if (!mounted) return;
    setState(() {
      _workouts = Future.value(refreshed);
    });
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
    if (!mounted) return;
    final selected = await showModalBottomSheet<List<WorkoutExercise>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WorkoutLibraryPicker(
        attachedWorkoutIds: existing
            .map((reference) => reference.workoutExerciseId)
            .toSet(),
      ),
    );
    if (selected == null || selected.isEmpty) return;
    var nextOrder = await RepositoryRegistry
        .workoutGroupWorkoutReferenceRepository
        .getNextDisplayOrder(widget.workoutGroupId);
    var attachedAny = false;
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
        attachedAny = true;
      }
    }
    if (attachedAny) {
      await _refreshWorkouts();
    }
  }

  Future<void> _createWorkout() async {
    final created = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(builder: (_) => const CreateWorkoutFlowScreen()),
    );
    if (created == null) return;
    final order = await RepositoryRegistry
        .workoutGroupWorkoutReferenceRepository
        .getNextDisplayOrder(widget.workoutGroupId);
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
        .saveReference(
          WorkoutGroupWorkoutReference(
            id: _uuid.v4(),
            workoutGroupId: widget.workoutGroupId,
            workoutExerciseId: created.id,
            displayOrder: order,
          ),
        );
    await _refreshWorkouts();
  }

  Future<void> _editWorkout(WorkoutExercise workout) async {
    final exercise = await RepositoryRegistry.exerciseRepository
        .getExerciseById(workout.exerciseId);
    if (!mounted) return;
    final updated = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => EditWorkoutExerciseScreen(
          workoutExercise: workout,
          exerciseName: exercise?.name ?? 'Workout',
        ),
      ),
    );
    if (updated == null) return;
    await RepositoryRegistry.workoutExerciseRepository.saveWorkoutExercise(
      updated,
    );
    await _refreshWorkouts();
  }

  Future<void> _removeWorkout(_GroupWorkout groupWorkout) async {
    final confirmed = await AppDeleteConfirmationDialog.show(
      context,
      title: 'Remove From Session',
      message:
          'Remove this workout from ${widget.workoutGroupName}? It remains in the Workout Library.',
      deleteButtonText: 'Remove',
    );
    if (!confirmed) return;
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
        .archiveReference(groupWorkout.reference.id);
    await _refreshWorkouts();
  }

  Future<void> _move(
    List<_GroupWorkout> workouts,
    int index,
    int direction,
  ) async {
    final target = index + direction;
    if (target < 0 || target >= workouts.length) return;
    final current = workouts[index].reference;
    final other = workouts[target].reference;
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
        .saveReference(current.copyWith(displayOrder: other.displayOrder));
    await RepositoryRegistry.workoutGroupWorkoutReferenceRepository
        .saveReference(other.copyWith(displayOrder: current.displayOrder));
    await _refreshWorkouts();
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
      body: RitmoCyberpunkBackground(
        child: FutureBuilder<List<_GroupWorkout>>(
          future: _workouts,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: AppLoadingIndicator(
                  message: 'Loading Training Session...',
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: RitmoHudPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SESSION UNAVAILABLE',
                        style: TextStyle(
                          color: Color(0xFFD8FCFF),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please try loading this Training Session again.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _refreshWorkouts,
                        icon: const Icon(Icons.refresh),
                        label: const Text('RETRY'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ritmoCyan,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final workouts = snapshot.data ?? const <_GroupWorkout>[];
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const RitmoHudSectionHeading(title: 'TRAINING SESSION'),
                const SizedBox(height: 8),
                const RitmoHierarchyPath(items: ['PROGRAM', 'DAY', 'SESSION']),
                const SizedBox(height: 18),
                _GroupActionChoice(
                  icon: Icons.library_add_outlined,
                  title: 'ADD FROM WORKOUT LIBRARY',
                  subtitle: 'Use an existing Workout Library workout.',
                  onTap: _attachFromLibrary,
                ),
                const SizedBox(height: 10),
                _GroupActionChoice(
                  icon: Icons.add_circle_outline,
                  title: 'CREATE NEW WORKOUT',
                  subtitle: 'Build a new workout and add it to this Session.',
                  onTap: _createWorkout,
                  glowStrength: 0.4,
                ),
                const SizedBox(height: 20),
                if (workouts.isEmpty)
                  const RitmoHudPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SESSION READY',
                          style: TextStyle(
                            color: Color(0xFFD8FCFF),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Add workouts from your Workout Library or create a new workout.',
                        ),
                      ],
                    ),
                  )
                else
                  ...workouts.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _GroupWorkoutCard(
                        groupWorkout: entry.value,
                        index: entry.key,
                        lastIndex: workouts.length - 1,
                        nameFuture: _exerciseName(entry.value.workout),
                        onEdit: () => _editWorkout(entry.value.workout),
                        onMoveUp: () => _move(workouts, entry.key, -1),
                        onMoveDown: () => _move(workouts, entry.key, 1),
                        onRemove: () => _removeWorkout(entry.value),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GroupActionChoice extends StatelessWidget {
  const _GroupActionChoice({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.glowStrength = 0.2,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double glowStrength;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      glowStrength: glowStrength,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon, color: ritmoCyan),
                const SizedBox(width: 12),
                Expanded(
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
                      const SizedBox(height: 3),
                      Text(subtitle),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: ritmoCyan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupWorkoutCard extends StatelessWidget {
  const _GroupWorkoutCard({
    required this.groupWorkout,
    required this.index,
    required this.lastIndex,
    required this.nameFuture,
    required this.onEdit,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
  });

  final _GroupWorkout groupWorkout;
  final int index;
  final int lastIndex;
  final Future<String> nameFuture;
  final VoidCallback onEdit;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final workout = groupWorkout.workout;
    final metadata = <String>[];
    if (workout.sets != null) {
      metadata.add('${workout.sets} SETS');
    }
    if (workout.repetitions != null) {
      metadata.add('${workout.repetitions} REPS');
    }
    if (workout.durationInSeconds != null) {
      metadata.add('${workout.durationInSeconds}s');
    }
    if (workout.restInSeconds != null) {
      metadata.add('${workout.restInSeconds}s REST');
    }
    if (workout.sequenceDefinition != null) {
      metadata.add('${workout.sequenceDefinition!.steps.length} STEPS');
    }
    return RitmoHudPanel(
      glowStrength: 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WORKOUT ${(index + 1).toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: ritmoOrange,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.05,
            ),
          ),
          const SizedBox(height: 5),
          FutureBuilder<String>(
            future: nameFuture,
            builder: (_, snapshot) => Text(
              snapshot.data ?? 'Loading workout...',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          if (metadata.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(metadata.join(' / ')),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 4,
            children: [
              IconButton(
                tooltip: 'Move up',
                onPressed: index == 0 ? null : onMoveUp,
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                tooltip: 'Move down',
                onPressed: index == lastIndex ? null : onMoveDown,
                icon: const Icon(Icons.arrow_downward),
              ),
              IconButton(
                tooltip: 'Edit workout',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Remove from Session',
                onPressed: onRemove,
                color: const Color(0xFFF08A7A),
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
        ],
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
    return RitmoCyberpunkBackground(
      child: SafeArea(
        child: FutureBuilder<List<WorkoutExercise>>(
          future: RepositoryRegistry.workoutExerciseRepository
              .getAllWorkoutExercises(),
          builder: (context, snapshot) {
            final workouts = (snapshot.data ?? const <WorkoutExercise>[])
                .where(
                  (workout) => !widget.attachedWorkoutIds.contains(workout.id),
                )
                .toList(growable: false);
            return SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.76,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: RitmoHudSectionHeading(
                      title: 'ADD FROM WORKOUT LIBRARY',
                    ),
                  ),
                  Expanded(
                    child: snapshot.connectionState != ConnectionState.done
                        ? const Center(
                            child: AppLoadingIndicator(
                              message: 'Loading Workout Library...',
                            ),
                          )
                        : workouts.isEmpty
                        ? const Center(
                            child: Text(
                              'No available workouts in the Arsenal.',
                            ),
                          )
                        : ListView.builder(
                            itemCount: workouts.length,
                            itemBuilder: (context, index) {
                              final workout = workouts[index];
                              return Material(
                                color: Colors.transparent,
                                child: CheckboxListTile(
                                  value: _selectedIds.contains(workout.id),
                                  activeColor: ritmoCyan,
                                  title: FutureBuilder<String>(
                                    future: RepositoryRegistry
                                        .exerciseRepository
                                        .getExerciseById(workout.exerciseId)
                                        .then(
                                          (exercise) =>
                                              exercise?.name ??
                                              'Unknown workout',
                                        ),
                                    builder: (_, name) =>
                                        Text(name.data ?? 'Loading workout...'),
                                  ),
                                  onChanged: (selected) => setState(() {
                                    if (selected ?? false) {
                                      _selectedIds.add(workout.id);
                                    } else {
                                      _selectedIds.remove(workout.id);
                                    }
                                  }),
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: RitmoActionButton(
                      label: 'ADD SELECTED WORKOUTS',
                      onPressed: _selectedIds.isEmpty
                          ? null
                          : () => Navigator.of(context).pop(
                              workouts
                                  .where(
                                    (workout) =>
                                        _selectedIds.contains(workout.id),
                                  )
                                  .toList(growable: false),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
