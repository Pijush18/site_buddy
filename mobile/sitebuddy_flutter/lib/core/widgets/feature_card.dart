import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// ENUM: FeatureCardVariant
/// PURPOSE: Defines the tiered visual hierarchy for features.
enum FeatureCardVariant {
  /// Primary emphasis: High contrast, dominant brand color.
  primary,
  /// Secondary emphasis: Balanced contrast, standard interface weight.
  secondary,
  /// Subtle emphasis: Low contrast, receding visual weight for minor tools.
  subtle,
}

/// WIDGET: FeatureCard
/// PURPOSE: Multi-variant card for feature selection with tiered hierarchy.
/// REFINEMENT: Premium product finish with micro-alignment and tonal depth.
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback onTap;
  final bool isHorizontal;
  final bool isTile;
  final FeatureCardVariant variant;
  final bool isFeatured;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.onTap,
    this.isHorizontal = false,
    this.isTile = false,
    this.variant = FeatureCardVariant.secondary,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // TIERED TYPOGRAPHY: Increased visual confidence through heavier weights
    final titleStyle = theme.textTheme.titleMedium!.copyWith(
      fontSize: isFeatured ? 15 : 14,
      fontWeight: variant == FeatureCardVariant.primary ? FontWeight.w800 : FontWeight.w600,
      color: variant == FeatureCardVariant.primary ? colorScheme.primary : colorScheme.onSurface,
      letterSpacing: -0.2,
      height: 1.25,
    );
    
    final descriptionStyle = theme.textTheme.bodyMedium!.copyWith(
      fontSize: 12,
      height: 1.4,
      color: variant == FeatureCardVariant.subtle 
          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5) 
          : colorScheme.onSurfaceVariant,
    );

    final content = isHorizontal ? _buildHorizontalContent(context, colorScheme, titleStyle, descriptionStyle)
                                 : _buildVerticalContent(context, colorScheme, titleStyle, descriptionStyle);

    if (isTile) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(isFeatured ? SbSpacing.lg : SbSpacing.md),
            child: content,
          ),
        ),
      );
    }

    return SbCard(
      onTap: onTap,
      isElevated: variant == FeatureCardVariant.primary,
      isSubtle: variant == FeatureCardVariant.subtle,
      padding: EdgeInsets.all(isFeatured ? SbSpacing.lg : SbSpacing.md),
      child: content,
    );
  }

  Widget _buildHorizontalContent(
    BuildContext context, 
    ColorScheme colorScheme, 
    TextStyle titleStyle, 
    TextStyle descriptionStyle
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Micro-alignment focus
      children: [
        _buildIconContainer(context, colorScheme),
        const SizedBox(width: SbSpacing.md),
        Expanded(
          child: _buildTextContent(colorScheme, titleStyle, descriptionStyle, CrossAxisAlignment.start),
        ),
        Icon(
          SbIcons.chevronRight, 
          color: variant == FeatureCardVariant.primary ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.6),
          size: 18,
        ),
      ],
    );
  }

  Widget _buildVerticalContent(
    BuildContext context, 
    ColorScheme colorScheme, 
    TextStyle titleStyle, 
    TextStyle descriptionStyle
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconContainer(context, colorScheme),
        SizedBox(height: isFeatured ? SbSpacing.md : SbSpacing.sm), // Tighter internal gaps
        _buildTextContent(colorScheme, titleStyle, descriptionStyle, CrossAxisAlignment.center),
      ],
    );
  }

  Widget _buildIconContainer(BuildContext context, ColorScheme colorScheme) {
    // ICON SYSTEM REFINEMENT: Micro-aligned centering and tiered weights
    double opacity;
    switch (variant) {
      case FeatureCardVariant.primary: opacity = 0.22; break; // Stronger primary weigh
      case FeatureCardVariant.secondary: opacity = 0.14; break;
      case FeatureCardVariant.subtle: opacity = 0.08; break;
    }

    return Container(
      width: isFeatured ? 52 : 44,
      height: isFeatured ? 52 : 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (variant == FeatureCardVariant.primary ? colorScheme.primary : colorScheme.onSurfaceVariant)
            .withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(isFeatured ? 16 : 14),
      ),
      child: Icon(
        icon, 
        color: variant == FeatureCardVariant.primary ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
        size: isFeatured ? 28 : 22,
      ),
    );
  }

  Widget _buildTextContent(
    ColorScheme colorScheme,
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
          textAlign: crossAxisAlignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (description != null) ...[
          const SizedBox(height: SbSpacing.xxs),
          Text(
            description!,
            style: descriptionStyle,
            textAlign: crossAxisAlignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
