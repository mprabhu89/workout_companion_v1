import '../enums/difficulty_level.dart';
import '../enums/equipment_type.dart';
import '../enums/muscle_group.dart';

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    this.isCustom = false,
    this.isArchived = false,
  });

  /// Unique identifier
  final String id;

  /// Display name
  final String name;

  /// Short description shown in lists
  final String description;

  /// Step-by-step execution instructions
  final String instructions;

  /// Primary muscle group
  final MuscleGroup muscleGroup;

  /// Equipment required
  final EquipmentType equipment;

  /// Exercise difficulty
  final DifficultyLevel difficulty;

  /// True when created by the user.
  final bool isCustom;

  /// Soft delete support.
  final bool isArchived;

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? instructions,
    MuscleGroup? muscleGroup,
    EquipmentType? equipment,
    DifficultyLevel? difficulty,
    bool? isCustom,
    bool? isArchived,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      isCustom: isCustom ?? this.isCustom,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Exercise &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            instructions == other.instructions &&
            muscleGroup == other.muscleGroup &&
            equipment == other.equipment &&
            difficulty == other.difficulty &&
            isCustom == other.isCustom &&
            isArchived == other.isArchived;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        instructions,
        muscleGroup,
        equipment,
        difficulty,
        isCustom,
        isArchived,
      );

  @override
  String toString() {
    return 'Exercise('
        'id: $id, '
        'name: $name, '
        'muscleGroup: ${muscleGroup.displayName}, '
        'equipment: ${equipment.displayName}, '
        'difficulty: ${difficulty.displayName}'
        ')';
  }
}