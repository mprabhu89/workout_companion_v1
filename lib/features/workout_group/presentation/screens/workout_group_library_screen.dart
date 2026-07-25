import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_card.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../domain/entities/workout_group.dart';
import '../controllers/workout_group_controller.dart';
import 'create_workout_group_screen.dart';

class WorkoutGroupLibraryScreen extends StatefulWidget {
  const WorkoutGroupLibraryScreen({
    super.key,
    required this.workoutDayId,
    required this.workoutDayName,
  });

  final String workoutDayId;
  final String workoutDayName;

  @override
  State<WorkoutGroupLibraryScreen> createState() =>
      _WorkoutGroupLibraryScreenState();
}

class _WorkoutGroupLibraryScreenState
    extends State<WorkoutGroupLibraryScreen> {
  late final WorkoutGroupController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WorkoutGroupController(
      repository: RepositoryRegistry.workoutGroupRepository,
      workoutDayId: widget.workoutDayId,
    );

    _controller.loadWorkoutGroups();
  }

  Future<void> _createWorkoutGroup() async {
    final workoutGroup =
        await Navigator.of(context).push<WorkoutGroup>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutGroupScreen(
          workoutDayId: widget.workoutDayId,
          existingNames: _controller.workoutGroups
              .map((e) => e.name)
              .toList(),
        ),
      ),
    );

    if (workoutGroup == null) return;

    await _controller.saveWorkoutGroup(workoutGroup);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _editWorkoutGroup(
    WorkoutGroup workoutGroup,
  ) async {
    final updated =
        await Navigator.of(context).push<WorkoutGroup>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutGroupScreen(
          workoutDayId: widget.workoutDayId,
          workoutGroup: workoutGroup,
          existingNames: _controller.workoutGroups
              .map((e) => e.name)
              .toList(),
        ),
      ),
    );

    if (updated == null) return;

    await _controller.saveWorkoutGroup(updated);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteWorkoutGroup(
    WorkoutGroup workoutGroup,
  ) async {
    final confirmed =
        await AppDeleteConfirmationDialog.show(
      context,
      title: 'Delete Workout Group',
      message:
          'Are you sure you want to delete "${workoutGroup.name}"?',
    );

    if (!confirmed) return;

    await _controller.deleteWorkoutGroup(workoutGroup.id);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.workoutDayName),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createWorkoutGroup,
            child: const Icon(Icons.add),
          ),
          body: _controller.isLoading
              ? const AppLoadingIndicator(
                  message: 'Loading workout groups...',
                )
              : _controller.workoutGroups.isEmpty
                  ? const AppEmptyState(
                      title: 'No Workout Groups',
                      message:
                          'Tap + to create your first workout group.',
                    )
                  : ListView.builder(
                      itemCount:
                          _controller.workoutGroups.length,
                      itemBuilder: (context, index) {
                        final group =
                            _controller.workoutGroups[index];

                        return AppListCard(
                          title: group.name,
                          subtitle:
                              'Order: ${group.groupOrder}',
                          onTap: () =>
                              _editWorkoutGroup(group),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteWorkoutGroup(group),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}