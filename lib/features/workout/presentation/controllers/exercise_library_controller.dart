import 'package:flutter/foundation.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';

class ExerciseLibraryController extends ChangeNotifier {
  ExerciseLibraryController({
    required this._repository,
  });

  final ExerciseRepository _repository;

  List<Exercise> _exercises = const [];

  bool _isLoading = false;

  List<Exercise> get exercises => List.unmodifiable(_exercises);

  bool get isLoading => _isLoading;

  bool get isEmpty => !_isLoading && _exercises.isEmpty;

  Future<void> loadExercises() async {
    _setLoading(true);

    _exercises = await _repository.getAllExercises();

    _setLoading(false);
  }

  Future<void> saveExercise(Exercise exercise) async {
    await _repository.saveExercise(exercise);
    await loadExercises();
  }

  Future<void> deleteExercise(String id) async {
    await _repository.deleteExercise(id);
    await loadExercises();
  }

  Future<bool> exerciseNameExists(String name) {
    return _repository.existsByName(name);
  }

  Exercise? getExerciseById(String id) {
    try {
      return _exercises.firstWhere(
        (exercise) => exercise.id == id,
      );
    } on StateError {
      return null;
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    notifyListeners();
  }
}
