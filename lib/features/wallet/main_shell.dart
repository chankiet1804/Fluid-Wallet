import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/theme.dart';
import 'widgets/app_bottom_nav.dart';

/// Chrome around the four signed-in tabs.
///
/// The shell owns the only [Scaffold] for these routes, so each tab screen is
/// just a body — that keeps the bottom bar from rebuilding on every tab switch.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        // `goBranch` keeps each tab's own navigation stack alive instead of
        // resetting it the way a plain `go` would.
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
