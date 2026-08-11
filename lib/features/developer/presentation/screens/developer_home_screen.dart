import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeveloperHomeScreen extends StatelessWidget {
  const DeveloperHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Companion')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Development Menu',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          _MenuTile(
            icon: Icons.fitness_center,
            title: 'Exercise Library',
            subtitle: 'Manage exercise templates',
            onTap: () => context.push('/exercise-library'),
          ),

          const SizedBox(height: 12),

          _MenuTile(
            icon: Icons.assignment,
            title: 'Workout Plans',
            subtitle: 'Manage workout plans',
            onTap: () => context.push('/workout-plans'),
          ),

          const SizedBox(height: 12),

          _MenuTile(
            icon: Icons.history,
            title: 'Workout History',
            subtitle: 'Review completed workouts',
            onTap: () => context.push('/workout-history'),
          ),

          const SizedBox(height: 12),

          const _DisabledTile(
            icon: Icons.calendar_today,
            title: 'Workout Days',
          ),

          const SizedBox(height: 12),

          const _DisabledTile(
            icon: Icons.view_module,
            title: 'Exercise Groups',
          ),

          const SizedBox(height: 12),

          const _DisabledTile(
            icon: Icons.play_circle_outline,
            title: 'Workout Execution',
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _DisabledTile extends StatelessWidget {
  const _DisabledTile({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        enabled: false,
        leading: Icon(icon),
        title: Text(title),
        subtitle: const Text('Coming soon'),
      ),
    );
  }
}
