import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/services/workout_export_permission.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../domain/entities/ritmo_builtin_workouts.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_target_type.dart';
import '../admin/workout_json_export.dart';
import 'create_workout_flow_screen.dart';
import 'edit_workout_exercise_screen.dart';

/// Manages canonical, reusable workout definitions independently of plans.
class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({super.key, this.exportPermission});

  /// Injected only by internal tooling or tests. Production defaults to no
  /// export permission while debug builds retain the diagnostic action.
  final WorkoutExportPermission? exportPermission;

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  late Future<List<_WorkoutLibraryItem>> _items;
  late final WorkoutExportPermission _exportPermission;
  var _filter = _WorkoutLibraryFilter.all;
  var _searchQuery = '';
  String? _openingWorkoutId;

  @override
  void initState() {
    super.initState();
    _exportPermission =
        widget.exportPermission ?? const DevelopmentWorkoutExportPermission();
    _reload();
  }

  void _reload() {
    _items = _loadItems();
  }

  Future<List<_WorkoutLibraryItem>> _loadItems() async {
    final workouts = await RepositoryRegistry.workoutExerciseRepository
        .getAllWorkoutExercises();
    final items = await Future.wait(
      workouts.map((workout) async {
        final exercise = await RepositoryRegistry.exerciseRepository
            .getExerciseById(workout.exerciseId);
        return _WorkoutLibraryItem(
          workout: workout,
          name: exercise?.name ?? 'Unknown workout',
          description: exercise?.description ?? '',
        );
      }),
    );
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  Future<void> _createWorkout() async {
    final created = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(builder: (_) => const CreateWorkoutFlowScreen()),
    );
    if (created != null && mounted) {
      setState(_reload);
    }
  }

  Future<void> _openWorkout(_WorkoutLibraryItem item) async {
    if (_openingWorkoutId != null) {
      return;
    }
    setState(() => _openingWorkoutId = item.workout.id);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) {
      return;
    }
    setState(() => _openingWorkoutId = null);
    await _editWorkout(item.workout);
  }

  Future<void> _editWorkout(WorkoutExercise workout) async {
    final exercise = await RepositoryRegistry.exerciseRepository
        .getExerciseById(workout.exerciseId);
    if (!mounted) {
      return;
    }

    final updated = await Navigator.of(context).push<WorkoutExercise>(
      MaterialPageRoute(
        builder: (_) => EditWorkoutExerciseScreen(
          workoutExercise: workout,
          exerciseName: exercise?.name ?? 'Workout',
        ),
      ),
    );
    if (updated == null) {
      return;
    }

    await RepositoryRegistry.workoutExerciseRepository.saveWorkoutExercise(
      updated,
    );
    if (mounted) {
      setState(_reload);
    }
  }

  Future<void> _archiveWorkout(WorkoutExercise workout) async {
    if (RitmoBuiltinWorkouts.isBuiltinWorkoutId(workout.id)) {
      return;
    }
    final confirmed = await AppDeleteConfirmationDialog.show(
      context,
      title: 'Archive Workout',
      message:
          'Archive this workout? It will be removed from the Workout Library.',
      deleteButtonText: 'Archive',
    );
    if (!confirmed) {
      return;
    }

    await RepositoryRegistry.workoutExerciseRepository.saveWorkoutExercise(
      workout.copyWith(isArchived: true),
    );
    if (mounted) {
      setState(_reload);
    }
  }

  Future<void> _exportWorkoutJson(WorkoutExercise workout) async {
    if (!_exportPermission.canExportWorkoutJson) {
      return;
    }

    final persistedWorkout =
        await RepositoryRegistry.workoutExerciseRepository
            .getWorkoutExerciseById(workout.id) ??
        workout;
    final linkedExercise = await RepositoryRegistry.exerciseRepository
        .getExerciseById(persistedWorkout.exerciseId);
    final json = WorkoutJsonExport.encode(
      workoutExercise: persistedWorkout,
      linkedExercise: linkedExercise,
    );

    debugPrint('===== RITMO WORKOUT EXPORT START =====');
    debugPrint(json);
    debugPrint('===== RITMO WORKOUT EXPORT END =====');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout exported to debug console')),
      );
    }
  }

  List<_WorkoutLibraryItem> _filteredItems(List<_WorkoutLibraryItem> items) {
    final query = _searchQuery.trim().toLowerCase();
    return items.where((item) {
      final isBuiltin = RitmoBuiltinWorkouts.isBuiltinWorkoutId(
        item.workout.id,
      );
      final matchesFilter = switch (_filter) {
        _WorkoutLibraryFilter.all => true,
        _WorkoutLibraryFilter.ritmo => isBuiltin,
        _WorkoutLibraryFilter.custom => !isBuiltin,
      };
      return matchesFilter &&
          (query.isEmpty ||
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        title: const Text('WORKOUT LIBRARY'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 230,
        child: RitmoActionButton(
          label: '+ CREATE WORKOUT',
          onPressed: _createWorkout,
        ),
      ),
      body: RitmoCyberpunkBackground(
        child: FutureBuilder<List<_WorkoutLibraryItem>>(
          future: _items,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const _LibraryMessage(
                title: 'ARSENAL UNAVAILABLE',
                message: 'Try opening the Workout Library again.',
              );
            }

            final items = snapshot.data ?? const <_WorkoutLibraryItem>[];
            final visibleItems = _filteredItems(items);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 104),
              children: [
                const RitmoHudSectionHeading(title: 'TRAINING ARSENAL'),
                const SizedBox(height: 8),
                Text(
                  _availabilityLabel(visibleItems.length),
                  style: const TextStyle(
                    color: Color(0xFF9FC7CE),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.15,
                  ),
                ),
                const SizedBox(height: 18),
                _HudSearchField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 14),
                _FilterBar(
                  selected: _filter,
                  onSelected: (filter) => setState(() => _filter = filter),
                ),
                const SizedBox(height: 18),
                if (items.isEmpty)
                  const _ArsenalEmptyState()
                else if (visibleItems.isEmpty)
                  const _LibraryMessage(
                    title: 'NO MATCH FOUND',
                    message: 'Try another workout name.',
                  )
                else
                  ...visibleItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _WorkoutHudCard(
                        item: item,
                        isOpening: _openingWorkoutId == item.workout.id,
                        canExport: _exportPermission.canExportWorkoutJson,
                        onTap: () => _openWorkout(item),
                        onArchive: () => _archiveWorkout(item.workout),
                        onExport: () => _exportWorkoutJson(item.workout),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _availabilityLabel(int count) =>
      '$count ${count == 1 ? 'WORKOUT' : 'WORKOUTS'} AVAILABLE';
}

enum _WorkoutLibraryFilter { all, ritmo, custom }

enum _WorkoutAction { archive, export }

class _WorkoutLibraryItem {
  const _WorkoutLibraryItem({
    required this.workout,
    required this.name,
    required this.description,
  });

  final WorkoutExercise workout;
  final String name;
  final String description;
}

class _HudSearchField extends StatelessWidget {
  const _HudSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: Color(0xFFE4FBFE)),
      decoration: InputDecoration(
        hintText: 'SEARCH YOUR ARSENAL...',
        hintStyle: const TextStyle(
          color: Color(0xFF789AA1),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
        prefixIcon: const Icon(Icons.search, color: ritmoCyan),
        filled: true,
        fillColor: const Color(0xE60A1519),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF38606A)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ritmoCyan, width: 1.4),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});

  final _WorkoutLibraryFilter selected;
  final ValueChanged<_WorkoutLibraryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _WorkoutLibraryFilter.values
            .map(
              (filter) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _HudFilterChip(
                  label: switch (filter) {
                    _WorkoutLibraryFilter.all => 'ALL',
                    _WorkoutLibraryFilter.ritmo => 'RITMO',
                    _WorkoutLibraryFilter.custom => 'CUSTOM',
                  },
                  selected: selected == filter,
                  onPressed: () => onSelected(filter),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _HudFilterChip extends StatelessWidget {
  const _HudFilterChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label filter',
      child: Material(
        key: ValueKey('workout-library-filter-$label'),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF123A43)
                  : const Color(0xE60A1519),
              border: Border.all(
                color: selected ? ritmoCyan : const Color(0xFF36565E),
                width: selected ? 1.3 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: ritmoCyan.withValues(alpha: 0.18),
                        blurRadius: 10,
                      ),
                    ]
                  : const [],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFFE2FCFF)
                    : const Color(0xFFA7C6CC),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.05,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutHudCard extends StatelessWidget {
  const _WorkoutHudCard({
    required this.item,
    required this.isOpening,
    required this.canExport,
    required this.onTap,
    required this.onArchive,
    required this.onExport,
  });

  final _WorkoutLibraryItem item;
  final bool isOpening;
  final bool canExport;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final isBuiltin = RitmoBuiltinWorkouts.isBuiltinWorkoutId(item.workout.id);
    final showsActions = canExport || !isBuiltin;
    return Semantics(
      button: true,
      label: 'Open ${item.name}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          scale: isOpening ? 0.985 : 1,
          child: RitmoHudPanel(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
            glowStrength: isOpening ? 0.8 : (isBuiltin ? 0.22 : 0.08),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WorkoutIcon(isBuiltin: isBuiltin),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFF0FCFE),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _WorkoutStatusBadge(isBuiltin: isBuiltin),
                      const SizedBox(height: 10),
                      _WorkoutMetadata(workout: item.workout),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Column(
                  children: [
                    if (showsActions)
                      PopupMenuButton<_WorkoutAction>(
                        tooltip: 'Workout actions',
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Color(0xFFB9E4E9),
                        ),
                        onSelected: (action) {
                          switch (action) {
                            case _WorkoutAction.archive:
                              onArchive();
                            case _WorkoutAction.export:
                              onExport();
                          }
                        },
                        itemBuilder: (context) => [
                          if (canExport)
                            const PopupMenuItem<_WorkoutAction>(
                              value: _WorkoutAction.export,
                              child: Text('Export Workout JSON'),
                            ),
                          if (!isBuiltin)
                            const PopupMenuItem<_WorkoutAction>(
                              value: _WorkoutAction.archive,
                              child: Text('Archive Workout'),
                            ),
                        ],
                      )
                    else
                      const SizedBox(height: 48),
                    const SizedBox(height: 10),
                    const Icon(Icons.chevron_right, color: ritmoCyan, size: 28),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutIcon extends StatelessWidget {
  const _WorkoutIcon({required this.isBuiltin});

  final bool isBuiltin;

  @override
  Widget build(BuildContext context) {
    final accent = isBuiltin ? ritmoOrange : ritmoCyan;
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        border: Border.all(color: accent.withValues(alpha: 0.62)),
      ),
      child: Icon(Icons.fitness_center_outlined, color: accent),
    );
  }
}

class _WorkoutStatusBadge extends StatelessWidget {
  const _WorkoutStatusBadge({required this.isBuiltin});

  final bool isBuiltin;

  @override
  Widget build(BuildContext context) {
    final accent = isBuiltin ? ritmoOrange : ritmoCyan;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
      ),
      child: Text(
        isBuiltin ? 'RITMO SAMPLE' : 'CUSTOM',
        style: TextStyle(
          color: accent,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _WorkoutMetadata extends StatelessWidget {
  const _WorkoutMetadata({required this.workout});

  final WorkoutExercise workout;

  @override
  Widget build(BuildContext context) {
    final values = <String>[];
    if (workout.sets != null) {
      values.add('${workout.sets} SETS');
    }
    switch (workout.targetType) {
      case WorkoutTargetType.repetitions:
        if (workout.repetitions != null) {
          values.add('${workout.repetitions} REPS');
        }
        break;
      case WorkoutTargetType.duration:
        if (workout.durationInSeconds != null) {
          values.add('${workout.durationInSeconds}s DURATION');
        }
        break;
      case WorkoutTargetType.distance:
      case WorkoutTargetType.calories:
      case WorkoutTargetType.custom:
        break;
    }
    if (workout.restInSeconds != null) {
      values.add('${workout.restInSeconds}s REST');
    }
    if (workout.sequenceDefinition != null) {
      values.add('${workout.sequenceDefinition!.steps.length} STEPS');
    }
    if (values.isEmpty) {
      return const Text(
        'WORKOUT CONFIGURATION',
        style: TextStyle(
          color: Color(0xFF9EBBC0),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.65,
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: values
          .map(
            (value) => Text(
              value,
              style: const TextStyle(
                color: Color(0xFFB9D5D9),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.55,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ArsenalEmptyState extends StatelessWidget {
  const _ArsenalEmptyState();

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.all(24),
      glowStrength: 0.15,
      child: Column(
        children: [
          Image.asset(
            'assets/branding/ritmo_mascot_ready.png',
            height: 112,
            fit: BoxFit.contain,
            semanticLabel: 'RITMO ready coach',
          ),
          const SizedBox(height: 14),
          const Text(
            'YOUR ARSENAL AWAITS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFF0FCFE),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first workout and\nbuild training your way.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFABC7CD), height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _LibraryMessage extends StatelessWidget {
  const _LibraryMessage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFF0FCFE),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Color(0xFFABC7CD))),
        ],
      ),
    );
  }
}
