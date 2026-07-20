import 'package:flutter/material.dart';

import '../../data/repositories/in_memory_exercise_repository.dart';
import '../../domain/entities/exercise.dart';
import '../controllers/exercise_library_controller.dart';
import 'create_exercise_screen.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState
    extends State<ExerciseLibraryScreen> {
  late final ExerciseLibraryController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ExerciseLibraryController(
      repository: InMemoryExerciseRepository(),
    );

    _controller.addListener(_refresh);

    _controller.loadExercises();
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

  Future<void> _createExercise() async {
    final exercise = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(
        builder: (_) => CreateExerciseScreen(
          existingNames: _controller.exercises
              .map((exercise) => exercise.name)
              .toList(),
        ),
      ),
    );

    if (exercise == null) {
      return;
    }

    await _controller.saveExercise(exercise);
  }

  Future<void> _editExercise(Exercise exercise) async {
    final updatedExercise =
        await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(
        builder: (_) => CreateExerciseScreen(
          exercise: exercise,
          existingNames: _controller.exercises
              .map((item) => item.name)
              .toList(),
        ),
      ),
    );

    if (updatedExercise == null) {
      return;
    }

    await _controller.saveExercise(updatedExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createExercise,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_controller.isEmpty) {
      return const Center(
        child: Text(
          'No exercises yet.\nTap + to create your first exercise.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _controller.exercises.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final exercise = _controller.exercises[index];

        return _ExerciseCard(
          exercise: exercise,
          onTap: () => _editExercise(exercise),
          onDelete: () async {
            await _controller.deleteExercise(exercise.id);
          },
        );
      },
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.onTap,
    required this.onDelete,
  });

  final Exercise exercise;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(exercise.name),
        subtitle: exercise.description.isEmpty
            ? null
            : Text(exercise.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}