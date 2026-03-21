import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

// lib/core/widgets/app_stat_card.dart
//
// Reusable statistics card for the SiteBuddy dashboard.
//
// Usage:
//   AppStatCard(
//     icon: SbIcons.check,
//     title: 'Completed Tasks',
//     value: '12',
//   )

import 'package:flutter/material.dart';

/// WIDGET: AppStatCard
///
/// A reusable dashboard statistics card displaying an icon, a large metric value,
/// and a small descriptive title.
///
/// Ensures a consistent visual language across the home dashboard.
///
/// Layout (vertical):
/// ```
/// ┌───────────────┐
/// │  [Icon]       │
/// │               │
/// │  Value        │
/// │  Title        │
/// └───────────────┘
/// ```
class AppStatCard extends StatelessWidget {
  /// Icon displayed at the top left of the card.
  final IconData icon;

  /// Small caption describing the metric.
  final String title;

  /// Large text displaying the actual metric/statistic.
  final String value;

  const AppStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Extract theme values for consistent styling
    final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

    return Container(
      // Padding inside the card
      padding: const EdgeInsets.all(SbSpacing.sm),

      // Styling and borders
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: SbRadius.borderMd,
        // Subtle outline border
        border: Border.all(
          // Using withValues(alpha: ...) to avoid deprecated withOpacity
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Wrap content vertically
        children: [
          // ── Icon ───────────────────────────────────────────────────────────
          Icon(icon, size: 28, color: colorScheme.primary),

          // Small gap instead of Expanded to prevent layout errors in Columns
          const SizedBox(height: SbSpacing.sm),

          // ── Value ──────────────────────────────────────────────────────────
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: SbSpacing.xs),

          // ── Title / Caption ────────────────────────────────────────────────
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}







