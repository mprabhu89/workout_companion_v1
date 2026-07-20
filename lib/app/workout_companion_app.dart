import 'package:flutter/material.dart';

import 'startup/startup_page.dart';
import 'theme/app_theme.dart';

class WorkoutCompanionApp extends StatelessWidget {
  const WorkoutCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const StartupPage(),
    );
  }
}