class WorkoutDay {
  const WorkoutDay({
    required this.id,
    required this.workoutPlanId,
    required this.dayNumber,
    required this.name,
    required this.description,
    this.isRestDay = false,
    this.isArchived = false,
  });

  final String id;
  final String workoutPlanId;
  final int dayNumber;
  final String name;
  final String description;
  final bool isRestDay;
  final bool isArchived;

  WorkoutDay copyWith({
    String? id,
    String? workoutPlanId,
    int? dayNumber,
    String? name,
    String? description,
    bool? isRestDay,
    bool? isArchived,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      workoutPlanId: workoutPlanId ?? this.workoutPlanId,
      dayNumber: dayNumber ?? this.dayNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      isRestDay: isRestDay ?? this.isRestDay,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutDay &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          workoutPlanId == other.workoutPlanId &&
          dayNumber == other.dayNumber &&
          name == other.name &&
          description == other.description &&
          isRestDay == other.isRestDay &&
          isArchived == other.isArchived;

  @override
  int get hashCode => Object.hash(
        id,
        workoutPlanId,
        dayNumber,
        name,
        description,
        isRestDay,
        isArchived,
      );

  @override
  String toString() {
    return 'WorkoutDay('
        'id: $id, '
        'workoutPlanId: $workoutPlanId, '
        'dayNumber: $dayNumber, '
        'name: $name'
        ')';
  }
}