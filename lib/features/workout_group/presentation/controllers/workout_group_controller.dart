import 'package:flutter/foundation.dart';

import '../../domain/entities/workout_group.dart';
import '../../domain/repositories/workout_group_repository.dart';

class WorkoutGroupController extends ChangeNotifier {
  WorkoutGroupController({
    required this.repository,
    required this.workoutDayId,
  });

  final WorkoutGroupRepository repository;
  final String workoutDayId;

  bool _isLoading = false;
  List<WorkoutGroup> _workoutGroups = [];

  bool get isLoading => _isLoading;

  List<WorkoutGroup> get workoutGroups =>
      List.unmodifiable(_workoutGroups);

  Future<void> loadWorkoutGroups() async {
    _setLoading(true);

    _workoutGroups = await repository.getWorkoutGroups(
      workoutDayId,
    );

    _setLoading(false);
  }

  Future<void> saveWorkoutGroup(
    WorkoutGroup workoutGroup,
  ) async {
    await repository.saveWorkoutGroup(workoutGroup);
    await loadWorkoutGroups();
  }

  Future<void> deleteWorkoutGroup(
    String id,
  ) async {
    await repository.deleteWorkoutGroup(id);
    await loadWorkoutGroups();
  }

  Future<bool> existsByName(
    String name,
  ) {
    return repository.existsByName(
      workoutDayId,
      name,
    );
  }

  WorkoutGroup? getWorkoutGroupById(
    String id,
  ) {
    try {
      return _workoutGroups.firstWhere(
        (group) => group.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}