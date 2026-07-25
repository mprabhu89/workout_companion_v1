import '../../domain/entities/workout_group.dart';
import '../../domain/repositories/workout_group_repository.dart';

class InMemoryWorkoutGroupRepository
    implements WorkoutGroupRepository {
  final List<WorkoutGroup> _workoutGroups = [];

  @override
  Future<List<WorkoutGroup>> getWorkoutGroups(
    String workoutDayId,
  ) async {
    final workoutGroups = _workoutGroups
        .where((group) => group.workoutDayId == workoutDayId)
        .toList()
      ..sort((a, b) => a.groupOrder.compareTo(b.groupOrder));

    return workoutGroups;
  }

  @override
  Future<WorkoutGroup?> getWorkoutGroupById(
    String id,
  ) async {
    try {
      return _workoutGroups.firstWhere(
        (group) => group.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveWorkoutGroup(
    WorkoutGroup workoutGroup,
  ) async {
    final index = _workoutGroups.indexWhere(
      (group) => group.id == workoutGroup.id,
    );

    if (index == -1) {
      _workoutGroups.add(workoutGroup);
    } else {
      _workoutGroups[index] = workoutGroup;
    }
  }

  @override
  Future<void> deleteWorkoutGroup(
    String id,
  ) async {
    _workoutGroups.removeWhere(
      (group) => group.id == id,
    );
  }

  @override
  Future<bool> existsByName(
    String workoutDayId,
    String name,
  ) async {
    return _workoutGroups.any(
      (group) =>
          group.workoutDayId == workoutDayId &&
          group.name.trim().toLowerCase() ==
              name.trim().toLowerCase(),
    );
  }
}