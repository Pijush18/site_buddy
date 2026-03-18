import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// CLASS: SbSection
/// PURPOSE: A standardized section header and content wrapper for SiteBuddy screens.
/// 
/// DESIGN PRINCIPLES:
/// - PURE 16px RHYTHM: This widget enforces exactly 16px (md) between header and content.
/// - SINGLE OWNERSHIP: External gaps (16px) are managed by parent layout containers.
/// - ARCHITECTURAL STABILITY: No internal offsets or conditional logic to prevent 
///   layered spacing conflicts.
class SbSection extends StatelessWidget {
  /// The section title. If null, the section is "headerless".
  final String? title;
  
  /// The main content of the section.
  final Widget child;
  
  /// Optional additional widget slot in the header.
  final Widget? trailing;
  
  /// Callback for the "View All" action in the header.
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
    // Determine if we should show a header
    final bool hasHeader = title != null || trailing != null || onTap != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasHeader) ...[
          // Standard Section Header
          SbSectionHeader(
            title: title ?? '',
            trailing: trailing,
            onTap: onTap,
            padding: EdgeInsets.zero,
          ),
          // CORE RHYTHM: 8px header gap + 8px card padding = 16px visual content gap.
          const SizedBox(height: AppSpacing.sm),
        ] else ...[
          // CORE RHYTHM: 8px page padding/layout + 8px section offset = 16px border alignment.
          const SizedBox(height: AppSpacing.sm),
        ],
        
        // Logical content block.
        child,
      ],
    );
  }
}
