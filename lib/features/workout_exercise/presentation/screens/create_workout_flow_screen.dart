import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/enums/difficulty_level.dart';
import '../../../exercise/domain/enums/equipment_type.dart';
import '../../../exercise/domain/enums/muscle_group.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_target_type.dart';
import '../../domain/repositories/workout_exercise_repository.dart';
import '../widgets/workout_builder_hud.dart';
import 'create_workout_exercise_screen.dart';

/// Creates a custom exercise and its canonical workout only after final save.
class CreateWorkoutFlowScreen extends StatefulWidget {
  const CreateWorkoutFlowScreen({
    super.key,
    this.exerciseRepository,
    this.workoutExerciseRepository,
  });

  final ExerciseRepository? exerciseRepository;
  final WorkoutExerciseRepository? workoutExerciseRepository;

  @override
  State<CreateWorkoutFlowScreen> createState() =>
      _CreateWorkoutFlowScreenState();
}

class _CreateWorkoutFlowScreenState extends State<CreateWorkoutFlowScreen> {
  final _workoutNameController = TextEditingController();

  @override
  void dispose() {
    _workoutNameController.dispose();
    super.dispose();
  }

  Future<void> _defineExercise() async {
    final workoutName = _workoutNameController.text.trim();
    if (workoutName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '! REQUIRED FIELD',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 3),
              Text('Workout name is required.'),
            ],
          ),
        ),
      );
      return;
    }

    final workout = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => _DefineExerciseScreen(
          workoutName: workoutName,
          exerciseRepository:
              widget.exerciseRepository ??
              RepositoryRegistry.exerciseRepository,
          workoutExerciseRepository:
              widget.workoutExerciseRepository ??
              RepositoryRegistry.workoutExerciseRepository,
        ),
      ),
    );
    if (workout != null && mounted) {
      Navigator.of(context).pop(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('CREATE WORKOUT'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              const WorkoutBuilderHeader(
                stage: 1,
                title: 'NAME YOUR WORKOUT',
                subtitle: 'Give your workout an identity.',
                stageLabel: 'IDENTITY',
              ),
              const SizedBox(height: 22),
              WorkoutBuilderSection(
                title: 'NAME YOUR WORKOUT',
                child: RitmoHudTextField(
                  controller: _workoutNameController,
                  label: 'WORKOUT NAME',
                  hint: 'e.g. Morning Push-up',
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(height: 20),
              RitmoActionButton(
                label: 'NEXT: DEFINE EXERCISE',
                onPressed: _defineExercise,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefineExerciseScreen extends StatefulWidget {
  const _DefineExerciseScreen({
    required this.workoutName,
    required this.exerciseRepository,
    required this.workoutExerciseRepository,
  });

  final String workoutName;
  final ExerciseRepository exerciseRepository;
  final WorkoutExerciseRepository workoutExerciseRepository;

  @override
  State<_DefineExerciseScreen> createState() => _DefineExerciseScreenState();
}

class _DefineExerciseScreenState extends State<_DefineExerciseScreen> {
  static const _uuid = Uuid();
  final _descriptionController = TextEditingController();
  final _instructionsController = TextEditingController();
  var _muscleGroup = MuscleGroup.fullBody;
  var _equipment = EquipmentType.bodyweight;
  var _difficulty = DifficultyLevel.beginner;

  @override
  void dispose() {
    _descriptionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _configureWorkout() async {
    final exercise = Exercise(
      id: _uuid.v4(),
      name: widget.workoutName,
      description: _descriptionController.text.trim(),
      instructions: _instructionsController.text.trim(),
      muscleGroup: _muscleGroup,
      equipment: _equipment,
      difficulty: _difficulty,
      isCustom: true,
    );
    final configured = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutExerciseScreen(
          exerciseName: exercise.name,
          workoutExercise: WorkoutExercise(
            id: _uuid.v4(),
            exerciseId: exercise.id,
            displayOrder: 0,
            targetType: WorkoutTargetType.repetitions,
            sets: 3,
            repetitions: 10,
            restInSeconds: 60,
          ),
        ),
      ),
    );
    if (configured == null) {
      return;
    }

    await widget.exerciseRepository.saveExercise(exercise);
    await widget.workoutExerciseRepository.saveWorkoutExercise(configured);
    if (mounted) {
      Navigator.of(context).pop(configured);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('CREATE WORKOUT'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              const WorkoutBuilderHeader(
                stage: 2,
                title: 'DEFINE EXERCISE',
                subtitle: 'CREATE IT YOUR WAY',
                stageLabel: 'EXERCISE',
              ),
              const SizedBox(height: 22),
              Text(
                widget.workoutName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFF0FCFE),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              WorkoutBuilderSection(
                title: 'BASIC PROFILE',
                child: Column(
                  children: [
                    RitmoHudTextField(
                      controller: _descriptionController,
                      label: 'DESCRIPTION',
                      hint: 'What is this workout for?',
                      minLines: 2,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 14),
                    RitmoHudTextField(
                      controller: _instructionsController,
                      label: 'INSTRUCTIONS',
                      hint: 'Optional setup or technique notes',
                      minLines: 3,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              WorkoutBuilderSection(
                title: 'CLASSIFICATION',
                child: Column(
                  children: [
                    _HudDropdown<MuscleGroup>(
                      label: 'MUSCLE GROUP',
                      value: _muscleGroup,
                      items: MuscleGroup.values,
                      labelFor: (value) => value.displayName,
                      onChanged: (value) =>
                          setState(() => _muscleGroup = value),
                    ),
                    const SizedBox(height: 12),
                    _HudDropdown<EquipmentType>(
                      label: 'EQUIPMENT',
                      value: _equipment,
                      items: EquipmentType.values,
                      labelFor: (value) => value.displayName,
                      onChanged: (value) => setState(() => _equipment = value),
                    ),
                    const SizedBox(height: 12),
                    _HudDropdown<DifficultyLevel>(
                      label: 'DIFFICULTY',
                      value: _difficulty,
                      items: DifficultyLevel.values,
                      labelFor: (value) => value.displayName,
                      onChanged: (value) => setState(() => _difficulty = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('BACK'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RitmoActionButton(
                      label: 'NEXT: CONFIGURE',
                      onPressed: _configureWorkout,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HudDropdown<T> extends StatelessWidget {
  const _HudDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.labelFor,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T value) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: const Color(0xFF102027),
      style: const TextStyle(color: Color(0xFFF0FCFE)),
      decoration: ritmoHudInputDecoration(label: label),
      items: items
          .map(
            (item) =>
                DropdownMenuItem<T>(value: item, child: Text(labelFor(item))),
          )
          .toList(growable: false),
      onChanged: (selected) {
        if (selected != null) {
          onChanged(selected);
        }
      },
    );
  }
}
