import 'package:flutter/material.dart';

void main() {
  runApp(const WorkoutCompanionApp());
}

class WorkoutCompanionApp extends StatelessWidget {
  const WorkoutCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Workout Companion',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}