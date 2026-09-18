import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';

/// Temporary UI boundary for account-backed plan sharing.
abstract final class PlanSharingPlaceholder {
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => RitmoHudDialog(
        title: 'Plan sharing',
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(foregroundColor: ritmoCyan),
            child: const Text('OK'),
          ),
        ],
        child: const Text(
          'Plan sharing will be available with RITMO account and cloud sharing.',
        ),
      ),
    );
  }
}
