import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_text.dart';

/// WIDGET: SBToolCard
/// PURPOSE: Reusable card component for a single tool in the grid
/// Uses AppSpacing and AppTypography - no hardcoded styles
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
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isPrimary
                ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(
              color: isPrimary
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isPrimary
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Title
              SBText(
                title,
                variant: SBTextVariant.title,
                maxLines: 1,
              ),
              const SizedBox(height: AppSpacing.xs),
              // Subtitle
              SBText(
                subtitle,
                variant: SBTextVariant.label,
                color: colorScheme.onSurfaceVariant,
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
/// Uses 2-column layout with consistent AppSpacing
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
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.95,
      children: children,
    );
  }
}