import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_button.dart';

/// CLASS: SbSectionHeader
/// PURPOSE: Standardized header row with a title and an optional action target.
/// DESIGN: 14px bold uppercase title, with optional ghost button action.
class SbSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final IconData? actionIcon;
  final Widget? trailing;
  final EdgeInsets? padding;

  const SbSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.actionIcon,
    this.trailing,
    this.padding,
  }) : assert(
          actionLabel == null || onActionTap != null,
          'onActionTap must be provided if actionLabel is set',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title.isNotEmpty)
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (actionLabel != null)
            SbButton.ghost(
              label: actionLabel!,
              icon: SbIcons.chevronRight,
              onPressed: onActionTap,
            )
          else if (actionIcon != null)
            SbButton.icon(
              icon: actionIcon!,
              onPressed: onActionTap,
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
