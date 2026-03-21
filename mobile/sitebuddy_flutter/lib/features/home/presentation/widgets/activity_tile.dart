import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/home/domain/models/activity_type.dart';
import 'package:site_buddy/features/home/domain/models/activity_item.dart';

/// CLASS: ActivityTile
/// PURPOSE: Card representation for a single historical action using SbListItem.
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
    return DateFormat('MMM dd').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SbListItem(
      leading: Container(
        padding: const EdgeInsets.all(SbSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
          borderRadius: SbRadius.borderSmall,
        ),
        child: Icon(
          _getIconForType(activity.type),
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
      title: activity.title,
      subtitle: activity.subtitle,
      trailing: Text(
        _formatTime(activity.timestamp, l10n),
        style: textTheme.labelMedium,
      ),
      onTap: () {
        debugPrint('TODO: action for ${activity.type}');
      },
    );
  }
}


