import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';

/// Rounded card that holds a run of settings rows.
///
/// No dividers between children: the rows already carry their own leading icon
/// and generous vertical padding, and the grouping is what separates sections.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.space4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Column(children: children),
    );
  }
}
