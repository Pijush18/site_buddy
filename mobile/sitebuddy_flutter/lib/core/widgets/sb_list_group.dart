import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// WIDGET: SbListGroup
/// PURPOSE: Standardized container for a vertical list of items (usually SbListItemTile).
/// 
/// DESIGN PRINCIPLES:
/// - Enforces consistent spacing between items (SbSpacing.lg).
/// - Removes the need for screens to manually use Column + Spacing logic.
class SbListGroup extends StatelessWidget {
  /// The collection of list items to display.
  final List<Widget> children;

  const SbListGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          // Inject 16px (md) between items, but NOT after the last one
          if (i < children.length - 1) 
            const SizedBox(height: SbSpacing.lg),
        ],
      ],
    );
  }
}




