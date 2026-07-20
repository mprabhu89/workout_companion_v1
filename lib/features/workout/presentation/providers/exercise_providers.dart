import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/in_memory_exercise_repository.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../controllers/exercise_library_controller.dart';

final exerciseRepositoryProvider =
    Provider<ExerciseRepository>((ref) {
  return InMemoryExerciseRepository();
});

final exerciseLibraryControllerProvider =
    Provider<ExerciseLibraryController>((ref) {
  return ExerciseLibraryController(
    repository: ref.watch(exerciseRepositoryProvider),
  );
});