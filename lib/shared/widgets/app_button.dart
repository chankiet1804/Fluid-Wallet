import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Full-width filled action. The primary choice on a screen — one per screen.
///
/// A null [onPressed] renders the disabled state.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Sits before the label. Null renders the label alone, centred.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _ButtonSurface(
      label: label,
      onPressed: onPressed,
      icon: icon,
      background: colors.accent,
      pressedOverlay: colors.accentPressed,
      foreground: colors.onAccent,
    );
  }
}

/// Full-width tonal action. Sits under a [PrimaryButton] as the alternative.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Sits before the label. Null renders the label alone, centred.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _ButtonSurface(
      label: label,
      onPressed: onPressed,
      icon: icon,
      background: colors.surfaceElevated,
      pressedOverlay: colors.border,
      foreground: colors.textPrimary,
    );
  }
}

/// Full-width destructive action — deleting a wallet, wiping the app.
///
/// Tonal rather than filled on purpose: a solid red block reads as the
/// recommended action, and destroying a key never is.
class DangerButton extends StatelessWidget {
  const DangerButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _ButtonSurface(
      label: label,
      onPressed: onPressed,
      background: colors.dangerSurface,
      pressedOverlay: colors.danger.withValues(alpha: 0.24),
      foreground: colors.danger,
    );
  }
}

/// Shared shell for the buttons. Built by hand because `AppTheme.dark`
/// deliberately leaves the Material button themes unconfigured.
class _ButtonSurface extends StatelessWidget {
  const _ButtonSurface({
    required this.label,
    required this.onPressed,
    required this.background,
    required this.pressedOverlay,
    required this.foreground,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color pressedOverlay;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    final radius = BorderRadius.circular(AppDimens.radiusMd);
    final icon = this.icon;
    final foreground = enabled ? this.foreground : colors.textTertiary;
    final label = Text(
      this.label,
      style: context.typo.label.copyWith(color: foreground),
    );

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
            child: icon == null
                ? label
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 20, color: foreground),
                      const SizedBox(width: AppDimens.space8),
                      label,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
