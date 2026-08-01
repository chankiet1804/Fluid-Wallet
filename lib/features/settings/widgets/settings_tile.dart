import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';

/// What sits at the end of a [SettingsTile].
enum SettingsTileTrailing {
  /// Opens another screen inside the app.
  chevron,

  /// Leaves the app — a browser or another app takes over.
  externalLink,

  /// Nothing; the row is informational.
  none,
}

/// One row in a settings group: icon, title, optional current value, trailing
/// affordance.
///
/// A null [onTap] renders exactly like a live row — full opacity, no dimming.
/// Every destination here is still being built, and a screen of greyed-out rows
/// reads as broken rather than pending; same call as `CircleIconButton`.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.trailing = SettingsTileTrailing.chevron,
    this.onTap,
  });

  final IconData icon;
  final String title;

  /// Current selection shown before the trailing icon — "USD", "English".
  final String? value;

  final SettingsTileTrailing trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final value = this.value;

    return SettingsRow(
      onTap: onTap,
      icon: icon,
      title: title,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value,
              style: context.typo.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
          switch (trailing) {
            SettingsTileTrailing.chevron => Icon(
              Icons.chevron_right,
              size: 22,
              color: colors.textTertiary,
            ),
            SettingsTileTrailing.externalLink => Padding(
              padding: const EdgeInsets.only(left: AppDimens.space4),
              child: Icon(Icons.open_in_new, size: 18, color: colors.accent),
            ),
            SettingsTileTrailing.none => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}

/// A settings row whose trailing affordance is a switch.
///
/// Stateless on purpose — the screen owns the value, so nothing here can hold a
/// toggle state that drifts from what the app actually does.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsRow(
      icon: icon,
      title: title,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: colors.onAccent,
        activeTrackColor: colors.accent,
      ),
    );
  }
}

/// Shared skeleton of every settings row: leading icon tile, title, trailing
/// slot. Public so a feature can supply a trailing widget the two tiles above
/// do not cover, without rebuilding the layout.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  static const _iconBox = 32.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space8,
        ),
        child: Row(
          children: [
            Container(
              width: _iconBox,
              height: _iconBox,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: Icon(icon, size: 18, color: colors.textSecondary),
            ),
            const SizedBox(width: AppDimens.space12),
            Expanded(child: Text(title, style: context.typo.bodyLarge)),
            const SizedBox(width: AppDimens.space8),
            trailing,
          ],
        ),
      ),
    );
  }
}
