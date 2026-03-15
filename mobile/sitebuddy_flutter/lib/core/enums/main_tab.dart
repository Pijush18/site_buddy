/// FILE HEADER
/// PURPOSE: Defines main navigation tabs as an enum to prevent accidental reordering.
/// This ensures the bottom navigation order is always consistent across the app.
library;

/// Enum representing the main tab structure in the bottom navigation.
/// DO NOT REORDER - changing the order of these values will break navigation.
enum MainTab { home, calc, design, project }

extension MainTabExtension on MainTab {
  /// Returns the index of the tab, matching the bottom navigation order.
  int get index {
    return switch (this) {
      MainTab.home => 0,
      MainTab.calc => 1,
      MainTab.design => 2,
      MainTab.project => 3,
    };
  }

  /// Returns the route path for the tab.
  String get path {
    return switch (this) {
      MainTab.home => '/',
      MainTab.calc => '/calculator',
      MainTab.design => '/design',
      MainTab.project => '/projects',
    };
  }

  /// Returns the label for the tab.
  String get label {
    return switch (this) {
      MainTab.home => 'Home',
      MainTab.calc => 'Calc',
      MainTab.design => 'Design',
      MainTab.project => 'Project',
    };
  }
}
