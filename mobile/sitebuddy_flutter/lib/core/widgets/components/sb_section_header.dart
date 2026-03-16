import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';

/// A standardized section header widget for SiteBuddy forms and layouts.
/// 
/// Uses subtitle typography and provides consistent vertical rhythm
/// using [AppSpacing.lg] for its context.
class SBSectionHeader extends StatelessWidget {
  /// The title text of the section.
  final String title;

  /// Optional widget displayed at the end of the header row (e.g., info icon).
  final Widget? trailing;

  /// Optional top padding. Defaults to [AppSpacing.lg].
  final double? topPadding;

  /// Optional bottom padding. Defaults to [AppSpacing.md].
  final double? bottomPadding;

  const SBSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.topPadding,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final trailing = this.trailing;

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding ?? AppSpacing.lg,
        bottom: bottomPadding ?? AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...?trailing == null ? null : [trailing],
        ],
      ),
    );
  }
}
