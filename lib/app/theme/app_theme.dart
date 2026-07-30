import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Minimal [ThemeData] — colors and fonts only.
///
/// Component themes (buttons, cards, sheets, inputs) are deliberately not
/// configured yet; they come once real screens show which patterns repeat.
abstract final class AppTheme {
  static ThemeData get dark {
    const colors = AppColors.dark;
    const typography = AppTypography.standard;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: colors.background,
      // Explicit scheme so Material widgets never fall back to the default
      // purple seed while component themes are still absent.
      colorScheme: ColorScheme.dark(
        primary: colors.accent,
        onPrimary: colors.onAccent,
        secondary: colors.accent,
        onSecondary: colors.onAccent,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceContainerHighest: colors.surfaceElevated,
        error: colors.danger,
        onError: colors.onAccent,
        outline: colors.border,
      ),
      textTheme: typography.toTextTheme(),
      extensions: const [colors, typography],
    );
  }
}
