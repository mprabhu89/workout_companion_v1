import 'package:flutter/material.dart';

import 'startup/startup_page.dart';

class WorkoutCompanionApp extends StatelessWidget {
  const WorkoutCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Companion',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const StartupPage(),
    );
  }
}