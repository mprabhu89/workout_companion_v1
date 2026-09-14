import 'package:flutter/material.dart';

/// Temporary UI boundary for account-backed plan sharing.
abstract final class PlanSharingPlaceholder {
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plan sharing'),
        content: const Text(
          'Plan sharing will be available with RITMO account and cloud sharing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
