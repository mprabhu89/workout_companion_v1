import 'package:go_router/go_router.dart';

import '../../features/workout/presentation/screens/exercise_library_screen.dart';
import '../startup/startup_page.dart';

final GoRouter appRouter = GoRouter(
  // Temporary while we build the Exercise feature.
  initialLocation: '/exercise-library',

  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const StartupPage(),
    ),
    GoRoute(
      path: '/exercise-library',
      builder: (context, state) => const ExerciseLibraryScreen(),
    ),
  ],
);