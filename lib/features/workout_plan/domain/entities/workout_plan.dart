import '../enums/workout_plan_category.dart';
import '../enums/workout_plan_difficulty.dart';

class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedDurationInMinutes,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final String description;
  final WorkoutPlanCategory category;
  final WorkoutPlanDifficulty difficulty;
  final int estimatedDurationInMinutes;
  final bool isArchived;

  WorkoutPlan copyWith({
    String? id,
    String? name,
    String? description,
    WorkoutPlanCategory? category,
    WorkoutPlanDifficulty? difficulty,
    int? estimatedDurationInMinutes,
    bool? isArchived,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      estimatedDurationInMinutes:
          estimatedDurationInMinutes ?? this.estimatedDurationInMinutes,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlan &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          category == other.category &&
          difficulty == other.difficulty &&
          estimatedDurationInMinutes ==
              other.estimatedDurationInMinutes &&
          isArchived == other.isArchived;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        category,
        difficulty,
        estimatedDurationInMinutes,
        isArchived,
      );

  @override
  String toString() {
    return 'WorkoutPlan('
        'id: $id, '
        'name: $name, '
        'category: ${category.displayName}, '
        'difficulty: ${difficulty.displayName}, '
        'estimatedDurationInMinutes: $estimatedDurationInMinutes'
        ')';
  }
}