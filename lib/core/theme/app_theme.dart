import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// One place for the app-wide look. Screens only compose widgets, so every
/// new screen automatically matches the Figma kit.
class AppTheme {
  AppTheme._();

  static const double fieldRadius = 30;

  static ThemeData get light {
    final baseTextTheme = ThemeData.light().textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: _withOutfitFont(baseTextTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        hintStyle: const TextStyle(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        border: _border(Colors.transparent),
        enabledBorder: _border(Colors.transparent),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Applies the Outfit font style by style. We avoid
  /// GoogleFonts.outfitTextTheme() because with newer Flutter versions it
  /// returns a different TextTheme type than ThemeData expects (compile error).
  /// Outfit is the closest Google Font to the kit; change it after checking
  /// the real font name in Figma's Inspect panel.
  static TextTheme _withOutfitFont(TextTheme base) {
    TextStyle? outfit(TextStyle? style) =>
        style == null ? null : GoogleFonts.outfit(textStyle: style);

    return base.copyWith(
      displayLarge: outfit(base.displayLarge),
      displayMedium: outfit(base.displayMedium),
      displaySmall: outfit(base.displaySmall),
      headlineLarge: outfit(base.headlineLarge),
      headlineMedium: outfit(base.headlineMedium),
      headlineSmall: outfit(base.headlineSmall),
      titleLarge: outfit(base.titleLarge),
      titleMedium: outfit(base.titleMedium),
      titleSmall: outfit(base.titleSmall),
      bodyLarge: outfit(base.bodyLarge),
      bodyMedium: outfit(base.bodyMedium),
      bodySmall: outfit(base.bodySmall),
      labelLarge: outfit(base.labelLarge),
      labelMedium: outfit(base.labelMedium),
      labelSmall: outfit(base.labelSmall),
    );
  }

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(fieldRadius),
    borderSide: BorderSide(color: color),
  );
}
