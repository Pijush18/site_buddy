import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';

/// CLASS: AppScreenWrapper
/// PURPOSE: Standardized layout wrapper for all application screens.
///
/// Responsibilities:
/// - Consistent SafeArea handling to avoid system UI overlaps.
/// - Uniform screen padding using [AppSpacing.md] (16.0).
/// - Vertical scrolling via [SingleChildScrollView] for overflow handling.
/// - Optional AppBar title placement using [AppFontSizes.title] (20.0).
/// - Standardized background color based on theme brightness or explicit override.
///
/// REQUIREMENTS:
/// - Must accept a child widget.
/// - Optional title for AppBar.
/// - Uses [AppSpacing] constants.
/// - Fully documented and contains zero business logic.
class AppScreenWrapper extends StatelessWidget {
  /// The main content of the screen.
  final Widget child;

  /// Optional title displayed in the screen's AppBar.
  /// If provided, an AppBar is automatically included.
  final String? title;

  /// Optional background color for the screen.
  /// Defaults to white in light mode and black in dark mode if not provided.
  final Color? backgroundColor;

  /// Optional actions displayed in the AppBar.
  final List<Widget>? actions;

  const AppScreenWrapper({
    super.key,
    required this.child,
    this.title,
    this.backgroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use provided backgroundColor or fall back to theme-specific defaults.
    // Policy: Light Mode = White, Dark Mode = Black.
    final Color effectiveBackgroundColor = backgroundColor ?? (isDark ? Colors.black : Colors.white);
    final Color foregroundColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: effectiveBackgroundColor,
      appBar: title != null
          ? AppBar(
              title: Text(
                title!,
                style: const TextStyle(
                  fontSize: AppFontSizes.title,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: actions,
              backgroundColor: effectiveBackgroundColor,
              foregroundColor: foregroundColor,
              elevation: 0,
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
