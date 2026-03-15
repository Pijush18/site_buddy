import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

import 'package:site_buddy/features/home/domain/models/activity_type.dart';
import 'package:site_buddy/features/home/domain/models/activity_item.dart';

/// CLASS: ActivityTile
/// PURPOSE: Card representation for a single historical action.
/// REFINED: Enforces design system standards through UiHelper and Theme.of(context).
class ActivityTile extends StatelessWidget {
  final ActivityItem activity;

  const ActivityTile({super.key, required this.activity});

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.calculator:
        return SbIcons.calculator;
      case ActivityType.leveling:
        return SbIcons.ruler;
      case ActivityType.project:
        return SbIcons.project;
    }
  }

  String _formatTime(DateTime time, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0 && now.day == time.day) {
      return DateFormat('h:mm a').format(time);
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      return DateFormat('MMM dd').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () {
        debugPrint('TODO: routing for ${activity.type}');
      },
      child: Padding(
        padding: const EdgeInsets.all(AppLayout.pMedium),
        child: Row(
          children: [
            // Icon Container
            SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Icon(
                  _getIconForType(activity.type),
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
            ),
            AppLayout.hGap16,

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activity.title,
                    style: SbTextStyles.title(context).copyWith(
                      
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppLayout.vGap4,
                  Text(
                    activity.subtitle,
                    style: SbTextStyles.body(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Time Suffix
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(activity.timestamp, l10n),
                  style: SbTextStyles.bodySecondary(context).copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    
                  ),
                ),
                AppLayout.vGap12,
                Icon(
                  SbIcons.chevronRight,
                  size: 16,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}