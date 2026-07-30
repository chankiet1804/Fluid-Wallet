import 'package:flutter/material.dart';

/// Type scale. Access via `context.typo` (see `theme_context.dart`).
///
/// Three styles carry real weight beyond looks:
/// [balanceLarge], [amountMedium] and [numericInput] enable tabular figures so
/// live-updating amounts do not shift horizontally, and [address] uses a
/// monospace face that separates 0/O and 1/l/I — misreading an address loses
/// funds permanently.
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.balanceLarge,
    required this.amountMedium,
    required this.numericInput,
    required this.address,
    required this.titleLarge,
    required this.titleMedium,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.label,
    required this.caption,
  });

  /// Portfolio total on the wallet screen.
  final TextStyle balanceLarge;

  /// Token amounts in lists and rows.
  final TextStyle amountMedium;

  /// Send/Swap amount entry.
  final TextStyle numericInput;

  /// Wallet addresses and transaction hashes. No exceptions.
  final TextStyle address;

  /// Screen titles.
  final TextStyle titleLarge;

  /// Sheet titles, row titles.
  final TextStyle titleMedium;

  final TextStyle bodyLarge;
  final TextStyle bodyMedium;

  /// Button labels, chips.
  final TextStyle label;

  /// Secondary lines under amounts, helper text.
  final TextStyle caption;

  static const _sans = 'Inter';
  static const _mono = 'JetBrainsMono';

  /// Digits keep a fixed advance width. Required on every style that renders a
  /// number that can change while on screen.
  static const _tabular = <FontFeature>[FontFeature.tabularFigures()];

  static const standard = AppTypography(
    balanceLarge: TextStyle(
      fontFamily: _sans,
      fontSize: 44,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: -1,
      fontFeatures: _tabular,
    ),
    amountMedium: TextStyle(
      fontFamily: _sans,
      fontSize: 16,
      height: 1.25,
      fontWeight: FontWeight.w600,
      fontFeatures: _tabular,
    ),
    numericInput: TextStyle(
      fontFamily: _sans,
      fontSize: 32,
      height: 1.2,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      fontFeatures: _tabular,
    ),
    address: TextStyle(
      fontFamily: _mono,
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
    ),
    titleLarge: TextStyle(
      fontFamily: _sans,
      fontSize: 20,
      height: 1.3,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: _sans,
      fontSize: 17,
      height: 1.3,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontFamily: _sans,
      fontSize: 16,
      height: 1.4,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: _sans,
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w400,
    ),
    label: TextStyle(
      fontFamily: _sans,
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.w600,
    ),
    caption: TextStyle(
      fontFamily: _sans,
      fontSize: 13,
      height: 1.35,
      fontWeight: FontWeight.w400,
    ),
  );

  /// Feeds `ThemeData.textTheme` so plain [Text] widgets pick up Inter.
  TextTheme toTextTheme() {
    return TextTheme(
      displayLarge: balanceLarge,
      headlineMedium: numericInput,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      labelLarge: label,
      bodySmall: caption,
    );
  }

  @override
  AppTypography copyWith({
    TextStyle? balanceLarge,
    TextStyle? amountMedium,
    TextStyle? numericInput,
    TextStyle? address,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? label,
    TextStyle? caption,
  }) {
    return AppTypography(
      balanceLarge: balanceLarge ?? this.balanceLarge,
      amountMedium: amountMedium ?? this.amountMedium,
      numericInput: numericInput ?? this.numericInput,
      address: address ?? this.address,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      label: label ?? this.label,
      caption: caption ?? this.caption,
    );
  }

  @override
  AppTypography lerp(covariant AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      balanceLarge: TextStyle.lerp(balanceLarge, other.balanceLarge, t)!,
      amountMedium: TextStyle.lerp(amountMedium, other.amountMedium, t)!,
      numericInput: TextStyle.lerp(numericInput, other.numericInput, t)!,
      address: TextStyle.lerp(address, other.address, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}
