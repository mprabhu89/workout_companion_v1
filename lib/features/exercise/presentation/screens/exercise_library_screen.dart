import 'package:flutter/material.dart';
import 'exercise_details_screen.dart';
import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../widgets/exercise_card.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../domain/entities/exercise.dart';
import '../controllers/exercise_controller.dart';
import 'create_exercise_screen.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({
    super.key,
  });

  @override
  State<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState
    extends State<ExerciseLibraryScreen> {
  late final ExerciseController _controller;

  final TextEditingController _searchController =
      TextEditingController();

  List<Exercise> _filteredExercises = const [];

  @override
  void initState() {
    super.initState();

    _controller = ExerciseController(
      repository: RepositoryRegistry.exerciseRepository,
    );

    _load();
  }

  Future<void> _load() async {
    await _controller.loadExercises();

    if (!mounted) {
      return;
    }

    setState(() {
      _filteredExercises =
          List<Exercise>.from(_controller.exercises);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    final normalized = query.trim().toLowerCase();

    setState(() {
      if (normalized.isEmpty) {
        _filteredExercises =
            List<Exercise>.from(_controller.exercises);
        return;
      }

      _filteredExercises = _controller.exercises
          .where(
            (exercise) =>
                exercise.name
                    .toLowerCase()
                    .contains(normalized) ||
                exercise.description
                    .toLowerCase()
                    .contains(normalized),
          )
          .toList();
    });
  }

  Future<void> _createExercise() async {
    final exercise =
        await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(
        builder: (_) => const CreateExerciseScreen(),
      ),
    );

    if (exercise == null) {
      return;
    }

    await _controller.saveExercise(exercise);

    _search(_searchController.text);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${exercise.name} created successfully.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Scaffold(
            body: AppLoadingIndicator(
              message: 'Loading exercises...',
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Exercise Library'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createExercise,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              AppSearchBar(
                controller: _searchController,
                hintText: 'Search exercises...',
                onChanged: _search,
              ),
              Expanded(
                child: _filteredExercises.isEmpty
                    ? const AppEmptyState(
                        title: 'No Exercises',
                        message:
                            'No exercises match your search.',
                      )
                    : ListView(
                      children: [
                        if (_filteredExercises.any((e) => !e.isCustom)) ...[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'Built-in Exercises',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ..._filteredExercises
                              .where((e) => !e.isCustom)
                              .map(
                                (exercise) => ExerciseCard(
                                  exercise: exercise,
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ExerciseDetailsScreen(
                                          exercise: exercise,
                                        ),
                                      ),
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    await _load();
                                  },
                                )
                              ),
                        ],
                        if (_filteredExercises.any((e) => e.isCustom)) ...[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                            child: Text(
                              'My Exercises',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ..._filteredExercises
                              .where((e) => e.isCustom)
                              .map(
                                (exercise) => ExerciseCard(
                                  exercise: exercise,
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ExerciseDetailsScreen(
                                          exercise: exercise,
                                        ),
                                      ),
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    await _load();
                                  },
                                )
                              ),
                        ],
                      ],
                    )
              ),
            ],
          ),
        );
      },
    );
  }
}