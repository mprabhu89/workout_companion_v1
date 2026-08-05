import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../exercise/domain/entities/exercise.dart';

class SelectExerciseScreen extends StatefulWidget {
  const SelectExerciseScreen({
    super.key,
  });

  @override
  State<SelectExerciseScreen> createState() =>
      _SelectExerciseScreenState();
}

class _SelectExerciseScreenState
    extends State<SelectExerciseScreen> {
  List<Exercise> _exercises = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _exercises =
        await RepositoryRegistry.exerciseRepository
            .getExercises();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercise'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: _exercises.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1),
              itemBuilder: (context, index) {
                final exercise =
                    _exercises[index];

                return ListTile(
                  title: Text(exercise.name),
                  subtitle:
                      exercise.description.isEmpty
                          ? null
                          : Text(
                              exercise.description,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      exercise,
                    );
                  },
                );
              },
            ),
    );
  }
}