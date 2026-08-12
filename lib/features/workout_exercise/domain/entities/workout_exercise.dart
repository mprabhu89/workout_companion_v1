import 'tempo_type.dart';
import 'weight_unit.dart';
import 'workout_sequence_definition.dart';
import 'workout_target_type.dart';

class WorkoutExercise {
  const WorkoutExercise({
    required this.id,
    required this.workoutGroupId,
    required this.exerciseId,
    required this.displayOrder,

    // Prescription
    this.sets,
    required this.targetType,
    this.repetitions,
    this.durationInSeconds,

    // Rest
    this.restInSeconds,

    // Intensity
    this.weight,
    this.weightUnit = WeightUnit.kilograms,
    this.rpe,

    // Tempo
    this.tempoType = TempoType.normal,
    this.customTempo,

    // Notes
    this.notes = '',
    this.sequenceDefinition,

    // Soft delete
    this.isArchived = false,
  });

  final String id;
  final String workoutGroupId;
  final String exerciseId;

  final int displayOrder;

  /// Number of sets.
  final int? sets;

  /// Determines how the exercise target is measured.
  final WorkoutTargetType targetType;

  /// Used when targetType == repetitions.
  final int? repetitions;

  /// Used when targetType == duration.
  final int? durationInSeconds;

  /// Rest after completing this exercise.
  final int? restInSeconds;

  /// Optional working weight.
  final double? weight;

  final WeightUnit weightUnit;

  /// Rate of perceived exertion (1–10).
  final int? rpe;

  final TempoType tempoType;

  /// Used when tempoType == custom.
  final String? customTempo;

  final String notes;

  final WorkoutSequenceDefinition? sequenceDefinition;

  final bool isArchived;

  WorkoutExercise copyWith({
    String? id,
    String? workoutGroupId,
    String? exerciseId,
    int? displayOrder,
    int? sets,
    WorkoutTargetType? targetType,
    int? repetitions,
    int? durationInSeconds,
    int? restInSeconds,
    double? weight,
    WeightUnit? weightUnit,
    int? rpe,
    TempoType? tempoType,
    String? customTempo,
    String? notes,
    WorkoutSequenceDefinition? sequenceDefinition,
    bool? isArchived,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      workoutGroupId: workoutGroupId ?? this.workoutGroupId,
      exerciseId: exerciseId ?? this.exerciseId,
      displayOrder: displayOrder ?? this.displayOrder,
      sets: sets ?? this.sets,
      targetType: targetType ?? this.targetType,
      repetitions: repetitions ?? this.repetitions,
      durationInSeconds:
          durationInSeconds ?? this.durationInSeconds,
      restInSeconds: restInSeconds ?? this.restInSeconds,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      rpe: rpe ?? this.rpe,
      tempoType: tempoType ?? this.tempoType,
      customTempo: customTempo ?? this.customTempo,
      notes: notes ?? this.notes,
      sequenceDefinition:
          sequenceDefinition ?? this.sequenceDefinition,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExercise &&
          id == other.id &&
          workoutGroupId == other.workoutGroupId &&
          exerciseId == other.exerciseId &&
          displayOrder == other.displayOrder &&
          sets == other.sets &&
          targetType == other.targetType &&
          repetitions == other.repetitions &&
          durationInSeconds == other.durationInSeconds &&
          restInSeconds == other.restInSeconds &&
          weight == other.weight &&
          weightUnit == other.weightUnit &&
          rpe == other.rpe &&
          tempoType == other.tempoType &&
          customTempo == other.customTempo &&
          notes == other.notes &&
          sequenceDefinition == other.sequenceDefinition &&
          isArchived == other.isArchived;

  @override
  int get hashCode => Object.hash(
        id,
        workoutGroupId,
        exerciseId,
        displayOrder,
        sets,
        targetType,
        repetitions,
        durationInSeconds,
        restInSeconds,
        weight,
        weightUnit,
        rpe,
        tempoType,
        customTempo,
        notes,
        sequenceDefinition,
        isArchived,
      );

  @override
  String toString() {
    return 'WorkoutExercise('
        'id: $id, '
        'exerciseId: $exerciseId, '
        'displayOrder: $displayOrder'
        ')';
  }
}
