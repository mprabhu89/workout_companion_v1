class WorkoutGroupWorkoutReference {
  const WorkoutGroupWorkoutReference({
    required this.id,
    required this.workoutGroupId,
    required this.workoutExerciseId,
    required this.displayOrder,
    this.isArchived = false,
  });

  final String id;
  final String workoutGroupId;
  final String workoutExerciseId;
  final int displayOrder;
  final bool isArchived;

  WorkoutGroupWorkoutReference copyWith({
    String? id,
    String? workoutGroupId,
    String? workoutExerciseId,
    int? displayOrder,
    bool? isArchived,
  }) {
    return WorkoutGroupWorkoutReference(
      id: id ?? this.id,
      workoutGroupId: workoutGroupId ?? this.workoutGroupId,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      displayOrder: displayOrder ?? this.displayOrder,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
