import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelButtonText),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(deleteButtonText),
        ),
      ],
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