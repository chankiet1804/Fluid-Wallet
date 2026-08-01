import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Placeholder tab. The shell supplies the Scaffold, so this is a body only.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Statistics',
        style: context.typo.bodyLarge.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
