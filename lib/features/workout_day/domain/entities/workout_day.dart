import 'package:flutter/foundation.dart';

@immutable
class WorkoutDay {
  const WorkoutDay({
    required this.id,
    required this.workoutPlanId,
    required this.name,
    required this.dayOrder,
    this.notes = '',
    this.isEnabled = true,
  });

  final String id;
  final String workoutPlanId;

  /// Example:
  /// Day 1
  /// Push
  /// Monday
  final String name;

  /// Display order inside a workout plan.
  final int dayOrder;

  final String notes;

  final bool isEnabled;

  WorkoutDay copyWith({
    String? id,
    String? workoutPlanId,
    String? name,
    int? dayOrder,
    String? notes,
    bool? isEnabled,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      workoutPlanId: workoutPlanId ?? this.workoutPlanId,
      name: name ?? this.name,
      dayOrder: dayOrder ?? this.dayOrder,
      notes: notes ?? this.notes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkoutDay &&
            id == other.id &&
            workoutPlanId == other.workoutPlanId &&
            name == other.name &&
            dayOrder == other.dayOrder &&
            notes == other.notes &&
            isEnabled == other.isEnabled;
  }

  @override
  int get hashCode => Object.hash(
        id,
        workoutPlanId,
        name,
        dayOrder,
        notes,
        isEnabled,
      );

  @override
  String toString() {
    return 'WorkoutDay('
        'id: $id, '
        'workoutPlanId: $workoutPlanId, '
        'name: $name, '
        'dayOrder: $dayOrder'
        ')';
  }
}