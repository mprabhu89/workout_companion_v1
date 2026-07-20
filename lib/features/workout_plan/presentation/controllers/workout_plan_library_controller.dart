import 'package:flutter/foundation.dart';

import '../../domain/entities/workout_plan.dart';
import '../../domain/repositories/workout_plan_repository.dart';

class WorkoutPlanLibraryController extends ChangeNotifier {
  WorkoutPlanLibraryController({
    required WorkoutPlanRepository repository,
  }) : _repository = repository;

  final WorkoutPlanRepository _repository;

  List<WorkoutPlan> _workoutPlans = const [];

  bool _isLoading = false;

  List<WorkoutPlan> get workoutPlans =>
      List.unmodifiable(_workoutPlans);

  bool get isLoading => _isLoading;

  bool get isEmpty =>
      !_isLoading && _workoutPlans.isEmpty;

  Future<void> loadWorkoutPlans() async {
    _setLoading(true);

    _workoutPlans =
        await _repository.getAllWorkoutPlans();

    _setLoading(false);
  }

  Future<void> saveWorkoutPlan(
    WorkoutPlan workoutPlan,
  ) async {
    await _repository.saveWorkoutPlan(workoutPlan);
    await loadWorkoutPlans();
  }

  Future<void> deleteWorkoutPlan(String id) async {
    await _repository.deleteWorkoutPlan(id);
    await loadWorkoutPlans();
  }

  Future<bool> workoutPlanNameExists(
    String name,
  ) {
    return _repository.existsByName(name);
  }

  WorkoutPlan? getWorkoutPlanById(String id) {
    try {
      return _workoutPlans.firstWhere(
        (plan) => plan.id == id,
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