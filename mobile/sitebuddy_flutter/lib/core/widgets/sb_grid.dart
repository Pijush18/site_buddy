import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// WIDGET: SbGrid
/// PURPOSE: Standard 2-column grid layout for SiteBuddy.
/// DESIGN: 
/// - Enforces AspectRatio 1:1 for internal tiles.
/// - Returns a raw GridView (NOT a surface) to avoid nesting.
/// - Parent section or SbCard controls background.
class SbGrid extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;

  const SbGrid({
    super.key,
    required this.children,
    this.childAspectRatio = 1.0, // Forced 1:1 for premium consistency
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: SbSpacing.sm,
      mainAxisSpacing: SbSpacing.sm,
      childAspectRatio: childAspectRatio,
      children: children,
    );
  }
}
