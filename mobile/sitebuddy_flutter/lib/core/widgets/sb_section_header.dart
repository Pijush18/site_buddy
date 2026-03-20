import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// CLASS: SbSectionHeader
/// PURPOSE: Standardized header row with a title and an optional action target.
class SbSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsets? padding;

  const SbSectionHeader({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: SbSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── TITLE (LEFTSIDE) ──
          if (title.isNotEmpty)
            Expanded(
              child: Text(
                title,
                style: textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // ── ACTION SLOT (RIGHTSIDE) ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Standardized "View All >" Link
              if (onTap != null)
                GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View All",
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(width: SbSpacing.xs),
                      Icon(
                        icon ?? SbIcons.chevronRight,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              
              // External slot
              if (trailing != null) ...[
                if (onTap != null) const SizedBox(width: SbSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}



