import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The "Don't have an account? SIGN UP" line shown at the bottom of both
/// auth screens (one widget instead of the same code twice).
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.question,
    required this.actionLabel,
    required this.onPressed,
  });

  final String question;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Wrap (not Row) so long translations never overflow on small screens.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(question, style: const TextStyle(color: AppColors.textSecondary)),
        TextButton(
          onPressed: onPressed,
          child: Text(actionLabel.toUpperCase()),
        ),
      ],
    );
  }
}
