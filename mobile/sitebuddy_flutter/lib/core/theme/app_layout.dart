import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// DEPRECATED: Use SbSpacing directly.
/// Aliased compatibility class to fix analyzer errors after AppLayout was removed.
@Deprecated('Use SbSpacing instead')
class AppLayout {
  AppLayout._();

  static const double pMedium = SbSpacing.lg;
  static const double pSmall = SbSpacing.sm;
  static const double md = SbSpacing.lg;
  static const double sm = SbSpacing.sm;
  static const double elementGap = SbSpacing.md;
  static const double spaceXS = SbSpacing.xs;
  static const double spaceS = SbSpacing.sm;
  static const double spaceM = SbSpacing.lg;
  static const double spaceL = SbSpacing.xxl;
  static const double spaceXL = SbSpacing.xxxl;
  static const double pLarge = SbSpacing.xxl;
  static const double sectionGap = SbSpacing.xxxl;
  static const double cardPadding = SbSpacing.lg;
  static const double buttonHeight = 48.0;
  static const double buttonHeightCompact = 32.0;
  static const double iconSize = 24.0;
  
  // Gaps
  static const SizedBox vGap16 = SizedBox(height: SbSpacing.lg);
  static const SizedBox hGap16 = SizedBox(width: SbSpacing.lg);
  static const SizedBox vGap12 = SizedBox(height: SbSpacing.md);
  static const SizedBox hGap12 = SizedBox(width: SbSpacing.md);
  static const SizedBox vGap8 = SizedBox(height: SbSpacing.sm);
  static const SizedBox hGap8 = SizedBox(width: SbSpacing.sm);
  static const SizedBox vGap4 = SizedBox(height: SbSpacing.xs);
  static const SizedBox hGap4 = SizedBox(width: SbSpacing.xs);
  static const SizedBox vGap24 = SizedBox(height: SbSpacing.xxl);
  static const SizedBox vGap32 = SizedBox(height: SbSpacing.xxxl);

  // Padding
  static const EdgeInsets paddingSmall = SbSpacing.paddingSM;
  static const EdgeInsets paddingMedium = SbSpacing.paddingLG;
  static const EdgeInsets paddingLarge = SbSpacing.paddingXL;
  static const EdgeInsets pagePadding = SbSpacing.paddingLG;
  
  // Radius (These should eventually move to SbRadius)
  static const double cardRadius = 12.0;
  static const double buttonRadius = 16.0;
  static const double inputRadius = 12.0;
  static final BorderRadius borderRadiusCard = BorderRadius.circular(cardRadius);
  static final BorderRadius borderRadiusButton = BorderRadius.circular(buttonRadius);
  static final BorderRadius borderRadiusInput = BorderRadius.circular(inputRadius);

  static BoxDecoration sbCommonDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: borderRadiusCard,
    );
  }
}





