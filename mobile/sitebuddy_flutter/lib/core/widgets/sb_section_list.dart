import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// WIDGET: SbSectionList
/// PURPOSE: Standardized vertical layout for screen sections.
/// 
/// DESIGN PRINCIPLES:
/// - REPLACES Column for all screen-level layouts.
/// - SINGLE AUTHORITY: Enforces exactly AppSpacing.lg (24px) between sections.
/// - ZERO PADDING: Relies on AppScreenWrapper for edge insets.
/// - NO NESTED SCROLLING: Uses physics to prevent scroll conflicts.
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
      padding: EdgeInsets.zero, // 🔬 Rule: No padding, managed by AppScreenWrapper
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.lg), // 👈 24px Gap
      itemBuilder: (context, index) => sections[index],
    );
  }
}
