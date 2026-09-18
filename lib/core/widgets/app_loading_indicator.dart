import 'package:flutter/material.dart';

import 'ritmo_hud_widgets.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: ritmoCyan),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFABC7CD),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
