import 'package:go_router/go_router.dart';

import '../startup/startup_page.dart';
import '../startup/startup_video_player.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/developer/presentation/screens/developer_home_screen.dart';
import '../../features/exercise/presentation/screens/exercise_library_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/workout_history/presentation/screens/workout_history_screen.dart';
import '../../features/workout_plan/presentation/screens/workout_plan_library_screen.dart';

GoRouter createAppRouter({
  StartupVideoPlayerFactory? startupVideoPlayerFactory,
}) {
  return GoRouter(
    initialLocation: '/startup',

    routes: <RouteBase>[
      GoRoute(
        path: '/startup',
        builder: (context, state) => StartupPage(
          videoPlayerFactory:
              startupVideoPlayerFactory ?? AssetStartupVideoPlayer.new,
        ),
      ),

      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),

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

      GoRoute(
        path: '/workout-history',
        builder: (context, state) => const WorkoutHistoryScreen(),
      ),

      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),

      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

final GoRouter appRouter = createAppRouter();
