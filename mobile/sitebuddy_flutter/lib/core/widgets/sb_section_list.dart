import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// WIDGET: SbSectionList
/// PURPOSE: Standardized vertical layout for screen sections.
///
/// DESIGN PRINCIPLES:
/// - Replaces Column for all screen-level layouts.
/// - SINGLE AUTHORITY: Controls vertical spacing between sections.
/// - Uses SbSpacing.sectionGap for consistency.
/// - ZERO internal padding (handled by AppScreenWrapper).
class SbSectionList extends StatelessWidget {
  final List<Widget> sections;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const SbSectionList({
    super.key,
    required this.sections,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: sections.length,
      padding: EdgeInsets.zero,

      /// ✅ CENTRALIZED spacing control (FIXED)
      separatorBuilder: (context, index) =>
          const SizedBox(height: SbSpacing.sectionGap),

      itemBuilder: (context, index) => sections[index],
    );
  }
}



