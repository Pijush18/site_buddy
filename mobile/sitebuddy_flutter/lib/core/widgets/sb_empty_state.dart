import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_button.dart';

/// WIDGET: SbEmptyState
/// PURPOSE: Standardized empty-state display for list screens.
///
/// Shows an icon, a title, an optional subtitle, and an optional action button.
/// Used in all list screens when data is null or empty, ensuring the empty-state
/// experience is visually identical across the app.
///
/// Usage:
/// ```dart
/// SbEmptyState(
///   icon: SbIcons.projectOff,
///   title: 'No Projects Yet',
///   subtitle: 'Create your first project to get started.',
///   actionLabel: 'New Project',
///   onAction: () => context.push('/projects/create'),
/// )
/// ```
class SbEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SbEmptyState({
    super.key,
    this.icon = SbIcons.inbox,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppLayout.pMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: colorScheme.onSurfaceVariant),
            ),
            AppLayout.vGap24,

            // Title
            Text(
              title,
              style: AppTextStyles.sectionTitle(context).copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              AppLayout.vGap8,
              Text(
                subtitle!,
                style: AppTextStyles.body(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action
            if (actionLabel != null && onAction != null) ...[
              AppLayout.vGap24,
              SbButton(
                label: actionLabel!,
                variant: SbButtonVariant.primary,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}