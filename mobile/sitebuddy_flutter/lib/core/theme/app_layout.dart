import 'package:flutter/material.dart';


/// CLASS: AppLayout
/// PURPOSE: Centralized design tokens for spacing, padding, and radii.
/// Goal: Single source of truth for all layout constants.
class AppLayout {
  AppLayout._();

  // Padding
  static const double pTiny = 4.0;
  static const double xs = pTiny;
  static const double pSmall = 8.0;
  static const double sm = pSmall;
  static const double pMedium = 16.0;
  static const double md = pMedium;
  static const double pLarge = 24.0;
  static const double lg = pLarge;
  static const double pHuge = 32.0;
  static const double xl = pHuge;
  static const double xxl = 48.0;

  // Semantic Sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightCompact = 32.0;
  static const double iconSize = 20.0;
  static const double iconSizeLarge = 64.0;
  static const double avatarSize = 40.0;

  // Standard Spacing Tokens
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 24.0;

  static const double sectionGap = 32.0;
  static const double elementGap = 16.0;
  static const double cardPadding = pMedium;
  static const double maxContentWidth = 800.0;

  static const EdgeInsets paddingSmall = EdgeInsets.all(pSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(pMedium);
  static const EdgeInsets pagePadding = paddingMedium;
  static const EdgeInsets paddingLarge = EdgeInsets.all(pLarge);

  static const double cardRadius = 12.0;
  static const double buttonRadius = 16.0;
  static const double inputRadius = 12.0;
  static const double smallRadius = 4.0;
  // Padding helpers
  static const EdgeInsets paddingSm = EdgeInsets.all(8);
  static const EdgeInsets paddingMd = EdgeInsets.all(12);
  static const EdgeInsets paddingLg = EdgeInsets.all(16);
  static const EdgeInsets paddingXL = EdgeInsets.all(24);

  static final BorderRadius borderRadiusCard = BorderRadius.circular(
    cardRadius,
  );
  static final BorderRadius borderRadiusButton = BorderRadius.circular(
    buttonRadius,
  );
  static final BorderRadius borderRadiusInput = BorderRadius.circular(
    inputRadius,
  );

  // Spacing
  static const double verticalSpace = 16.0;
  static const double horizontalSpace = 16.0;

  static const Widget vGap4 = SizedBox(height: 4.0);
  static const Widget vGap8 = SizedBox(height: 8.0);
  static const SizedBox vGap12 = SizedBox(height: 12);
  static const SizedBox vGap16 = SizedBox(height: 16);
  static const Widget vGap24 = SizedBox(height: 24.0);
  static const Widget vGap32 = SizedBox(height: 32.0);
  static const Widget vGap48 = SizedBox(height: 48.0);
  static const Widget vGap64 = SizedBox(height: 64.0);

  static const Widget hGap8 = SizedBox(width: 8.0);
  static const SizedBox hGap12 = SizedBox(width: 12);
  static const SizedBox hGap16 = SizedBox(width: 16);
  static const SizedBox hGap24 = SizedBox(width: 24);

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration calculationDuration = Duration(milliseconds: 600);

  /// Global bordered card decoration — use on grids, surface cards, and list tiles.
  /// Gives every interactive surface the same clean "Site Buddy" bordered look.
  static BoxDecoration sbCommonDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(cardRadius),
    );
  }

  /// Subtle input decoration — same family but lighter, used on input fields.
  static BoxDecoration sbInputDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(inputRadius),
      border: Border.all(
        color: colorScheme.outline.withValues(alpha: 0.5),
        width: 1.2,
      ),
    );
  }
}
