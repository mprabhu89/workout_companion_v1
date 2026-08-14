import '../../features/exercise/domain/entities/exercise.dart';
import '../../features/exercise/domain/enums/difficulty_level.dart';
import '../../features/exercise/domain/enums/equipment_type.dart';
import '../../features/exercise/domain/enums/muscle_group.dart';
import '../../features/workout_day/domain/entities/workout_day.dart';
import '../../features/workout_exercise/domain/entities/tempo_type.dart';
import '../../features/workout_exercise/domain/entities/weight_unit.dart';
import '../../features/workout_exercise/domain/entities/workout_exercise.dart';
import '../../features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import '../../features/workout_exercise/domain/entities/workout_sequence_step.dart';
import '../../features/workout_exercise/domain/entities/workout_target_type.dart';
import '../../features/workout_group/domain/entities/workout_group.dart';
import '../../features/workout_history/domain/entities/completed_workout_session.dart';
import '../../features/workout_plan/domain/entities/workout_plan.dart';
import '../../features/workout_plan/domain/enums/workout_plan_category.dart';
import '../../features/workout_plan/domain/enums/workout_plan_difficulty.dart';
import 'isar_models.dart';

IsarExerciseRecord mapExerciseToRecord(
  Exercise exercise,
) {
  return IsarExerciseRecord()
    ..id = exercise.id
    ..name = exercise.name
    ..description = exercise.description
    ..instructions = exercise.instructions
    ..muscleGroupName = exercise.muscleGroup.name
    ..equipmentName = exercise.equipment.name
    ..difficultyName = exercise.difficulty.name
    ..isCustom = exercise.isCustom
    ..isArchived = exercise.isArchived;
}

Exercise mapExerciseFromRecord(
  IsarExerciseRecord record,
) {
  return Exercise(
    id: record.id,
    name: record.name,
    description: record.description,
    instructions: record.instructions,
    muscleGroup: _enumByName(
      MuscleGroup.values,
      record.muscleGroupName,
      'muscleGroupName',
    ),
    equipment: _enumByName(
      EquipmentType.values,
      record.equipmentName,
      'equipmentName',
    ),
    difficulty: _enumByName(
      DifficultyLevel.values,
      record.difficultyName,
      'difficultyName',
    ),
    isCustom: record.isCustom,
    isArchived: record.isArchived,
  );
}

IsarWorkoutPlanRecord mapWorkoutPlanToRecord(
  WorkoutPlan workoutPlan,
) {
  return IsarWorkoutPlanRecord()
    ..id = workoutPlan.id
    ..name = workoutPlan.name
    ..description = workoutPlan.description
    ..categoryName = workoutPlan.category.name
    ..difficultyName = workoutPlan.difficulty.name
    ..estimatedDurationInMinutes =
        workoutPlan.estimatedDurationInMinutes
    ..isArchived = workoutPlan.isArchived;
}

WorkoutPlan mapWorkoutPlanFromRecord(
  IsarWorkoutPlanRecord record,
) {
  return WorkoutPlan(
    id: record.id,
    name: record.name,
    description: record.description,
    category: _enumByName(
      WorkoutPlanCategory.values,
      record.categoryName,
      'categoryName',
    ),
    difficulty: _enumByName(
      WorkoutPlanDifficulty.values,
      record.difficultyName,
      'difficultyName',
    ),
    estimatedDurationInMinutes:
        record.estimatedDurationInMinutes,
    isArchived: record.isArchived,
  );
}

IsarWorkoutDayRecord mapWorkoutDayToRecord(
  WorkoutDay workoutDay,
) {
  return IsarWorkoutDayRecord()
    ..id = workoutDay.id
    ..workoutPlanId = workoutDay.workoutPlanId
    ..dayNumber = workoutDay.dayNumber
    ..name = workoutDay.name
    ..description = workoutDay.description
    ..isRestDay = workoutDay.isRestDay
    ..isArchived = workoutDay.isArchived;
}

