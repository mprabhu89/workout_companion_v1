import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../workout_history/domain/services/workout_statistics_service.dart';
import '../../../workout_history/presentation/controllers/workout_history_controller.dart';
import '../../../workout_history/presentation/screens/workout_statistics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final WorkoutHistoryController _historyController;
  late final PageController _pageController;
  var _selectedModuleIndex = 0;
  var _isEntering = false;

  static const _modules = <_LobbyModule>[
    _LobbyModule(
      title: 'Workout Library',
      subtitle: 'BUILD YOUR TRAINING ARSENAL',
      route: '/workout-library',
      assetPath: 'assets/branding/ritmo_mascot_hero.png',
      icon: Icons.fitness_center_outlined,
    ),
    _LobbyModule(
      title: 'Workout Plans',
      subtitle: 'STRUCTURE. PROGRESS. ACHIEVE.',
      route: '/workout-plans',
      assetPath: 'assets/branding/ritmo_mascot_ready.png',
      icon: Icons.account_tree_outlined,
    ),
    _LobbyModule(
      title: 'Progress',
      subtitle: 'TRACK. IMPROVE. LEVEL UP.',
      route: '/progress',
      assetPath: 'assets/branding/ritmo_mascot_success.png',
      icon: Icons.insights_outlined,
    ),
    _LobbyModule(
      title: 'History',
      subtitle: 'EVERY WORKOUT COUNTS.',
      route: '/workout-history',
      assetPath: 'assets/branding/ritmo_mascot_success.png',
      icon: Icons.history_outlined,
    ),
    _LobbyModule(
      title: 'Settings',
      subtitle: 'CUSTOMIZE YOUR RITMO EXPERIENCE.',
      route: '/settings',
      assetPath: 'assets/branding/ritmo_mascot_rest.png',
      icon: Icons.tune_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.79);
    _historyController = WorkoutHistoryController.create(
      repository: RepositoryRegistry.workoutHistoryRepository,
      statisticsService: const WorkoutStatisticsService(),
    )..loadSessions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _historyController.dispose();
    super.dispose();
  }

  Future<void> _enterSelectedModule() async {
    if (_isEntering) return;
    setState(() => _isEntering = true);
    await Future<void>.delayed(const Duration(milliseconds: 170));
    if (!mounted) return;
    setState(() => _isEntering = false);
    context.push(_modules[_selectedModuleIndex].route);
  }

  Future<void> _moveToModule(int index) async {
    if (index < 0 || index >= _modules.length || !_pageController.hasClients) {
      return;
    }
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _openStatistics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutStatisticsScreen(controller: _historyController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _historyController.loadSessions,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      _LobbyHeader(
                        onOpenDeveloperTools: () => context.push('/developer'),
                      ),
                      const SizedBox(height: 28),
                      const RitmoHudSectionHeading(title: 'CHOOSE YOUR PATH'),
                      const SizedBox(height: 14),
                      _ModuleCarousel(
                        controller: _pageController,
                        modules: _modules,
                        selectedIndex: _selectedModuleIndex,
                        height: 370,
                        isEntering: _isEntering,
                        onPageChanged: (index) {
                          setState(() => _selectedModuleIndex = index);
                        },
                        onEnterSelected: _enterSelectedModule,
                        onSelect: _moveToModule,
                      ),
                      const SizedBox(height: 14),
                      _CarouselIndicator(
                        count: _modules.length,
                        selectedIndex: _selectedModuleIndex,
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'SWIPE TO EXPLORE',
                          style: TextStyle(
                            color: Color(0xFF8FAFB5),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _LobbyTrainingData(
                        controller: _historyController,
                        onOpenStatistics: _openStatistics,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LobbyHeader extends StatelessWidget {
  const _LobbyHeader({
    required this.onOpenDeveloperTools,
  });

  final VoidCallback onOpenDeveloperTools;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/branding/ritmo_logo_primary.png',
                height: 44,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
                semanticLabel: 'RITMO',
              ),
              const SizedBox(height: 10),
              Text(
                'THE ULTIMATE WORKOUT COMPANION',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFB3D1D6),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.25,
                    ),
              ),
            ],
          ),
        ),
        PopupMenuButton<_DashboardMenuAction>(
          tooltip: 'More options',
          iconColor: const Color(0xFFBDECF2),
          onSelected: (action) {
            if (action == _DashboardMenuAction.developerTools) {
              onOpenDeveloperTools();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _DashboardMenuAction.developerTools,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.developer_mode_outlined),
                title: Text('Developer tools'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModuleCarousel extends StatelessWidget {
  const _ModuleCarousel({
    required this.controller,
    required this.modules,
    required this.selectedIndex,
    required this.height,
    required this.isEntering,
    required this.onPageChanged,
    required this.onEnterSelected,
    required this.onSelect,
  });

  final PageController controller;
  final List<_LobbyModule> modules;
  final int selectedIndex;
  final double height;
  final bool isEntering;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onEnterSelected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: modules.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final page = controller.hasClients
                      ? controller.page ?? controller.initialPage.toDouble()
                      : controller.initialPage.toDouble();
                  final distance = (page - index).abs().clamp(0.0, 1.0);
                  final emphasis = 1 - distance;
                  return Opacity(
                    opacity: lerpDouble(0.55, 1, emphasis)!,
                    child: Transform.scale(
                      scale: lerpDouble(0.9, 1, emphasis)!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _LobbyModuleCard(
                          key: Key('lobby-card-${modules[index].title}'),
                          module: modules[index],
                          emphasis: emphasis,
                          isEntering: isEntering && index == selectedIndex,
                          onEnter: index == selectedIndex
                              ? onEnterSelected
                              : () => onSelect(index),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (selectedIndex > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: _CarouselArrow(
                tooltip: 'Previous module',
                icon: Icons.chevron_left,
                onTap: () => onSelect(selectedIndex - 1),
              ),
            ),
          if (selectedIndex < modules.length - 1)
            Align(
              alignment: Alignment.centerRight,
              child: _CarouselArrow(
                tooltip: 'Next module',
                icon: Icons.chevron_right,
                onTap: () => onSelect(selectedIndex + 1),
              ),
            ),
        ],
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: const Color(0xDD0B171C),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 38,
            height: 56,
            child: Icon(icon, color: ritmoCyan, size: 32),
          ),
        ),
      ),
    );
  }
}

