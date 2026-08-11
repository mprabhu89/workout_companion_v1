import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../domain/entities/completed_workout_session.dart';
import '../../domain/repositories/workout_history_repository.dart';
import '../../domain/services/workout_statistics_service.dart';

class WorkoutHistoryController extends ChangeNotifier {
  factory WorkoutHistoryController.create({
    required WorkoutHistoryRepository repository,
    required WorkoutStatisticsService statisticsService,
  }) {
    return WorkoutHistoryController(
      repository: repository,
      statisticsService: statisticsService,
    );
  }

  WorkoutHistoryController({
    required WorkoutHistoryRepository repository,
    required WorkoutStatisticsService statisticsService,
  }) : this._internal(repository, statisticsService);

  WorkoutHistoryController._internal(this._repository, this._statisticsService);

  final WorkoutHistoryRepository _repository;
  final WorkoutStatisticsService _statisticsService;

  final List<CompletedWorkoutSession> _sessions = [];

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  UnmodifiableListView<CompletedWorkoutSession> get sessions =>
      UnmodifiableListView(_sessions);

  Future<void> loadSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sessions
        ..clear()
        ..addAll(await _repository.getCompletedSessions());
    } catch (error) {
      _errorMessage = 'Unable to load workout history: $error';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveSession(CompletedWorkoutSession session) async {
    await _repository.saveSession(session);
    await loadSessions();
  }

  Future<void> deleteSession(String sessionId) async {
    await _repository.deleteSession(sessionId);
    await loadSessions();
  }

  int get totalWorkouts => _statisticsService.totalWorkouts(_sessions);

  int get totalDurationInSeconds =>
      _statisticsService.totalDurationInSeconds(_sessions);

  double get averageWorkoutDuration =>
      _statisticsService.averageWorkoutDuration(_sessions);

  int get completedWorkouts => _statisticsService.completedWorkouts(_sessions);

  double get completionRate => _statisticsService.completionRate(_sessions);
}
