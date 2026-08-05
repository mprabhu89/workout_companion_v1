class WorkoutGroup {
  const WorkoutGroup({
    required this.id,
    required this.workoutDayId,
    required this.name,
    required this.displayOrder,
    this.isArchived = false,
  });

  final String id;
  final String workoutDayId;
  final String name;
  final int displayOrder;
  final bool isArchived;

  WorkoutGroup copyWith({
    String? id,
    String? workoutDayId,
    String? name,
    int? displayOrder,
    bool? isArchived,
  }) {
    return WorkoutGroup(
      id: id ?? this.id,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutGroup &&
          id == other.id &&
          workoutDayId == other.workoutDayId &&
          name == other.name &&
          displayOrder == other.displayOrder &&
          isArchived == other.isArchived;

  @override
  int get hashCode => Object.hash(
        id,
        workoutDayId,
        name,
        displayOrder,
        isArchived,
      );

  @override
  String toString() {
    return 'WorkoutGroup('
        'id: $id, '
        'name: $name, '
        'displayOrder: $displayOrder'
        ')';
  }
}