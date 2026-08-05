import 'package:flutter/material.dart';
import 'edit_workout_exercise_screen.dart';
import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../domain/entities/workout_exercise.dart';
import '../controllers/workout_exercise_controller.dart';
import 'package:uuid/uuid.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../domain/entities/workout_target_type.dart';
import 'select_exercise_screen.dart';

class WorkoutExerciseLibraryScreen extends StatefulWidget {
  const WorkoutExerciseLibraryScreen({
    super.key,
    required this.workoutGroupId,
    required this.workoutGroupName,
  });

  final String workoutGroupId;
  final String workoutGroupName;

  @override
  State<WorkoutExerciseLibraryScreen> createState() =>
      _WorkoutExerciseLibraryScreenState();
}

class _WorkoutExerciseLibraryScreenState
    extends State<WorkoutExerciseLibraryScreen> {
  late final WorkoutExerciseController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WorkoutExerciseController(
      workoutGroupId: widget.workoutGroupId,
      repository:
          RepositoryRegistry.workoutExerciseRepository,
    );

    _controller.addListener(_refresh);

    _controller.loadWorkoutExercises();
  }

  String _buildSubtitle(WorkoutExercise exercise) {
    final parts = <String>[];

    if (exercise.sets != null) {
      parts.add('${exercise.sets} Sets');
    }

    switch (exercise.targetType) {
      case WorkoutTargetType.repetitions:
        if (exercise.repetitions != null) {
          parts.add('${exercise.repetitions} Reps');
        }
        break;

      case WorkoutTargetType.duration:
        if (exercise.durationInSeconds != null) {
          parts.add('${exercise.durationInSeconds} sec');
        }
        break;

      default:
        break;
    }

    if (exercise.restInSeconds != null) {
      parts.add('Rest ${exercise.restInSeconds}s');
    }

    return parts.join(' • ');
  }

  Future<String> _getExerciseName(String exerciseId) async {
    final exercise =
        await RepositoryRegistry.exerciseRepository
            .getExerciseById(exerciseId);

    return exercise?.name ?? 'Unknown Exercise';
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  static const _uuid = Uuid();

  Future<void> _addExercise() async {
    final Exercise? exercise =
        await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(
        builder: (_) => const SelectExerciseScreen(),
      ),
    );

    if (exercise == null) {
      return;
    }

    final displayOrder =
        await _controller.getNextDisplayOrder();

    final workoutExercise = WorkoutExercise(
      id: _uuid.v4(),
      workoutGroupId: widget.workoutGroupId,
      exerciseId: exercise.id,
      displayOrder: displayOrder,

      targetType: WorkoutTargetType.repetitions,

      sets: 3,

      repetitions: 10,

      restInSeconds: 60,
    );

    await _controller.saveWorkoutExercise(
      workoutExercise,
    );
  }

  Future<void> _deleteExercise(
    WorkoutExercise exercise,
  ) async {
    await _controller.deleteWorkoutExercise(
      exercise.id,
    );
  }

  Future<void> _editExercise(
    WorkoutExercise workoutExercise,
  ) async {
    final updated =
        await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => EditWorkoutExerciseScreen(
          workoutExercise: workoutExercise,
        ),
      ),
    );

    if (updated == null) {
      return;
    }

    await _controller.saveWorkoutExercise(updated);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutGroupName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const AppLoadingIndicator(
        message: 'Loading exercises...',
      );
    }

    if (_controller.workoutExercises.isEmpty) {
      return const AppEmptyState(
        title: 'No Workout Exercises',
        message:
            'Tap + to add your first workout exercise.',
      );
    }

    return ListView.builder(
      itemCount: _controller.workoutExercises.length,
      itemBuilder: (context, index) {
        final exercise = _controller.workoutExercises[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ListTile(
            onTap: () => _editExercise(exercise),

            title: FutureBuilder<String>(
              future: _getExerciseName(exercise.exerciseId),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? 'Loading...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            subtitle: Text(
              _buildSubtitle(exercise),
            ),

            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteExercise(exercise),
            ),
          ),
        );
      },
    );
  }
}