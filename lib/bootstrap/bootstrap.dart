import 'package:flutter/material.dart';

import '../core/di/repository_registry.dart';
import '../app/workout_companion_app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await RepositoryRegistry.initialize();
    runApp(const WorkoutCompanionApp());
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'bootstrap',
        context: ErrorDescription(
          'while initializing local persistence',
        ),
      ),
    );

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to initialize local storage.\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
