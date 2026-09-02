import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../workout_group/presentation/screens/workout_group_library_screen.dart';
import '../../../workout_plan/domain/enums/workout_plan_category.dart';
import '../../domain/entities/workout_day.dart';
import '../../domain/repositories/workout_day_repository.dart';
import '../controllers/workout_day_library_controller.dart';
import 'create_workout_day_screen.dart';
import 'workout_day_overview_screen.dart';

class WorkoutDayLibraryScreen extends StatefulWidget {
  const WorkoutDayLibraryScreen({
    super.key,
    required this.workoutPlanId,
    required this.workoutPlanName,
    this.workoutPlanDescription = '',
    this.workoutPlanCategory,
    this.repository,
    this.workoutDayOverviewScreenBuilder,
  });

  final String workoutPlanId;
  final String workoutPlanName;
  final String workoutPlanDescription;
  final WorkoutPlanCategory? workoutPlanCategory;
  final WorkoutDayRepository? repository;
  final Widget Function(WorkoutDay workoutDay)?
      workoutDayOverviewScreenBuilder;

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
      repository:
          widget.repository ??
          RepositoryRegistry.workoutDayRepository,
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

  Future<void> _openWorkoutDayOverview(
    WorkoutDay workoutDay,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            widget.workoutDayOverviewScreenBuilder
                ?.call(workoutDay) ??
            WorkoutDayOverviewScreen(
              workoutPlanId: widget.workoutPlanId,
              workoutPlanName: widget.workoutPlanName,
              workoutPlanCategory: widget.workoutPlanCategory,
              workoutDay: workoutDay,
            ),
      ),
    );
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

    final description =
        widget.workoutPlanDescription.trim();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount:
          _controller.workoutDays.length +
          (description.isEmpty ? 0 : 1),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (description.isNotEmpty && index == 0) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.workoutPlanName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
          );
        }

        final dayIndex =
            description.isEmpty ? index : index - 1;
        final workoutDay =
            _controller.workoutDays[dayIndex];

        final subtitleParts = <String>[
          'Day ${workoutDay.dayNumber}',
        ];

        if (workoutDay.isRestDay) {
          subtitleParts.add('Rest Day');
        }

        final dayDescription =
            workoutDay.description.trim();
        if (dayDescription.isNotEmpty) {
          subtitleParts.add(dayDescription);
        }

        return Card(
          child: ListTile(
            onTap: () =>
                _openWorkoutDayOverview(workoutDay),
            title: Text(workoutDay.name),
            subtitle: Text(
              subtitleParts.join(' • '),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                  onPressed: () =>
                      _editWorkoutDay(workoutDay),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: () =>
                      _deleteWorkoutDay(workoutDay),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.view_list_outlined,
                  ),
                  tooltip: 'Manage Contents',
                  onPressed: () =>
                      _openWorkoutGroups(workoutDay),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
