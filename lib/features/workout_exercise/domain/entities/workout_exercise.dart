import 'package:flutter/foundation.dart';

import 'tempo_type.dart';
import 'weight_unit.dart';
import 'workout_target_type.dart';

@immutable
class WorkoutExercise {
  const WorkoutExercise({
    required this.id,
    required this.workoutGroupId,
    required this.exerciseId,
    required this.displayOrder,

    this.sets = 3,

    this.targetType = WorkoutTargetType.repetitions,
    this.repetitions,
    this.durationSeconds,
    this.distanceMeters,
    this.calories,
    this.customTarget,

    this.restSeconds = 60,

    this.tempoType = TempoType.normal,
    this.customTempo,

    this.rpe,

    this.weight,
    this.weightUnit = WeightUnit.kilograms,

    this.notes = '',
    this.isEnabled = true,
  });

  final String id;

  /// Parent Workout Group
  final String workoutGroupId;

  /// Reference to Exercise Library
  final String exerciseId;

  /// Display order within the Workout Group
  final int displayOrder;

  /// Number of sets
  final int sets;

  /// Target configuration
  final WorkoutTargetType targetType;

  final int? repetitions;
  final int? durationSeconds;
  final double? distanceMeters;
  final int? calories;
  final String? customTarget;

  /// Rest after each set
  final int restSeconds;

  /// Tempo
  final TempoType tempoType;
  final String? customTempo;

  /// Rate of Perceived Exertion (1–10)
  final int? rpe;

  /// Suggested working weight
  final double? weight;
  final WeightUnit weightUnit;

  /// Trainer notes
  final String notes;

  final bool isEnabled;

  WorkoutExercise copyWith({
    String? id,
    String? workoutGroupId,
    String? exerciseId,
    int? displayOrder,
    int? sets,
    WorkoutTargetType? targetType,
    int? repetitions,
    int? durationSeconds,
    double? distanceMeters,
    int? calories,
    String? customTarget,
    int? restSeconds,
    TempoType? tempoType,
    String? customTempo,
    int? rpe,
    double? weight,
    WeightUnit? weightUnit,
    String? notes,
    bool? isEnabled,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      workoutGroupId: workoutGroupId ?? this.workoutGroupId,
      exerciseId: exerciseId ?? this.exerciseId,
      displayOrder: displayOrder ?? this.displayOrder,
      sets: sets ?? this.sets,
      targetType: targetType ?? this.targetType,
      repetitions: repetitions ?? this.repetitions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      calories: calories ?? this.calories,
      customTarget: customTarget ?? this.customTarget,
      restSeconds: restSeconds ?? this.restSeconds,
      tempoType: tempoType ?? this.tempoType,
      customTempo: customTempo ?? this.customTempo,
      rpe: rpe ?? this.rpe,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      notes: notes ?? this.notes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExercise &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          workoutGroupId == other.workoutGroupId &&
          exerciseId == other.exerciseId &&
          displayOrder == other.displayOrder &&
          sets == other.sets &&
          targetType == other.targetType &&
          repetitions == other.repetitions &&
          durationSeconds == other.durationSeconds &&
          distanceMeters == other.distanceMeters &&
          calories == other.calories &&
          customTarget == other.customTarget &&
          restSeconds == other.restSeconds &&
          tempoType == other.tempoType &&
          customTempo == other.customTempo &&
          rpe == other.rpe &&
          weight == other.weight &&
          weightUnit == other.weightUnit &&
          notes == other.notes &&
          isEnabled == other.isEnabled;

  @override
  int get hashCode => Object.hash(
        id,
        workoutGroupId,
        exerciseId,
        displayOrder,
        sets,
        targetType,
        repetitions,
        durationSeconds,
        distanceMeters,
        calories,
        customTarget,
        restSeconds,
        tempoType,
        customTempo,
        rpe,
        weight,
        weightUnit,
        notes,
        isEnabled,
      );

  @override
  String toString() {
    return 'WorkoutExercise('
        'id: $id, '
        'exerciseId: $exerciseId, '
        'targetType: $targetType, '
        'sets: $sets, '
        'displayOrder: $displayOrder'
        ')';
  }
}