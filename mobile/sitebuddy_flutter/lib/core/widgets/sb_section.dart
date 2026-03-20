import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// CLASS: SbSection
/// PURPOSE: Standardized section wrapper with header + content.
/// REFINEMENT: Tightening the internal rhythm between header and content for a premium "one-piece" unit feel.
class SbSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SbSection({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasHeader = title != null || trailing != null || onTap != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasHeader) ...[
          SbSectionHeader(
            title: title ?? '',
            subtitle: subtitle,
            trailing: trailing,
            onTap: onTap,
          ),

          /// Tighter internal gap: 8 -> 4 (XS) to group header with its content
          const SizedBox(height: SbSpacing.xs),
        ],

        /// Content only — no bottom spacing (handled by SbSectionList)
        child,
      ],
    );
  }
}
