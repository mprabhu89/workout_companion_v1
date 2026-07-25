import 'package:flutter/foundation.dart';

@immutable
class WorkoutGroup {
  const WorkoutGroup({
    required this.id,
    required this.workoutDayId,
    required this.name,
    required this.groupOrder,
    this.notes = '',
    this.isEnabled = true,
  });

  final String id;
  final String workoutDayId;
  final String name;
  final int groupOrder;
  final String notes;
  final bool isEnabled;

  WorkoutGroup copyWith({
    String? id,
    String? workoutDayId,
    String? name,
    int? groupOrder,
    String? notes,
    bool? isEnabled,
  }) {
    return WorkoutGroup(
      id: id ?? this.id,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      name: name ?? this.name,
      groupOrder: groupOrder ?? this.groupOrder,
      notes: notes ?? this.notes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          workoutDayId == other.workoutDayId &&
          name == other.name &&
          groupOrder == other.groupOrder &&
          notes == other.notes &&
          isEnabled == other.isEnabled;

  @override
  int get hashCode => Object.hash(
        id,
        workoutDayId,
        name,
        groupOrder,
        notes,
        isEnabled,
      );

  @override
  String toString() {
    return 'WorkoutGroup('
        'id: $id, '
        'workoutDayId: $workoutDayId, '
        'name: $name, '
        'groupOrder: $groupOrder, '
        'notes: $notes, '
        'isEnabled: $isEnabled'
        ')';
  }
}