import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Round accent button with a caption underneath — the Send / Receive row on
/// the wallet home.
///
/// The circle keeps its accent fill even with a null [onPressed]: the row is a
/// fixed set of four primary actions and dimming one would read as broken
/// rather than pending.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  static const _diameter = 52.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: colors.accent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: _diameter,
              height: _diameter,
              child: Icon(icon, size: 22, color: colors.onAccent),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.space8),
        Text(
          label,
          style: context.typo.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}
