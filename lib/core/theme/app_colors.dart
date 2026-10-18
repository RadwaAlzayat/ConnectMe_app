import 'package:flutter/material.dart';

/// Design tokens sampled from the Figma UI kit screenshots.
/// Keep every color here so screens never hard-code hex values.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5252C7);
  static const Color gradientStart = Color(0xFF5555C9);
  static const Color gradientEnd = Color(0xFF8588F1);
  static const Color heroDark = Color(0xFF121013);

  static const Color fieldFill = Color(0xFFF3F5F7);
  static const Color surfaceMuted = Color(0xFFF6F7F9);
  static const Color primaryTint = Color(0xFFF1F1FE);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF828282);
  static const Color textHint = Color(0xFFBDBDBD);

  // Not part of the kit: needed for validation and Firebase error messages.
  static const Color error = Color(0xFFD64545);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [heroDark, primary],
  );
}
