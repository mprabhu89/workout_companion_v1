/// Represents a workout plan.
///
/// A workout plan is the root of the workout hierarchy.
///
/// Workout Plan
///   └── Workout Day
///         └── Exercise Group
///               └── Exercise
class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.name,
    this.description = '',
    this.difficulty = WorkoutDifficulty.beginner,
    this.estimatedDurationMinutes = 0,
    this.isEnabled = true,
  });

  final String id;

  final String name;

  final String description;

  final WorkoutDifficulty difficulty;

  final int estimatedDurationMinutes;

  final bool isEnabled;

  WorkoutPlan copyWith({
    String? id,
    String? name,
    String? description,
    WorkoutDifficulty? difficulty,
    int? estimatedDurationMinutes,
    bool? isEnabled,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      estimatedDurationMinutes:
          estimatedDurationMinutes ??
              this.estimatedDurationMinutes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkoutPlan &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            difficulty == other.difficulty &&
            estimatedDurationMinutes ==
                other.estimatedDurationMinutes &&
            isEnabled == other.isEnabled;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        difficulty,
        estimatedDurationMinutes,
        isEnabled,
      );

  @override
  String toString() {
    return 'WorkoutPlan('
        'id: $id, '
        'name: $name, '
        'difficulty: $difficulty'
        ')';
  }
}

/// Supported workout difficulty levels.
enum WorkoutDifficulty {
  beginner,
  intermediate,
  advanced,
}