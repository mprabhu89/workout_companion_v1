import 'package:flutter/foundation.dart';

import '../../domain/models/workout_progress.dart';
import '../../domain/services/workout_progress_service.dart';
import '../../../workout_day/domain/entities/workout_day.dart';
import '../../../workout_day/domain/repositories/workout_day_repository.dart';
import '../../../workout_history/domain/repositories/workout_history_repository.dart';
import '../../../workout_plan/domain/repositories/workout_plan_repository.dart';

class WorkoutProgressController extends ChangeNotifier {
  WorkoutProgressController({
    required WorkoutPlanRepository workoutPlanRepository,
    required WorkoutDayRepository workoutDayRepository,
    required WorkoutHistoryRepository workoutHistoryRepository,
    required WorkoutProgressService progressService,
  }) : this._internal(
         workoutPlanRepository,
         workoutDayRepository,
         workoutHistoryRepository,
         progressService,
       );

  WorkoutProgressController._internal(
    this._workoutPlanRepository,
    this._workoutDayRepository,
    this._workoutHistoryRepository,
    this._progressService,
  );

  final WorkoutPlanRepository _workoutPlanRepository;
  final WorkoutDayRepository _workoutDayRepository;
  final WorkoutHistoryRepository _workoutHistoryRepository;
  final WorkoutProgressService _progressService;

  WorkoutProgressSummary? _summary;
  bool _isLoading = false;
  String? _errorMessage;

  WorkoutProgressSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProgress() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final workoutPlans = await _workoutPlanRepository.getAllWorkoutPlans();
      final workoutSessions = await _workoutHistoryRepository
          .getCompletedSessions();
      final daysByPlanId = <String, List<WorkoutDay>>{};

      for (final plan in workoutPlans.where((plan) => !plan.isArchived)) {
        daysByPlanId[plan.id] = await _workoutDayRepository.getWorkoutDays(
          workoutPlanId: plan.id,
        );
      }

      _summary = _progressService.calculate(
        workoutPlans: workoutPlans,
        workoutDaysByPlanId: daysByPlanId,
        workoutSessions: workoutSessions,
      );
    } catch (error) {
      _errorMessage = 'Unable to load progress: $error';
    }

    _isLoading = false;
    notifyListeners();
  }
}
