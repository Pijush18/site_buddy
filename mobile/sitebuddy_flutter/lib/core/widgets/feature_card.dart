import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// WIDGET: FeatureCard
/// PURPOSE: Standardized card for feature selection grids across the app.
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback onTap;
  final bool isHorizontal;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final titleStyle = Theme.of(context).textTheme.titleMedium!;

    final descriptionStyle = Theme.of(context).textTheme.bodyMedium!;

    if (isHorizontal) {
      return SbCard(
        onTap: onTap,
        padding: const EdgeInsets.all(SbSpacing.lg),
        child: Row(
          children: [
            _buildIconContainer(context, colorScheme),
            const SizedBox(width: SbSpacing.lg),
            Expanded(
              child: _buildTextContent(
                titleStyle,
                descriptionStyle,
                CrossAxisAlignment.start,
              ),
            ),
            Icon(SbIcons.chevronRight, color: colorScheme.primary),
          ],
        ),
      );
    }

    return SbCard(
      onTap: onTap,
      padding: const EdgeInsets.all(SbSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconContainer(context, colorScheme),
          const SizedBox(height: SbSpacing.xxl),
          _buildTextContent(
            titleStyle,
            descriptionStyle,
            CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(SbSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: colorScheme.primary, size: 24),
    );
  }

  Widget _buildTextContent(
    TextStyle titleStyle,
    TextStyle descriptionStyle,
    CrossAxisAlignment crossAxisAlignment,
  ) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: titleStyle,
          textAlign: crossAxisAlignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (description != null) ...[
          const SizedBox(height: SbSpacing.xs),
          Text(
            description!,
            style: descriptionStyle,
            textAlign: crossAxisAlignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}








