import 'package:flutter/foundation.dart';

import '../../domain/entities/workout_plan.dart';
import '../../domain/repositories/workout_plan_repository.dart';

class WorkoutPlanLibraryController extends ChangeNotifier {
  WorkoutPlanLibraryController({
    required this.repository,
  });

  final WorkoutPlanRepository repository;

  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = false;

  List<WorkoutPlan> get workoutPlans => _workoutPlans;

  bool get isLoading => _isLoading;

  bool get isEmpty => _workoutPlans.isEmpty;

  Future<void> loadWorkoutPlans() async {
    _setLoading(true);

    _workoutPlans = await repository.getAllWorkoutPlans();

    _setLoading(false);
  }

  Future<void> saveWorkoutPlan(WorkoutPlan workoutPlan) async {
    await repository.saveWorkoutPlan(workoutPlan);
    await loadWorkoutPlans();
  }

  Future<void> deleteWorkoutPlan(String id) async {
    await repository.deleteWorkoutPlan(id);
    await loadWorkoutPlans();
  }

  Future<bool> workoutPlanNameExists(String name) {
    return repository.existsByName(name);
  }

  Future<WorkoutPlan?> getWorkoutPlanById(String id) {
    return repository.getWorkoutPlanById(id);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}