import 'package:go_router/go_router.dart';

//import '../startup/startup_page.dart';
import '../../features/developer/presentation/screens/developer_home_screen.dart';
import '../../features/workout/presentation/screens/exercise_library_screen.dart';
import '../../features/workout_plan/presentation/screens/workout_plan_library_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const DeveloperHomeScreen(),
    ),

    GoRoute(
      path: '/developer',
      builder: (context, state) => const DeveloperHomeScreen(),
    ),

    GoRoute(
      path: '/exercise-library',
      builder: (context, state) => const ExerciseLibraryScreen(),
    ),

    GoRoute(
      path: '/workout-plans',
      builder: (context, state) => const WorkoutPlanLibraryScreen(),
    ),
  ],
);