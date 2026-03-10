import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// CLASS: ProjectCard
/// PURPOSE: Standard reusable component for displaying a Project entity.
class ProjectCard extends StatelessWidget {
  final String name;
  final String date;
  final String location;
  final int logsCount;
  final int calcsCount;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.name,
    required this.date,
    required this.location,
    required this.logsCount,
    required this.calcsCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppLayout.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: SbTextStyles.title(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(SbIcons.chevronRight, color: colorScheme.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: AppLayout.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: SbTextStyles.bodySecondary(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppLayout.sm),
                  Text(
                    location.toUpperCase(),
                    style: SbTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _StatBadge(
                    icon: SbIcons.description,
                    count: logsCount,
                    label: 'Logs',
                  ),
                  const SizedBox(width: AppLayout.sm),
                  _StatBadge(
                    icon: SbIcons.calculator,
                    count: calcsCount,
                    label: 'Calcs',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatBadge({
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppLayout.pSmall, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppLayout.borderRadiusCard,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurface),
          const SizedBox(width: AppLayout.sm),
          Text(
            '$count $label',
            style: SbTextStyles.caption(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
