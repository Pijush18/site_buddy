import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';

/// WIDGET: SBGridActionCard
/// PURPOSE: Standardized card for grid-based actions, tools, and shortcuts.
/// ENFORCES: 8px radius, 1px border, centered layout.
class SBGridActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isHighlighted;

  const SBGridActionCard({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.isPrimary = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SbRadius.standard),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(SbSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(SbRadius.standard),
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24, // Compact
                  color: isPrimary
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: SbSpacing.sm),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPrimary
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            Positioned(
              top: 8,
              right: 8,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

