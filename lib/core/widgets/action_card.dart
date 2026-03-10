import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: action_card.dart
/// Feature: core
/// Layer: presentation
///
/// PURPOSE:
/// A clickable responsive card for quick actions (like in the home screen).
///
/// RESPONSIBILITIES:
/// - Renders a scalable, uniform square card with an icon and label.
/// - Prevents UI bottom-overflow inside GridViews using Flexible bounds.
/// - Handles tap gestures universally.
///
/// DEPENDENCIES:
/// - Core design constants (AppColors, AppSizes).
///
/// FUTURE IMPROVEMENTS:
/// - Could support dynamic network icons if required.
///

/// - Add badge support
/// - Add loading state
/// - Add disabled state
/// ----------------------------------------------

import 'package:flutter/material.dart';

/// CLASS: ActionCard
/// PURPOSE: Reusable widget for presenting primary navigation actions graphically.
/// WHY: Standardizes the look and feel of quick-links across the application.
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// METHOD: build
  /// PURPOSE: Builds the ActionCard UI.
  /// PARAMETERS:
  /// - context: Flutter BuildContext
  /// RETURNS:
  /// - Widget tree
  /// LOGIC:
  /// - Uses GestureDetector for interaction layer
  /// - Wraps Icon inside a Flexible container to guarantee it won't force overflow
  /// - Enforces simple ellipse text overflow logic for the label
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.30
                    : 0.12,
              ),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: AppLayout.borderRadiusCard,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
          // Subtle elevation shadow to give a premium production UI feel
        ),
        padding: const EdgeInsets.all(AppLayout.pSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flexible wrapper ensures the icon scales down if the grid viewport gets squeezed
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(AppLayout.pMedium),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
              ),
            ),
            const SizedBox(height: AppLayout.pSmall),
            // Flexible wrapper guarantees text doesn't overflow bottom edge
            Flexible(
              flex: 1,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SbTextStyles.caption(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}