import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';


/// WIDGET: SbListItem
/// PURPOSE: Standard list item for SiteBuddy (e.g., Recent Activity).
class SbListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SbListItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SbInteractiveCard(
      onTap: onTap ?? () => debugPrint('TODO: action not implemented'),
      borderRadius: BorderRadius.circular(SbRadius.standard),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(SbRadius.standard),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.md),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}



