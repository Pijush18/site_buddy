import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: bottom_nav_bar.dart
/// Feature: core
/// Layer: presentation
///
/// PURPOSE:
/// Common bottom navigation bar shared across the shell.
/// REFACTOR: Professional Color System (Elevated Surface).
/// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        // 🔬 Elevation Strategy: Border + Shadow for "Lift"
        border: Border(
          top: BorderSide(
            color: colorScheme.outline, 
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.03), 
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: currentIndex == 0 ? SbIcons.home : SbIcons.homeOutlined,
                label: AppStrings.home,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: currentIndex == 1 ? SbIcons.calculator : SbIcons.calculator,
                label: AppStrings.calculators,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: currentIndex == 2 ? SbIcons.architecture : SbIcons.architectureOutlined,
                label: AppStrings.design,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: currentIndex == 3 ? SbIcons.folderCopy : SbIcons.folderCopyOutlined,
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
    final Color itemColor = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: itemColor, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.body(context, secondary: true).copyWith(
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