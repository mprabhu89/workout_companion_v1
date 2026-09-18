import 'package:flutter/material.dart';
import 'package:workout_companion_v1/core/di/repository_registry.dart';
import 'package:workout_companion_v1/core/widgets/ritmo_hud_widgets.dart';

import '../../../workout_day/domain/repositories/workout_day_repository.dart';
import '../../../workout_day/presentation/screens/workout_day_library_screen.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/repositories/workout_plan_repository.dart';
import '../controllers/workout_plan_library_controller.dart';
import '../widgets/plan_sharing_placeholder.dart';
import '../widgets/training_program_hud_widgets.dart';
import 'create_workout_plan_screen.dart';

class WorkoutPlanLibraryScreen extends StatefulWidget {
  const WorkoutPlanLibraryScreen({
    super.key,
    this.repository,
    this.workoutDayRepository,
    this.workoutDayScreenBuilder,
  });

  final WorkoutPlanRepository? repository;
  final WorkoutDayRepository? workoutDayRepository;
  final Widget Function(WorkoutPlan plan)? workoutDayScreenBuilder;

  @override
  State<WorkoutPlanLibraryScreen> createState() =>
      _WorkoutPlanLibraryScreenState();
}

class _WorkoutPlanLibraryScreenState extends State<WorkoutPlanLibraryScreen> {
  late final WorkoutPlanLibraryController _controller;
  late final WorkoutDayRepository _workoutDayRepository;

  List<WorkoutPlan> get _activePlans => _controller.workoutPlans
      .where((plan) => !plan.isArchived)
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    _workoutDayRepository =
        widget.workoutDayRepository ?? RepositoryRegistry.workoutDayRepository;
    _controller = WorkoutPlanLibraryController(
      repository: widget.repository ?? RepositoryRegistry.workoutPlanRepository,
    );
    _controller.addListener(_refresh);
    _controller.loadWorkoutPlans();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _createWorkoutPlan() async {
    final plan = await Navigator.of(context).push<WorkoutPlan>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutPlanScreen(
          existingNames: _activePlans.map((plan) => plan.name).toList(),
        ),
      ),
    );
    if (plan != null) await _controller.saveWorkoutPlan(plan);
  }

  Future<void> _editWorkoutPlan(WorkoutPlan plan) async {
    final updated = await Navigator.of(context).push<WorkoutPlan>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutPlanScreen(
          workoutPlan: plan,
          existingNames: _activePlans.map((item) => item.name).toList(),
        ),
      ),
    );
    if (updated != null) await _controller.saveWorkoutPlan(updated);
  }

  Future<void> _openWorkoutDays(WorkoutPlan plan) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            widget.workoutDayScreenBuilder?.call(plan) ??
            WorkoutDayLibraryScreen(
              workoutPlanId: plan.id,
              workoutPlanName: plan.name,
              workoutPlanDescription: plan.description,
              workoutPlanCategory: plan.category,
            ),
      ),
    );
    if (mounted) {
      await _controller.loadWorkoutPlans();
    }
  }

  Future<void> _deleteWorkoutPlan(WorkoutPlan plan) =>
      _controller.deleteWorkoutPlan(plan.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKOUT PLANS'),
        actions: [
          IconButton(
            tooltip: 'Import Plan',
            onPressed: () => PlanSharingPlaceholder.show(context),
            icon: const Icon(Icons.file_download_outlined, color: ritmoCyan),
          ),
        ],
      ),
      body: RitmoCyberpunkBackground(child: _buildBody()),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: RitmoActionButton(
          label: 'CREATE PLAN',
          onPressed: _createWorkoutPlan,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator(color: ritmoCyan));
    }

    final plans = _activePlans;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        const RitmoHudSectionHeading(title: 'TRAINING PROGRAMS'),
        const SizedBox(height: 8),
        Text(
          '${plans.length} ${plans.length == 1 ? 'PROGRAM' : 'PROGRAMS'} AVAILABLE',
          style: const TextStyle(
            color: Color(0xFF88AAB0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 18),
        if (plans.isEmpty)
          RitmoHudPanel(
            glowStrength: 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/branding/ritmo_mascot_ready.png',
                  height: 88,
                  fit: BoxFit.contain,
                  semanticLabel: 'RITMO ready mascot',
                ),
                const SizedBox(height: 12),
                const Text(
                  'BUILD YOUR FIRST PROGRAM',
                  style: TextStyle(
                    color: Color(0xFFD8FCFF),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Organize workouts into training days and Sessions.',
                ),
              ],
            ),
          )
        else
          ...plans.map(
            (plan) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProgramCard(
                plan: plan,
                dayRepository: _workoutDayRepository,
                onOpen: () => _openWorkoutDays(plan),
                onEdit: () => _editWorkoutPlan(plan),
                onDelete: () => _deleteWorkoutPlan(plan),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.plan,
    required this.dayRepository,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final WorkoutPlan plan;
  final WorkoutDayRepository dayRepository;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: dayRepository
          .getWorkoutDays(workoutPlanId: plan.id)
          .then((days) => days.where((day) => !day.isRestDay).length),
      builder: (context, snapshot) => RitmoTrainingCard(
        systemLabel: 'TRAINING PROGRAM',
        title: plan.name,
        summary: plan.description.trim().isEmpty
            ? '${plan.category.displayName} / ${plan.difficulty.displayName}'
            : plan.description.trim(),
        metrics: [
          '${snapshot.data ?? 0} TRAINING ${snapshot.data == 1 ? 'DAY' : 'DAYS'}',
          '${plan.estimatedDurationInMinutes} MIN EST.',
        ],
        onTap: onOpen,
        trailing: PopupMenuButton<_ProgramAction>(
          tooltip: 'Program actions',
          icon: const Icon(Icons.more_horiz, color: ritmoCyan),
          onSelected: (action) {
            if (action == _ProgramAction.edit) onEdit();
            if (action == _ProgramAction.delete) onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: _ProgramAction.edit,
              child: Text('Edit program'),
            ),
            PopupMenuItem(
              value: _ProgramAction.delete,
              child: Text('Delete program'),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ProgramAction { edit, delete }
