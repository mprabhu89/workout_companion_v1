import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'isar_models.dart';

final class IsarDatabase {
  IsarDatabase._(this.isar);

  static const String defaultName = 'workout_companion_v1';

  static IsarDatabase? _instance;

  final Isar isar;

  static Future<IsarDatabase> initialize() async {
    if (_instance != null) {
      return _instance!;
    }

    final directory =
        await getApplicationDocumentsDirectory();

    final isar = await Isar.open(
      _schemas,
      directory: directory.path,
      name: defaultName,
      inspector: false,
    );

    _instance = IsarDatabase._(isar);
    return _instance!;
  }

  static Future<IsarDatabase> instance() async {
    return _instance ?? initialize();
  }

  static Future<IsarDatabase> open({
    required String directoryPath,
    required String name,
  }) async {
    final isar = await Isar.open(
      _schemas,
      directory: directoryPath,
      name: name,
      inspector: false,
    );

    return IsarDatabase._(isar);
  }

  Future<void> close() async {
    await isar.close();
  }

  static Future<void> closeInstance() async {
    final database = _instance;
    _instance = null;
    await database?.close();
  }

  static const List<CollectionSchema<dynamic>> _schemas = [
    IsarExerciseRecordSchema,
    IsarWorkoutPlanRecordSchema,
    IsarWorkoutDayRecordSchema,
    IsarWorkoutGroupRecordSchema,
    IsarWorkoutExerciseRecordSchema,
    IsarCompletedWorkoutSessionRecordSchema,
  ];
}
