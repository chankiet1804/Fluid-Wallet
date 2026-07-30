import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Semantic color tokens. Named by role, never by value, so a light theme can
/// be added later by registering a second instance without touching any UI.
///
/// Access via `context.colors` (see `theme_context.dart`).
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentPressed,
    required this.onAccent,
    required this.success,
    required this.successSurface,
    required this.danger,
    required this.dangerSurface,
    required this.warning,
    required this.warningSurface,
    required this.qrSurface,
    required this.onQrSurface,
  });

  /// Screen background.
  final Color background;

  /// Cards, list groups, amount inputs.
  final Color surface;

  /// Sheets, secondary buttons, circular icon buttons.
  final Color surfaceElevated;

  /// Dividers and hairlines.
  final Color border;

  final Color textPrimary;
  final Color textSecondary;

  /// Placeholders and disabled text.
  final Color textTertiary;

  final Color accent;
  final Color accentPressed;
  final Color onAccent;

  /// Confirmed transactions, incoming amounts, selected state.
  final Color success;
  final Color successSurface;

  /// Failed or reverted transactions, destructive actions, blocked price impact.
  final Color danger;
  final Color dangerSurface;

  /// Non-checksummed addresses (EIP-55), high price impact, unusual slippage.
  final Color warning;
  final Color warningSurface;

  /// QR codes need a light background to stay scannable — this must not follow
  /// the dark scheme, and must not follow a light theme either.
  final Color qrSurface;
  final Color onQrSurface;

  static const dark = AppColors(
    background: AppPalette.dark900,
    surface: AppPalette.dark800,
    surfaceElevated: AppPalette.dark700,
    border: AppPalette.dark600,
    textPrimary: AppPalette.white,
    textSecondary: AppPalette.grey400,
    textTertiary: AppPalette.grey600,
    accent: AppPalette.blue500,
    accentPressed: AppPalette.blue600,
    onAccent: AppPalette.white,
    success: AppPalette.green500,
    successSurface: Color(0x1F3FCF8E),
    danger: AppPalette.red500,
    dangerSurface: Color(0x1FE5484D),
    warning: AppPalette.amber500,
    warningSurface: Color(0x1FF5A524),
    qrSurface: AppPalette.white,
    onQrSurface: AppPalette.black,
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentPressed,
    Color? onAccent,
    Color? success,
    Color? successSurface,
    Color? danger,
    Color? dangerSurface,
    Color? warning,
    Color? warningSurface,
    Color? qrSurface,
    Color? onQrSurface,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentPressed: accentPressed ?? this.accentPressed,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      successSurface: successSurface ?? this.successSurface,
      danger: danger ?? this.danger,
      dangerSurface: dangerSurface ?? this.dangerSurface,
      warning: warning ?? this.warning,
      warningSurface: warningSurface ?? this.warningSurface,
      qrSurface: qrSurface ?? this.qrSurface,
      onQrSurface: onQrSurface ?? this.onQrSurface,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentPressed: Color.lerp(accentPressed, other.accentPressed, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSurface: Color.lerp(dangerSurface, other.dangerSurface, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t)!,
      qrSurface: Color.lerp(qrSurface, other.qrSurface, t)!,
      onQrSurface: Color.lerp(onQrSurface, other.onQrSurface, t)!,
    );
  }
}
