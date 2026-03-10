import 'package:flutter/material.dart';

/// CLASS: AppDecorations
/// PURPOSE: Standard SiteBuddy containers and decorations.
class AppDecorations {
  AppDecorations._();

  /// Global bordered card decoration — use on grids, surface cards, and list tiles.
  static BoxDecoration sbCommonDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.grey.withValues(alpha: 0.20),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.12),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Subtle input decoration — same family but lighter, used on input fields.
  static BoxDecoration sbInputDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12),
        width: 1.2,
      ),
    );
  }
}
