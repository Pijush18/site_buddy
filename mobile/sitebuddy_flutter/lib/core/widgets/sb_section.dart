import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// CLASS: SbSection
/// PURPOSE: A standardized section header and content wrapper for SiteBuddy screens.
/// 
/// DESIGN PRINCIPLES:
/// - STRICT COMPACT RHYTHM: This widget enforces rigorous gaps.
/// - SINGLE OWNERSHIP: Title -> Content Gap is strictly [AppSpacing.sectionGap].
/// - ARCHITECTURAL STABILITY: No internal offsets or conditional logic.
class SbSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SbSection({
    super.key,
    this.title,
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
            trailing: trailing,
            onTap: onTap,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.sectionGap), // Enforced fixed gap
        ],
        child,
        const SizedBox(height: AppSpacing.md), // Anchors the section structurally below it (Sole source of inter-section truth)
      ],
    );
  }
}
