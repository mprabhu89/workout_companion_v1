import 'package:flutter/foundation.dart';

/// Development-only placeholder for the future workout.exportDebugJson grant.
abstract interface class WorkoutExportPermission {
  bool get canExportWorkoutJson;
}

class DevelopmentWorkoutExportPermission implements WorkoutExportPermission {
  const DevelopmentWorkoutExportPermission();

  @override
  bool get canExportWorkoutJson => kDebugMode;
}
