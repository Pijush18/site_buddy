import 'package:flutter/material.dart';

/// Temporary compatibility class to fix analyzer errors after AppLayout was removed.
/// These values should be migrated to SbSpacing or theme-driven constants in the future.
class AppLayout {
  AppLayout._();

  static const double pMedium = 16.0;
  static const double pSmall = 8.0;
  static const double md = 16.0;
  static const double sm = 8.0;
  static const double elementGap = 12.0;
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double pLarge = 24.0;
  static const double sectionGap = 32.0;
  static const double cardPadding = 16.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightCompact = 32.0;
  static const double iconSize = 24.0;
  
  // Gaps
  static const SizedBox vGap16 = SizedBox(height: 16);
  static const SizedBox hGap16 = SizedBox(width: 16);
  static const SizedBox vGap12 = SizedBox(height: 12);
  static const SizedBox hGap12 = SizedBox(width: 12);
  static const SizedBox vGap8 = SizedBox(height: 8);
  static const SizedBox hGap8 = SizedBox(width: 8);
  static const SizedBox vGap4 = SizedBox(height: 4);
  static const SizedBox hGap4 = SizedBox(width: 4);
  static const SizedBox vGap24 = SizedBox(height: 24);
  static const SizedBox vGap32 = SizedBox(height: 32);

  // Padding
  static const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(24.0);
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  
  // Radius
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





