import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../domain/entities/workout_exercise.dart';
import '../../domain/repositories/workout_exercise_repository.dart';

class WorkoutExerciseController extends ChangeNotifier {
  WorkoutExerciseController({
    required this.workoutGroupId,
    required this._repository,
  });

  final WorkoutExerciseRepository _repository;

  final String workoutGroupId;

  bool _isLoading = false;

  final List<WorkoutExercise> _workoutExercises = [];

  bool get isLoading => _isLoading;

  UnmodifiableListView<WorkoutExercise> get workoutExercises =>
      UnmodifiableListView(_workoutExercises);

  Future<void> loadWorkoutExercises() async {
    _isLoading = true;
    notifyListeners();

    _workoutExercises
      ..clear()
      ..addAll(
        await _repository.getWorkoutExercises(
          workoutGroupId,
        ),
      );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveWorkoutExercise(
    WorkoutExercise workoutExercise,
  ) async {
    await _repository.saveWorkoutExercise(
      workoutExercise,
    );

    await loadWorkoutExercises();
  }

  Future<void> deleteWorkoutExercise(
    String id,
  ) async {
    await _repository.deleteWorkoutExercise(
      id,
    );

    await loadWorkoutExercises();
  }

  Future<int> getNextDisplayOrder() {
    return _repository.getNextDisplayOrder(
      workoutGroupId,
    );
  }

  Future<WorkoutExercise?> getWorkoutExerciseById(
    String id,
  ) {
    return _repository.getWorkoutExerciseById(
      id,
    );
  }

  Future<bool> isDisplayOrderInUse({
    required int displayOrder,
    String? excludingWorkoutExerciseId,
  }) {
    return _repository.isDisplayOrderInUse(
      workoutGroupId: workoutGroupId,
      displayOrder: displayOrder,
      excludingWorkoutExerciseId:
          excludingWorkoutExerciseId,
    );
  }
}