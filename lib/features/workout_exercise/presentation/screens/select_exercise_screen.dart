import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_card.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../workout/domain/entities/exercise.dart';

class SelectExerciseScreen extends StatefulWidget {
  const SelectExerciseScreen({super.key});

  @override
  State<SelectExerciseScreen> createState() =>
      _SelectExerciseScreenState();
}

class _SelectExerciseScreenState
    extends State<SelectExerciseScreen> {
  bool _isLoading = true;

  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    _exercises = await RepositoryRegistry.exerciseRepository.getAllExercises();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercise'),
      ),
      body: _isLoading
          ? const AppLoadingIndicator(
              message: 'Loading exercises...',
            )
          : _exercises.isEmpty
              ? const AppEmptyState(
                  title: 'No Exercises',
                  message:
                      'Create an exercise in the Exercise Library first.',
                )
              : ListView.builder(
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];

                    return AppListCard(
                      title: exercise.name,
                      subtitle: exercise.description,
                      onTap: () {
                        Navigator.of(context).pop(exercise);
                      },
                    );
                  },
                ),
    );
  }
}