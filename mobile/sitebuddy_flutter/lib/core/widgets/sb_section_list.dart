import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// WIDGET: SbSectionList
/// PURPOSE: Standardized vertical layout for screen sections.
///
/// DESIGN PRINCIPLES:
/// - Replaces Column for all screen-level layouts.
/// - SINGLE AUTHORITY: Controls vertical spacing between sections.
/// - Uses AppSpacing.xl for section spacing consistency.
/// - ZERO internal padding (handled by AppScreenWrapper).
class SbSectionList extends StatelessWidget {
  final List<Widget> sections;

  /// Use true ONLY when embedding inside another scrollable
  final bool shrinkWrap;

  /// Default: non-scrollable (controlled by parent)
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

      /// ✅ Centralized spacing system
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.lg),


      itemBuilder: (context, index) => sections[index],
    );
  }
}
