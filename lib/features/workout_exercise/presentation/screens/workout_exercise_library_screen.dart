import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

class WorkoutExerciseLibraryScreen extends StatefulWidget {
  const WorkoutExerciseLibraryScreen({
    super.key,
    required this.workoutGroupName,
  });

  final String workoutGroupName;

  @override
  State<WorkoutExerciseLibraryScreen> createState() =>
      _WorkoutExerciseLibraryScreenState();
}

class _WorkoutExerciseLibraryScreenState
    extends State<WorkoutExerciseLibraryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutGroupName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Exercise picker will be connected next.',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const AppEmptyState(
        title: 'No Workout Exercises',
        message: 'Tap + to add your first workout exercise.',
      ),
    );
  }
}