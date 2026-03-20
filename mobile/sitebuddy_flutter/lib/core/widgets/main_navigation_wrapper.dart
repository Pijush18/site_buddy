

import 'package:flutter/material.dart';

/// WIDGET: MainNavigationWrapper
/// PURPOSE: Ensures bottom navigation consistency across all screens.
/// Following strict project rules: EVERY screen must be wrapped in this.
class MainNavigationWrapper extends StatelessWidget {
  final Widget child;

  const MainNavigationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // In the current multi-navigator setup, the bottom navigation is handled
    // by the MainScreen's IndexedStack. This wrapper provides a consistent
    // container for future global layout enhancements or overlays.
    return child;
  }
}



