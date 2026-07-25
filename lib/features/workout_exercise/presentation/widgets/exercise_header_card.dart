import 'package:flutter/material.dart';

class ExerciseHeaderCard extends StatelessWidget {
  const ExerciseHeaderCard({
    super.key,
    required this.exerciseName,
    this.onChangeExercise,
  });

  final String exerciseName;
  final VoidCallback? onChangeExercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              child: Icon(Icons.fitness_center),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                exerciseName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            OutlinedButton(
              onPressed: onChangeExercise,
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}