class _LobbyModuleCard extends StatelessWidget {
  const _LobbyModuleCard({
    super.key,
    required this.module,
    required this.emphasis,
    required this.isEntering,
    required this.onEnter,
  });

  final _LobbyModule module;
  final double emphasis;
  final bool isEntering;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: emphasis > 0.95,
      label: module.title,
      child: RitmoHudPanel(
        glowStrength: emphasis,
        padding: const EdgeInsets.all(18),
        child: _portraitContent(context),
      ),
    );
  }

  Widget _portraitContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Icon(module.icon, color: ritmoOrange),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Center(
            child: Transform.translate(
              offset: Offset(0, -4 * emphasis),
              child: Image.asset(
                module.assetPath,
                height: 142 + (22 * emphasis),
                fit: BoxFit.contain,
                semanticLabel: '${module.title} mascot',
              ),
            ),
          ),
        ),
        _ModuleCopy(module: module),
        const SizedBox(height: 16),
        RitmoActionButton(
          label: 'ENTER',
          isPulsing: isEntering,
          onPressed: onEnter,
        ),
      ],
    );
  }

}

class _ModuleCopy extends StatelessWidget {
  const _ModuleCopy({required this.module});

  final _LobbyModule module;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          module.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          module.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFF9EB8BE),
                letterSpacing: 0.8,
                height: 1.2,
              ),
        ),
      ],
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  const _CarouselIndicator({required this.count, required this.selectedIndex});

  final int count;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Module ${selectedIndex + 1} of $count selected',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            width: index == selectedIndex ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index == selectedIndex ? ritmoCyan : const Color(0xFF385159),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

class _LobbyTrainingData extends StatelessWidget {
  const _LobbyTrainingData({
    required this.controller,
    required this.onOpenStatistics,
  });

  final WorkoutHistoryController controller;
  final VoidCallback onOpenStatistics;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const SizedBox(
            height: 120,
            child: AppLoadingIndicator(message: 'Loading training data...'),
          );
        }
        if (controller.errorMessage != null) {
          return RitmoHudPanel(
            glowStrength: 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RitmoHudSectionHeading(title: 'TRAINING DATA'),
                const SizedBox(height: 10),
                Text(controller.errorMessage!),
                const SizedBox(height: 14),
                RitmoActionButton(label: 'RETRY', onPressed: controller.loadSessions),
              ],
            ),
          );
        }
        if (controller.sessions.isEmpty) {
          return RitmoHudPanel(
            glowStrength: 0.3,
            child: Row(
              children: [
                Image.asset(
                  'assets/branding/ritmo_mascot_ready.png',
                  width: 74,
                  height: 74,
                  fit: BoxFit.contain,
                  semanticLabel: 'RITMO ready mascot',
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RitmoHudSectionHeading(title: 'TRAINING DATA'),
                      SizedBox(height: 10),
                      Text(
                        'YOUR JOURNEY STARTS HERE',
                        style: TextStyle(
                          color: Color(0xFFD4FBFF),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Complete your first workout to activate your training stats.'),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return RitmoHudPanel(
          glowStrength: 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RitmoHudSectionHeading(
                title: 'TRAINING DATA',
                trailing: TextButton(
                  onPressed: onOpenStatistics,
                  child: const Text('VIEW ALL'),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _DataPoint(
                    label: 'WORKOUTS',
                    value: '${controller.completedWorkouts}',
                  ),
                  _DataPoint(
                    label: 'TRAINING TIME',
                    value: _formatDuration(controller.totalDurationInSeconds),
                  ),
                  _DataPoint(
                    label: 'COMPLETION',
                    value:
                        '${(controller.completionRate * 100).toStringAsFixed(1)}%',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    if (duration.inMinutes > 0) return '${duration.inMinutes}m';
    return '${duration.inSeconds}s';
  }
}

class _DataPoint extends StatelessWidget {
  const _DataPoint({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF8FAFB5),
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFBDECF2),
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

enum _DashboardMenuAction { developerTools }

class _LobbyModule {
  const _LobbyModule({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.assetPath,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String route;
  final String assetPath;
  final IconData icon;
}
