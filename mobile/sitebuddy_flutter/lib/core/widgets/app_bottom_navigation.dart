import 'package:site_buddy/core/design_system/sb_icons.dart';
/// FILE HEADER
/// ----------------------------------------------
/// File: app_bottom_navigation.dart
/// Feature: core
/// Layer: widgets
///
/// PURPOSE:
/// Reusable, theme-aware bottom navigation bar backed by Flutter's
/// [BottomNavigationBar]. Replaces the hand-rolled [BottomNavBar] container
/// so the project uses the framework's built-in semantics, accessibility
/// support, and theming pipeline.
///
/// DESIGN CONTRACT:
///   • Caller owns the selected-index state — this widget is purely
///     presentational (StatelessWidget).
///   • All colours resolve through [ColorScheme]; no static palette values.
///   • Navigation items, icons, and page order are identical to the
///     previous [BottomNavBar] widget.
///
/// PARAMETERS:
///   [currentIndex] — The index of the currently active tab (0-based).
///   [onTap]        — Callback fired with the tapped tab index; the caller
///                    is responsible for switching branches (e.g. goBranch).
///
/// COLOUR MAPPING (per spec):
///   backgroundColor     → colorScheme.surface
///   selectedItemColor   → colorScheme.primary
///   unselectedItemColor → colorScheme.onSurfaceVariant
///   elevation           → 0 (Border-only UI)
///
/// FUTURE IMPROVEMENTS:
///   • Animate label visibility on scroll.
///   • Add badge support for notification counts.
///
/// ----------------------------------------------


import 'package:flutter/material.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';


/// WIDGET: AppBottomNavigation
///
/// A fully theme-aware bottom navigation bar. Drop this widget directly into
/// the [Scaffold.bottomNavigationBar] slot.
///
/// Example:
/// ```dart
/// Scaffold(
///   body: ...,
///   bottomNavigationBar: AppBottomNavigation(
///     currentIndex: _index,
///     onTap: (i) => setState(() => _index = i),
///   ),
/// );
/// ```
class AppBottomNavigation extends StatelessWidget {
  /// Index of the currently visible tab (0 = Home … 3 = Project).
  final int currentIndex;

  /// Called with the index of the tab the user tapped.
  /// The caller decides how to react (e.g. GoRouter's [goBranch]).
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        // ── Colour theming ─────────────────────────────────────────────────────
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,

        // ── Elevation / shadow ────────────────────────────────────────────────
        elevation: 0,

        // ── State ────────────────────────────────────────────────────────────
        currentIndex: currentIndex,
        onTap: onTap,

        // ── Layout ───────────────────────────────────────────────────────────
        // 'fixed' keeps all labels visible at all times, matching the
        // previous custom implementation's always-visible labels.
        type: BottomNavigationBarType.fixed,

        // Always show labels (matches the previous always-visible text style).
        showSelectedLabels: true,
        showUnselectedLabels: true,

        // ── Typography ────────────────────────────────────────────────────────
        selectedLabelStyle: Theme.of(context).textTheme.labelMedium!,
        unselectedLabelStyle: Theme.of(context).textTheme.labelMedium!,

        // ── Navigation items ──────────────────────────────────────────────────
        // Order and icons are identical to the original BottomNavBar.
        items: [
          BottomNavigationBarItem(
            icon: const Icon(SbIcons.homeOutlined),
            activeIcon: const Icon(SbIcons.home),
            label: AppLocalizations.of(context)!.appName.toUpperCase(),
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(SbIcons.calculator),
            activeIcon: const Icon(SbIcons.calculator),
            label: AppLocalizations.of(context)!.calculator.toUpperCase(),
            tooltip: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: const Icon(SbIcons.architectureOutlined),
            activeIcon: const Icon(SbIcons.architecture),
            label: AppLocalizations.of(context)!.design.toUpperCase(),
            tooltip: 'Design',
          ),
          BottomNavigationBarItem(
            icon: const Icon(SbIcons.folderCopyOutlined),
            activeIcon: const Icon(SbIcons.folderCopy),
            label: AppLocalizations.of(context)!.project.toUpperCase(),
            tooltip: 'Projects',
          ),
        ],
      ),
    );
  }
}







