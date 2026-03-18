import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// CLASS: SbSection
/// PURPOSE: A standardized section header and content wrapper for SiteBuddy screens.
class SbSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const SbSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty || trailing != null) ...[
            SbSectionHeader(
              title: title,
              trailing: trailing,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          child,
        ],
      ),
    );
  }
}
