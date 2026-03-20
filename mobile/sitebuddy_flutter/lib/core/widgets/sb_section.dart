import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// CLASS: SbSection
/// PURPOSE: A standardized section header and content wrapper for SiteBuddy screens.
/// 
/// DESIGN PRINCIPLES:
/// - STRICT COMPACT RHYTHM: This widget enforces rigorous gaps.
/// - SINGLE OWNERSHIP: Title -> Content Gap is strictly [SbSpacing.xxl].
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
            padding: const EdgeInsets.all(0),
          ),
          const SizedBox(height: SbSpacing.sm), // Enforced fixed gap
        ],
        child,
        const SizedBox(height: SbSpacing.lg), // Anchors the section structurally below it (Sole source of inter-section truth)
      ],
    );
  }
}







