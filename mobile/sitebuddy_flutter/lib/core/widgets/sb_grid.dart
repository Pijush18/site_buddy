import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// WIDGET: SbGrid
/// PURPOSE: Standard 2-column grid for SiteBuddy Home Screen.
class SbGrid extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;

  const SbGrid({
    super.key,
    required this.children,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0, // Tighter horizontal gap
      mainAxisSpacing: AppSpacing.md, // 16px vertical gap
      childAspectRatio: 1.3, // Shorter, more compact tiles
      children: children,
    );
  }
}
