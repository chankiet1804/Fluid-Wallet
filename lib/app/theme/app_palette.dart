import 'package:flutter/painting.dart';

/// Raw color values. Only the theme layer reads this file — UI code must go
/// through [AppColors] so semantics stay swappable when a light theme lands.
///
/// `background` and `accent` are exact values from the Figma file variables.
/// Everything else is measured by eye from the design screenshots, which are
/// raster images with no handoff data.
abstract final class AppPalette {
  // Surfaces
  static const dark900 = Color(0xFF090D14); // Figma: Basic/Dark (background)
  static const dark800 = Color(0xFF141922);
  static const dark700 = Color(0xFF1C222D);
  static const dark600 = Color(0xFF232A36);

  // Brand
  static const blue500 = Color(0xFF366FFF); // Figma: Blue (to fluid action)
  static const blue600 = Color(0xFF2A5AD9);

  // Onboarding hero glow. Measured by eye from the raster design.
  static const violet600 = Color(0xFF34215E);
  static const navy700 = Color(0xFF141E3A);

  // Text
  static const white = Color(0xFFFFFFFF);
  static const grey400 = Color(0xFF8B95A7);
  static const grey600 = Color(0xFF5A6376);

  // Status
  static const green500 = Color(0xFF3FCF8E);
  static const red500 = Color(0xFFE5484D);
  static const amber500 = Color(0xFFF5A524);

  static const black = Color(0xFF000000);
}
