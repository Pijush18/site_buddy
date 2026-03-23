import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: SbDiagramCard
/// PURPOSE: Standardized card wrapper for engineering diagrams.
/// FEATURES:
/// - Wraps diagram content with consistent styling
/// - Optional title header
/// - Clip behavior for diagram overflow
class SbDiagramCard extends StatelessWidget {
  /// The diagram widget to display
  final Widget child;

  /// Optional title to display at the top
  final String? title;

  /// Whether to fill available space
  final bool expanded;

  const SbDiagramCard({
    super.key,
    required this.child,
    this.title,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(SbSpacing.sm),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        if (expanded)
          Expanded(child: child)
        else
          child,
      ],
    );

    return SbCard(
      padding: EdgeInsets.zero,
      child: ClipRect(
        child: content,
      ),
    );
  }
}
