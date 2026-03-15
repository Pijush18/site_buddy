import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

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

    final titleStyle =
        SbTextStyles.title(context).copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        );

    final descriptionStyle =
        SbTextStyles.bodySecondary(context).copyWith(color: colorScheme.onSurfaceVariant);

    if (isHorizontal) {
      return SbCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppLayout.lg),
        child: Row(
          children: [
            _buildIconContainer(colorScheme),
            const SizedBox(width: AppLayout.lg),
            Expanded(
              child: _buildTextContent(
                titleStyle,
                descriptionStyle,
                CrossAxisAlignment.start,
              ),
            ),
            Icon(SbIcons.chevronRight, color: colorScheme.outlineVariant),
          ],
        ),
      );
    }

    return SbCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppLayout.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconContainer(colorScheme),
          const SizedBox(height: AppLayout.lg),
          _buildTextContent(
            titleStyle,
            descriptionStyle,
            CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppLayout.sm),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: AppLayout.borderRadiusCard,
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
          const SizedBox(height: 4),
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