import 'package:flutter/material.dart';

import 'ritmo_hud_widgets.dart';

class AppDeleteConfirmationDialog extends StatelessWidget {
  const AppDeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.deleteButtonText = 'Delete',
    this.cancelButtonText = 'Cancel',
  });

  final String title;
  final String message;
  final String deleteButtonText;
  final String cancelButtonText;

  @override
  Widget build(BuildContext context) {
    return RitmoHudDialog(
      title: title,
      destructive: true,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: OutlinedButton.styleFrom(foregroundColor: ritmoCyan),
          child: Text(cancelButtonText.toUpperCase()),
        ),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFF9A9A),
            side: const BorderSide(color: Color(0xFFB65555)),
          ),
          child: Text(deleteButtonText.toUpperCase()),
        ),
      ],
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFFD2E6E9), height: 1.35),
      ),
    );
  }

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String deleteButtonText = 'Delete',
    String cancelButtonText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AppDeleteConfirmationDialog(
        title: title,
        message: message,
        deleteButtonText: deleteButtonText,
        cancelButtonText: cancelButtonText,
      ),
    );

    return result ?? false;
  }
}
