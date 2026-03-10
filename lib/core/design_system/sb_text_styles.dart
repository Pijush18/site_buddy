import 'package:flutter/material.dart';

/// CLASS: SbTextStyles
/// PURPOSE: Centralized semantic typography system for caching ThemeData lookups.
class SbTextStyles {
  SbTextStyles._();

  static TextStyle headline(BuildContext context) => Theme.of(context).textTheme.headlineSmall ?? const TextStyle();
  static TextStyle headlineLarge(BuildContext context) => Theme.of(context).textTheme.headlineLarge ?? const TextStyle();
  static TextStyle title(BuildContext context) => Theme.of(context).textTheme.titleMedium ?? const TextStyle();
  static TextStyle body(BuildContext context) => Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
  static TextStyle bodySecondary(BuildContext context) => Theme.of(context).textTheme.bodySmall ?? const TextStyle();
  static TextStyle caption(BuildContext context) => Theme.of(context).textTheme.labelMedium ?? const TextStyle();
  static TextStyle button(BuildContext context) => Theme.of(context).textTheme.labelLarge ?? const TextStyle();
}
