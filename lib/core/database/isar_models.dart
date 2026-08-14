import 'package:isar_community/isar.dart';

part 'isar_models.g.dart';

@collection
class IsarExerciseRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String name;
  late String description;
  late String instructions;
  late String muscleGroupName;
  late String equipmentName;
  late String difficultyName;
  bool isCustom = false;
  bool isArchived = false;
}

@collection
class IsarWorkoutPlanRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String name;
  late String description;
  late String categoryName;
  late String difficultyName;
  late int estimatedDurationInMinutes;
  bool isArchived = false;
}

@collection
class IsarWorkoutDayRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String workoutPlanId;

  late int dayNumber;
  late String name;
  late String description;
  bool isRestDay = false;
  bool isArchived = false;
}

@collection
class IsarWorkoutGroupRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String workoutDayId;

  late String name;
  late int displayOrder;
  bool isArchived = false;
}

@embedded
class IsarWorkoutSequenceStepRecord {
  late String typeName;
  String? text;
  int? count;
  int? repetitionCount;
  String? countDirectionName;
  int? durationInSeconds;
}

@embedded
class IsarWorkoutSequenceDefinitionRecord {
  List<IsarWorkoutSequenceStepRecord> steps = [];
}

@collection
class IsarWorkoutExerciseRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String workoutGroupId;

  late String exerciseId;
  late int displayOrder;
  int? sets;
  late String targetTypeName;
  int? repetitions;
  int? durationInSeconds;
  int? restInSeconds;
  int sessionRepetitions = 1;
  double? weight;
  late String weightUnitName;
  int? rpe;
  late String tempoTypeName;
  String? customTempo;
  String notes = '';
  IsarWorkoutSequenceDefinitionRecord?
      sequenceDefinition;
  bool isArchived = false;
}

@collection
class IsarCompletedWorkoutSessionRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String workoutPlanId;
  late String workoutPlanName;
  late DateTime startedAt;
  late DateTime completedAt;
  late int durationInSeconds;
  late int completedExercises;
  late int totalExercises;
  late bool wasCompleted;
  String? workoutDayId;
  String? workoutDayName;
  String notes = '';
}
