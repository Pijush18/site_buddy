import 'package:flutter/material.dart';

/// CLASS: AppDecorations
/// PURPOSE: Standard SiteBuddy containers and decorations.
class AppDecorations {
  AppDecorations._();

  /// Global bordered card decoration — use on grids, surface cards, and list tiles.
  static BoxDecoration sbCommonDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: colorScheme.outline,
        width: 1.2,
      ),
    );
  }

  /// Subtle input decoration — same family but lighter, used on input fields.
  static BoxDecoration sbInputDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: colorScheme.outline.withValues(alpha: 0.5),
        width: 1.2,
      ),
    );
  }
}
