import 'package:flutter/material.dart';

/// CLASS: SbSurface
/// PURPOSE: Centralized semantic surface system for consistent container backgrounds.
class SbSurface {
  SbSurface._();

  /// High-level card backgrounds (standard cards, project tiles).
  static Color card(BuildContext context) => Theme.of(context).colorScheme.surface;

  /// Secondary layer backgrounds (sections, list item backgrounds, page segments).
  static Color section(BuildContext context) => Theme.of(context).colorScheme.surfaceContainerHighest;

  /// Promotional or focused container backgrounds (AI responses, primary highlights).
  static Color highlight(BuildContext context) => Theme.of(context).colorScheme.secondaryContainer;

  /// Error or critical state container backgrounds.
  static Color error(BuildContext context) => Theme.of(context).colorScheme.errorContainer;
}
