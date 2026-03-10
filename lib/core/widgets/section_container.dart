import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: section_container.dart
/// Feature: core
/// Layer: presentation
///
/// PURPOSE:
/// Container for grouping sections with an optional header and action.
///
/// RESPONSIBILITIES:
/// - Automatically spaces out a title above a child block.
/// - Can provide an optional 'See All' style button on the trailing edge.
///
/// DEPENDENCIES:
/// - Core design constants (AppColors, AppSizes).
///
/// FUTURE IMPROVEMENTS:
/// - Let header be completely overridable.
///
/// ----------------------------------------------

import 'package:flutter/material.dart';

/// CLASS: SectionContainer
/// PURPOSE: Wrapper to organize chunks of UI inside scrolling pages.
/// WHY: Uniform padding and header text standardizes the visual rhythm of the layout.
/// LOGIC: Defines section titles strictly with AppTextStyles.titleLarge natively.
class SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionContainer({
    super.key,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: SbTextStyles.title(context)),
            if (actionLabel != null && onActionTap != null)
              GestureDetector(
                onTap: onActionTap,
                child: Text(
                  actionLabel!,
                  style: SbTextStyles.caption(context).copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppLayout.lg),
        child,
      ],
    );
  }
}