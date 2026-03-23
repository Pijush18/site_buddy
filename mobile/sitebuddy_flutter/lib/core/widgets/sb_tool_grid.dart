import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_text.dart';

/// WIDGET: SBToolCard
/// PURPOSE: Reusable card component for a single tool in the grid
/// REFINED: Compact layout, strong visual hierarchy, tight spacing
class SBToolCard extends StatelessWidget {
  /// Tool icon
  final IconData icon;

  /// Tool title
  final String title;

  /// Tool subtitle
  final String subtitle;

  /// Navigation route
  final String route;

  /// Whether this is a featured/primary tool
  final bool isPrimary;

  const SBToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isPrimary
                ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(
              color: isPrimary
                  ? colorScheme.primary.withValues(alpha: 0.4)
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon - compact with subtle emphasis for primary
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? colorScheme.primary.withValues(alpha: 0.12)
                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isPrimary
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Title - tight, important
              SBText(
                title,
                variant: SBTextVariant.title,
                maxLines: 1,
              ),
              const SizedBox(height: 2), // Tighter than xs
              // Subtitle - reduced prominence
              SBText(
                subtitle,
                variant: SBTextVariant.label,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// WIDGET: SBToolGrid
/// PURPOSE: Reusable grid system for tool cards
/// REFINED: 2-column with tight, consistent spacing
class SBToolGrid extends StatelessWidget {
  /// List of tools to display
  final List<Widget> children;

  const SBToolGrid({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm, // Tight - not md
      crossAxisSpacing: AppSpacing.sm, // Tight - not md
      childAspectRatio: 1.1, // Slightly taller for content
      children: children,
    );
  }
}