WorkoutDay mapWorkoutDayFromRecord(
  IsarWorkoutDayRecord record,
) {
  return WorkoutDay(
    id: record.id,
    workoutPlanId: record.workoutPlanId,
    dayNumber: record.dayNumber,
    name: record.name,
    description: record.description,
    isRestDay: record.isRestDay,
    isArchived: record.isArchived,
  );
}

IsarWorkoutGroupRecord mapWorkoutGroupToRecord(
  WorkoutGroup workoutGroup,
) {
  return IsarWorkoutGroupRecord()
    ..id = workoutGroup.id
    ..workoutDayId = workoutGroup.workoutDayId
    ..name = workoutGroup.name
    ..displayOrder = workoutGroup.displayOrder
    ..isArchived = workoutGroup.isArchived;
}

WorkoutGroup mapWorkoutGroupFromRecord(
  IsarWorkoutGroupRecord record,
) {
  return WorkoutGroup(
    id: record.id,
    workoutDayId: record.workoutDayId,
    name: record.name,
    displayOrder: record.displayOrder,
    isArchived: record.isArchived,
  );
}

IsarWorkoutExerciseRecord mapWorkoutExerciseToRecord(
  WorkoutExercise workoutExercise,
) {
  return IsarWorkoutExerciseRecord()
    ..id = workoutExercise.id
    ..workoutGroupId = workoutExercise.workoutGroupId
    ..exerciseId = workoutExercise.exerciseId
    ..displayOrder = workoutExercise.displayOrder
    ..sets = workoutExercise.sets
    ..targetTypeName = workoutExercise.targetType.name
    ..repetitions = workoutExercise.repetitions
    ..durationInSeconds =
        workoutExercise.durationInSeconds
    ..restInSeconds = workoutExercise.restInSeconds
    ..sessionRepetitions =
        workoutExercise.sessionRepetitions
    ..weight = workoutExercise.weight
    ..weightUnitName = workoutExercise.weightUnit.name
    ..rpe = workoutExercise.rpe
    ..tempoTypeName = workoutExercise.tempoType.name
    ..customTempo = workoutExercise.customTempo
    ..notes = workoutExercise.notes
    ..sequenceDefinition = mapSequenceDefinitionToRecord(
      workoutExercise.sequenceDefinition,
    )
    ..isArchived = workoutExercise.isArchived;
}

WorkoutExercise mapWorkoutExerciseFromRecord(
  IsarWorkoutExerciseRecord record,
) {
  return WorkoutExercise(
    id: record.id,
    workoutGroupId: record.workoutGroupId,
    exerciseId: record.exerciseId,
    displayOrder: record.displayOrder,
    sets: record.sets,
    targetType: _enumByName(
      WorkoutTargetType.values,
      record.targetTypeName,
      'targetTypeName',
    ),
    repetitions: record.repetitions,
    durationInSeconds: record.durationInSeconds,
    restInSeconds: record.restInSeconds,
    sessionRepetitions: record.sessionRepetitions,
    weight: record.weight,
    weightUnit: _enumByName(
      WeightUnit.values,
      record.weightUnitName,
      'weightUnitName',
    ),
    rpe: record.rpe,
    tempoType: _enumByName(
      TempoType.values,
      record.tempoTypeName,
      'tempoTypeName',
    ),
    customTempo: record.customTempo,
    notes: record.notes,
    sequenceDefinition: mapSequenceDefinitionFromRecord(
      record.sequenceDefinition,
    ),
    isArchived: record.isArchived,
  );
}

IsarCompletedWorkoutSessionRecord
mapCompletedWorkoutSessionToRecord(
  CompletedWorkoutSession session,
) {
  return IsarCompletedWorkoutSessionRecord()
    ..id = session.id
    ..workoutPlanId = session.workoutPlanId
    ..workoutPlanName = session.workoutPlanName
    ..startedAt = session.startedAt.toUtc()
    ..completedAt = session.completedAt.toUtc()
    ..durationInSeconds = session.durationInSeconds
    ..completedExercises = session.completedExercises
    ..totalExercises = session.totalExercises
    ..wasCompleted = session.wasCompleted
    ..workoutDayId = session.workoutDayId
    ..workoutDayName = session.workoutDayName
    ..notes = session.notes;
}

