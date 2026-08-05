import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../workout_group/presentation/screens/workout_group_library_screen.dart';
import '../../domain/entities/workout_day.dart';
import '../controllers/workout_day_library_controller.dart';
import 'create_workout_day_screen.dart';

class WorkoutDayLibraryScreen extends StatefulWidget {
  const WorkoutDayLibraryScreen({
    super.key,
    required this.workoutPlanId,
    required this.workoutPlanName,
  });

  final String workoutPlanId;
  final String workoutPlanName;

  @override
  State<WorkoutDayLibraryScreen> createState() =>
      _WorkoutDayLibraryScreenState();
}

class _WorkoutDayLibraryScreenState
    extends State<WorkoutDayLibraryScreen> {
  late final WorkoutDayLibraryController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WorkoutDayLibraryController(
      repository: RepositoryRegistry.workoutDayRepository,
      workoutPlanId: widget.workoutPlanId,
    );

    _controller.addListener(_refresh);
    _controller.loadWorkoutDays();
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _createWorkoutDay() async {
    final workoutDay = await Navigator.of(context).push<WorkoutDay>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutDayScreen(
          workoutPlanId: widget.workoutPlanId,
          existingNames: _controller.workoutDays
              .map((e) => e.name)
              .toList(),
        ),
      ),
    );

    if (workoutDay != null) {
      await _controller.saveWorkoutDay(workoutDay);
    }
  }

  Future<void> _editWorkoutDay(WorkoutDay workoutDay) async {
    final updated = await Navigator.of(context).push<WorkoutDay>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutDayScreen(
          workoutPlanId: widget.workoutPlanId,
          workoutDay: workoutDay,
          existingNames: _controller.workoutDays
              .map((e) => e.name)
              .toList(),
        ),
      ),
    );

    if (updated != null) {
      await _controller.saveWorkoutDay(updated);
    }
  }

  Future<void> _deleteWorkoutDay(
    WorkoutDay workoutDay,
  ) async {
    await _controller.deleteWorkoutDay(workoutDay.id);
  }

  Future<void> _openWorkoutGroups(
    WorkoutDay workoutDay,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutGroupLibraryScreen(
          workoutDayId: workoutDay.id,
          workoutDayName: workoutDay.name,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutPlanName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkoutDay,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_controller.isEmpty) {
      return const Center(
        child: Text(
          'No workout days yet.\nTap + to create your first workout day.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _controller.workoutDays.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final workoutDay = _controller.workoutDays[index];

        return Card(
          child: ListTile(
            onTap: () => _openWorkoutGroups(workoutDay),
            title: Text(workoutDay.name),
            subtitle: Text(
              workoutDay.isRestDay
                  ? 'Day ${workoutDay.dayNumber} • Rest Day'
                  : 'Day ${workoutDay.dayNumber}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                  onPressed: () => _editWorkoutDay(workoutDay),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: () => _deleteWorkoutDay(workoutDay),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}