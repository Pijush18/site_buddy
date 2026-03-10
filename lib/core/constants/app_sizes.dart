/// FILE HEADER
/// PURPOSE: Defines all standard spacing and border radii used in the app.
/// FUTURE IMPROVEMENTS: Add responsive sizing helpers if deployed to tablets.
library;


import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  // Global Settings
  static const double screenPadding = 16.0;
  static const double screenPaddingPremium = 20.0;

  // Strict Design System Sizes
  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 12.0;
  static const double lg = 16.0;

  // Heritage spacing mappings (to systematically migrate away from if desired)
  static const double p6 = 6.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p24 = 24.0;

  // Radii
  static const double radiusInput = 12.0;
  static const double radiusCard = 12.0;
  static const double radiusCardPremium = 14.0;
  static const double radiusButton = 16.0;

  // SizedBoxes for vertical spacing
  static const gapXs = SizedBox(height: xs);
  static const gapSm = SizedBox(height: sm);
  static const gapMd = SizedBox(height: md);
  static const gapLg = SizedBox(height: lg);
  static const gap6 = SizedBox(height: p6);
  static const gap8 = SizedBox(height: p8);
  static const gap12 = SizedBox(height: p12);
  static const gap16 = SizedBox(height: p16);
  static const gap18 = SizedBox(height: 18.0);
  static const gap24 = SizedBox(height: p24);

  // SizedBoxes for horizontal spacing
  static const gapWXs = SizedBox(width: xs);
  static const gapWSm = SizedBox(width: sm);
  static const gapWMd = SizedBox(width: md);
  static const gapWLg = SizedBox(width: lg);
  static const gapW6 = SizedBox(width: p6);
  static const gapW8 = SizedBox(width: p8);
  static const gapW12 = SizedBox(width: p12);
  static const gapW16 = SizedBox(width: p16);
  static const gapW24 = SizedBox(width: p24);
}