CompletedWorkoutSession
mapCompletedWorkoutSessionFromRecord(
  IsarCompletedWorkoutSessionRecord record,
) {
  return CompletedWorkoutSession(
    id: record.id,
    workoutPlanId: record.workoutPlanId,
    workoutPlanName: record.workoutPlanName,
    startedAt: DateTime.fromMillisecondsSinceEpoch(
      record.startedAt.millisecondsSinceEpoch,
      isUtc: true,
    ),
    completedAt: DateTime.fromMillisecondsSinceEpoch(
      record.completedAt.millisecondsSinceEpoch,
      isUtc: true,
    ),
    durationInSeconds: record.durationInSeconds,
    completedExercises: record.completedExercises,
    totalExercises: record.totalExercises,
    wasCompleted: record.wasCompleted,
    workoutDayId: record.workoutDayId,
    workoutDayName: record.workoutDayName,
    notes: record.notes,
  );
}

IsarWorkoutSequenceDefinitionRecord?
mapSequenceDefinitionToRecord(
  WorkoutSequenceDefinition? definition,
) {
  if (definition == null) {
    return null;
  }

  return IsarWorkoutSequenceDefinitionRecord()
    ..steps = definition.steps
        .map(mapSequenceStepToRecord)
        .toList();
}

WorkoutSequenceDefinition?
mapSequenceDefinitionFromRecord(
  IsarWorkoutSequenceDefinitionRecord? record,
) {
  if (record == null) {
    return null;
  }

  return WorkoutSequenceDefinition(
    steps: record.steps
        .map(mapSequenceStepFromRecord)
        .toList(),
  );
}

IsarWorkoutSequenceStepRecord mapSequenceStepToRecord(
  WorkoutSequenceStep step,
) {
  return IsarWorkoutSequenceStepRecord()
    ..typeName = step.type.name
    ..text = step.text
    ..count = step.count
    ..repetitionCount = step.repetitionCount
    ..countDirectionName = step.countDirection?.name
    ..durationInSeconds = step.durationInSeconds;
}

WorkoutSequenceStep mapSequenceStepFromRecord(
  IsarWorkoutSequenceStepRecord record,
) {
  final type = _enumByName(
    WorkoutSequenceStepType.values,
    record.typeName,
    'typeName',
  );

  switch (type) {
    case WorkoutSequenceStepType.guide:
      return WorkoutSequenceStep.guide(
        text: _requiredValue(
          record.text,
          'text',
        ),
      );
    case WorkoutSequenceStepType.count:
      return WorkoutSequenceStep.count(
        count: _requiredValue(
          record.count,
          'count',
        ),
        direction: _enumByName(
          WorkoutCountDirection.values,
          _requiredValue(
            record.countDirectionName,
            'countDirectionName',
          ),
          'countDirectionName',
        ),
      );
    case WorkoutSequenceStepType.counter:
      return WorkoutSequenceStep.counter(
        repetitionCount: _requiredValue(
          record.repetitionCount,
          'repetitionCount',
        ),
      );
    case WorkoutSequenceStepType.relax:
      return WorkoutSequenceStep.relax(
        durationInSeconds: _requiredValue(
          record.durationInSeconds,
          'durationInSeconds',
        ),
      );
    case WorkoutSequenceStepType.sequenceBreak:
      return WorkoutSequenceStep.sequenceBreak();
    case WorkoutSequenceStepType.end:
      return WorkoutSequenceStep.end();
  }
}

T _enumByName<T extends Enum>(
  List<T> values,
  String name,
  String fieldName,
) {
  try {
    return values.byName(name);
  } on ArgumentError {
    throw FormatException(
      'Unsupported enum value "$name" for $fieldName.',
    );
  }
}

T _requiredValue<T>(
  T? value,
  String fieldName,
) {
  if (value == null) {
    throw FormatException(
      'Missing required value for $fieldName.',
    );
  }

  return value;
}
