import 'package:flutter/material.dart';
import 'package:workout_companion_v1/core/di/repository_registry.dart';
import '../../domain/entities/workout_plan.dart';
import '../controllers/workout_plan_library_controller.dart';
import 'create_workout_plan_screen.dart';
import '../../../workout_day/presentation/screens/workout_day_library_screen.dart';

class WorkoutPlanLibraryScreen extends StatefulWidget {
  const WorkoutPlanLibraryScreen({super.key});

  @override
 State<WorkoutPlanLibraryScreen> createState() =>
      _WorkoutPlanLibraryScreenState();
}

class _WorkoutPlanLibraryScreenState
    extends State<WorkoutPlanLibraryScreen> {
  late final WorkoutPlanLibraryController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WorkoutPlanLibraryController(
      repository: RepositoryRegistry.workoutPlanRepository,
    );

    _controller.addListener(_refresh);
    _controller.loadWorkoutPlans();
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

  Future<void> _createWorkoutPlan() async {
    final plan = await Navigator.of(context).push<WorkoutPlan>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutPlanScreen(
          existingNames: _controller.workoutPlans
              .map((e) => e.name)
              .toList(),
        ),
      ),
    );

    if (plan != null) {
      await _controller.saveWorkoutPlan(plan);
    }
  }

  Future<void> _editWorkoutPlan(WorkoutPlan plan) async {
    final updated = await Navigator.of(context).push<WorkoutPlan>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutPlanScreen(
          workoutPlan: plan,
          existingNames: _controller.workoutPlans
              .map((e) => e.name)
              .toList(),
        ),
      ),
    );

    if (updated != null) {
      await _controller.saveWorkoutPlan(updated);
    }
  }
  
  Future<void> _openWorkoutDays(WorkoutPlan plan) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => WorkoutDayLibraryScreen(
        workoutPlanId: plan.id,
        workoutPlanName: plan.name,
      ),
    ),
  );
}

  Future<void> _deleteWorkoutPlan(WorkoutPlan plan) async {
    await _controller.deleteWorkoutPlan(plan.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plans'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkoutPlan,
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
          'No workout plans yet.\nTap + to create your first workout plan.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _controller.workoutPlans.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final plan = _controller.workoutPlans[index];

        return Card(
          child: ListTile(
            onTap: () => _openWorkoutDays(plan),
            title: Text(plan.name),
            subtitle: Text(
              '${plan.difficulty.name} • ${plan.estimatedDurationMinutes} mins',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                  onPressed: () => _editWorkoutPlan(plan),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                  onPressed: () => _deleteWorkoutPlan(plan),
                ),
              ],
            )
          ),
        );
      },
    );
  }
}