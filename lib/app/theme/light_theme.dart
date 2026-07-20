import 'package:flutter/material.dart';

import '../../core/design_system/colors/app_colors.dart';
import '../../core/design_system/radius/app_radius.dart';
import '../../core/design_system/typography/app_typography.dart';

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,

    scaffoldBackgroundColor: AppColors.surface,

    textTheme: const TextTheme(
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      titleMedium: AppTypography.title,
      bodyLarge: AppTypography.body,
      labelLarge: AppTypography.label,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
  );
}