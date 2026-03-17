import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
/// FILE HEADER
/// ----------------------------------------------
/// File: bottom_nav_bar.dart
/// Feature: core
/// Layer: presentation
///
/// PURPOSE:
/// Common bottom navigation bar shared across the shell.
///
/// RESPONSIBILITIES:
/// - Renders the icons and labels for Home, Calculator, Design, and Projects.
/// - Fires the onTap event to notify the shell.
/// - Adapts colours automatically to the active ThemeData (light / dark).
///
/// DEPENDENCIES:
/// - Theme.of(context).colorScheme — no hard-coded palette imports needed.
/// - AppTextStyles for label typography.
///
/// CHANGES (theming fix):
/// - Replaced Theme.of(context).colorScheme.surface → colorScheme.surface
/// - Replaced Theme.of(context).colorScheme.surface border → colorScheme.outlineVariant
/// - Replaced Theme.of(context).colorScheme.primary → colorScheme.primary
/// - Replaced Theme.of(context).colorScheme.onSurfaceVariant → colorScheme.onSurfaceVariant
/// - Added elevation shadow via BoxShadow for visual separation (elevation: 6).
/// - All navigation logic, indices, icons, and labels are unchanged.
///
/// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:site_buddy/core/constants/app_strings.dart';

/// CLASS: BottomNavBar
/// PURPOSE: The main bottom navigation element inside the AppScaffold.
/// WHY: Isolated to allow the NavigationController to handle state rather
///      than internal Stateful logic.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // elevation: 6 equivalent — replicated as a BoxShadow so we retain the
    // custom Container approach (which lets us control the top border and
    // background independently of the default NavigationBar widget).
    final List<BoxShadow> elevationShadow = [
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.12),
        blurRadius: 8,
        offset: const Offset(0, -2),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        // ── Themed background — adapts to light / dark automatically ──────────
        color: colorScheme.surface,
        // ── Subtle top divider using theme's outline colour ───────────────────
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: 1.0,
          ),
        ),
        // ── elevation: 6 shadow painted upward ───────────────────────────────
        boxShadow: elevationShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: currentIndex == 0
                    ? SbIcons.home
                    : SbIcons.homeOutlined,
                label: AppStrings.home,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: currentIndex == 1
                    ? SbIcons.calculator
                    : SbIcons.calculator,
                label: AppStrings.calculators,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: currentIndex == 2
                    ? SbIcons.architecture
                    : SbIcons.architectureOutlined,
                label: AppStrings.design,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: currentIndex == 3
                    ? SbIcons.folderCopy
                    : SbIcons.folderCopyOutlined,
                label: AppStrings.projects,
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// CLASS: _NavItem
/// PURPOSE: A private helper widget defining the UI for a single navigation
///          tab button.
/// WHY: Encapsulates selected vs unselected colour styling.
/// THEMING: All colours resolve through [ColorScheme] — no static values.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // ── Colour resolves automatically with ColorScheme ─────────────────────
    // Selected   → colorScheme.primary   (brand colour, visible in both modes)
    // Unselected → colorScheme.onSurfaceVariant (muted, always readable)
    final Color itemColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: itemColor, size: 24),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: SbTextStyles.bodySecondary(context).copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.5,
              color: itemColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}