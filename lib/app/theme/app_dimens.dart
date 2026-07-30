/// Spacing, radius and motion constants. Plain `const` — no context needed.
abstract final class AppDimens {
  static const space4 = 4.0;
  static const space8 = 8.0;
  static const space12 = 12.0;
  static const space16 = 16.0;
  static const space20 = 20.0;
  static const space24 = 24.0;
  static const space32 = 32.0;
  static const space40 = 40.0;

  /// Horizontal screen padding, measured from the design.
  static const screenPadding = space20;

  /// Full-width action buttons.
  static const buttonHeight = 56.0;

  static const radiusSm = 12.0;
  static const radiusMd = 16.0;
  static const radiusLg = 20.0;
  static const radiusSheet = 28.0;
  static const radiusPill = 999.0;

  static const durationFast = Duration(milliseconds: 150);
  static const durationMedium = Duration(milliseconds: 250);
}
