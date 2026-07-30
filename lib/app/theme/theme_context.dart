import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Short accessors for design tokens.
///
/// `Theme.of(context).extension<AppColors>()!` is long enough that people
/// route around it with hardcoded colors. Keeping the correct path the easiest
/// one is what makes the token layer hold.
extension AppThemeX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppTypography get typo => Theme.of(this).extension<AppTypography>()!;
}
