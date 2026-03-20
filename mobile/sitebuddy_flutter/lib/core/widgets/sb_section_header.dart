import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

/// CLASS: SbSectionHeader
/// PURPOSE: Standardized header row with a title and an optional action target.
/// 
/// UPDATE:
/// - Action is strictly controlled by [onTap].
/// - Removed dependency on [trailing] for "View All" UI.
/// - "View All" link appears automatically if [onTap] is provided.
class SbSectionHeader extends StatelessWidget {
  final String title;
  
  /// Callback for the "View All" action. 
  /// If provided, the "View All >" label appears on the right.
  final VoidCallback? onTap;
  
  /// Optional override for the action icon. Default is chevronRight.
  final IconData? icon;
  
  /// Optional additional widget slot for external flexibility.
  /// Does NOT trigger the "View All" behavior.
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
    final colorScheme = theme.colorScheme;

    return Padding(
      // Reduced vertical padding slightly for more compact UI
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── TITLE (LEFTSIDE) ──
          if (title.isNotEmpty)
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.sectionTitle(context),
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
                        style: AppTextStyles.caption(context).copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(
                        icon ?? SbIcons.chevronRight,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              
              // External slot (if still needed for filters/etc)
              if (trailing != null) ...[
                if (onTap != null) const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
