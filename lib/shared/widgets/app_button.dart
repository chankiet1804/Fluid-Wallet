import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Full-width filled action. The primary choice on a screen — one per screen.
///
/// A null [onPressed] renders the disabled state.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _ButtonSurface(
      label: label,
      onPressed: onPressed,
      background: colors.accent,
      pressedOverlay: colors.accentPressed,
      foreground: colors.onAccent,
    );
  }
}

/// Full-width tonal action. Sits under a [PrimaryButton] as the alternative.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _ButtonSurface(
      label: label,
      onPressed: onPressed,
      background: colors.surfaceElevated,
      pressedOverlay: colors.border,
      foreground: colors.textPrimary,
    );
  }
}

/// Shared shell for both buttons. Built by hand because `AppTheme.dark`
/// deliberately leaves the Material button themes unconfigured.
class _ButtonSurface extends StatelessWidget {
  const _ButtonSurface({
    required this.label,
    required this.onPressed,
    required this.background,
    required this.pressedOverlay,
    required this.foreground,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color pressedOverlay;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    final radius = BorderRadius.circular(AppDimens.radiusMd);

    return Material(
      color: enabled ? background : colors.surface,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        highlightColor: pressedOverlay,
        child: SizedBox(
          height: AppDimens.buttonHeight,
          width: double.infinity,
          child: Center(
            child: Text(
              label,
              style: context.typo.label.copyWith(
                color: enabled ? foreground : colors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
