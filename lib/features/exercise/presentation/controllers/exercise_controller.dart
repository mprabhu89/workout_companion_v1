import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';

class ExerciseController extends ChangeNotifier {
  ExerciseController({
    required this._repository,
  });

  final ExerciseRepository _repository;

  bool _isLoading = false;

  final List<Exercise> _exercises = [];

  bool get isLoading => _isLoading;

  UnmodifiableListView<Exercise> get exercises =>
      UnmodifiableListView(_exercises);

  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();

    _exercises
      ..clear()
      ..addAll(
        await _repository.getExercises(),
      );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveExercise(
    Exercise exercise,
  ) async {
    await _repository.saveExercise(exercise);
    await loadExercises();
  }

  Future<void> deleteExercise(
    String id,
  ) async {
    await _repository.deleteExercise(id);
    await loadExercises();
  }

  Future<Exercise?> getExerciseById(
    String id,
  ) {
    return _repository.getExerciseById(id);
  }

  Future<bool> isExerciseNameInUse(
    String name, {
    String? excludingExerciseId,
  }) {
    return _repository.isExerciseNameInUse(
      name,
      excludingExerciseId: excludingExerciseId,
    );
  }

  Future<List<Exercise>> searchExercises(
    String query,
  ) {
    return _repository.searchExercises(query);
  }
}