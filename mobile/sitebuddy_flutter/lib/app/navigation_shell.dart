/// FILE HEADER
/// PURPOSE: Main application shell tying together the 4 core screens with a
///          preserved-state [StatefulNavigationShell] from go_router.
/// FUTURE IMPROVEMENTS: Could migrate to go_router StatefulShellRoute deep
///          linking if direct tab deep-linking is needed.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/app_bottom_navigation.dart';

/// The main shell of the application, rendering the active branch inside the
/// [StatefulNavigationShell] (which preserves each branch's widget subtree
/// and scroll position across tab switches).
class NavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: navigationShell,

      // ── Reusable themed bottom navigation ─────────────────────────────────
      // [AppBottomNavigation] owns all colour + elevation concerns.
      // This shell owns only the navigation logic (goBranch).
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          debugPrint('Switched to tab: $index');

          // Future expansion points:
          //   - Add analytics tracking here
          //   - Add deep linking support
          //   - Add state restoration
          navigationShell.goBranch(
            index,
            // Passing initialLocation: true when re-tapping the current tab
            // returns the branch to its root route (standard mobile UX).
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}



