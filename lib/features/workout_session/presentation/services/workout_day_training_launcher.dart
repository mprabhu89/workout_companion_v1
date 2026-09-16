import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../workout_day/domain/entities/workout_day.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
import '../../../workout_group_workout_reference/domain/repositories/workout_group_workout_reference_repository.dart';
import '../../../workout_plan/domain/enums/workout_plan_category.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/services/workout_session_builder.dart';
import '../screens/workout_execution_screen.dart';

/// Starts a selected day through the single existing session builder path.
///
/// This keeps training launch independent from authoring presentation screens.
class WorkoutDayTrainingLauncher {
  WorkoutDayTrainingLauncher({
    WorkoutSessionBuilder? sessionBuilder,
    WorkoutGroupRepository? workoutGroupRepository,
    WorkoutExerciseRepository? workoutExerciseRepository,
    WorkoutGroupWorkoutReferenceRepository? referenceRepository,
    this.executionScreenBuilder,
  }) : _sessionBuilder =
           sessionBuilder ??
           WorkoutSessionBuilder(
             workoutGroupRepository:
                 workoutGroupRepository ??
                 RepositoryRegistry.workoutGroupRepository,
             workoutExerciseRepository:
                 workoutExerciseRepository ??
                 RepositoryRegistry.workoutExerciseRepository,
             referenceRepository:
                 referenceRepository ??
                 RepositoryRegistry.workoutGroupWorkoutReferenceRepository,
           );

  final WorkoutSessionBuilder _sessionBuilder;
  final Widget Function(WorkoutSession session)? executionScreenBuilder;

  Future<WorkoutSession> buildSession({
    required String workoutPlanId,
    required String workoutPlanName,
    required WorkoutDay workoutDay,
    WorkoutPlanCategory? workoutPlanCategory,
  }) {
    return _sessionBuilder.build(
      workoutDayId: workoutDay.id,
      workoutPlanId: workoutPlanId,
      workoutPlanName: workoutPlanName,
      workoutPlanCategory: workoutPlanCategory,
      workoutDayName: workoutDay.name,
    );
  }

  Future<bool> launch({
    required BuildContext context,
    required String workoutPlanId,
    required String workoutPlanName,
    required WorkoutDay workoutDay,
    WorkoutPlanCategory? workoutPlanCategory,
  }) async {
    if (workoutDay.isRestDay) {
      return false;
    }
    final session = await buildSession(
      workoutPlanId: workoutPlanId,
      workoutPlanName: workoutPlanName,
      workoutPlanCategory: workoutPlanCategory,
      workoutDay: workoutDay,
    );
    if (!context.mounted || session.workoutExercises.isEmpty) {
      return false;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            executionScreenBuilder?.call(session) ??
            WorkoutExecutionScreen(session: session),
      ),
    );
    return true;
  }
}
