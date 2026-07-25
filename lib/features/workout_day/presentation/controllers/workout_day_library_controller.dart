import 'package:flutter/foundation.dart';

import '../../domain/entities/workout_day.dart';
import '../../domain/repositories/workout_day_repository.dart';

class WorkoutDayLibraryController extends ChangeNotifier {
  WorkoutDayLibraryController({
    required this.repository,
    required this.workoutPlanId,
  });

  final WorkoutDayRepository repository;
  final String workoutPlanId;

  List<WorkoutDay> _workoutDays = [];
  bool _isLoading = false;

  List<WorkoutDay> get workoutDays => _workoutDays;

  bool get isLoading => _isLoading;

  bool get isEmpty => _workoutDays.isEmpty;

  Future<void> loadWorkoutDays() async {
    _setLoading(true);

    _workoutDays = await repository.getWorkoutDays(
      workoutPlanId: workoutPlanId,
    );

    _setLoading(false);
  }

  Future<void> saveWorkoutDay(WorkoutDay workoutDay) async {
    await repository.saveWorkoutDay(workoutDay);
    await loadWorkoutDays();
  }

  Future<void> deleteWorkoutDay(String id) async {
    await repository.deleteWorkoutDay(id);
    await loadWorkoutDays();
  }

  Future<bool> workoutDayNameExists(String name) {
    return repository.existsByName(
      workoutPlanId: workoutPlanId,
      name: name,
    );
  }

  Future<WorkoutDay?> getWorkoutDayById(String id) {
    return repository.getWorkoutDayById(id);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}