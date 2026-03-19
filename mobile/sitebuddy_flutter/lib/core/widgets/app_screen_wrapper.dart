import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';

/// CLASS: AppScreenWrapper
/// PURPOSE: Standardized layout wrapper for all application screens.
class AppScreenWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? footer;
  final bool isScrollable;
  final bool usePadding;

  const AppScreenWrapper({
    super.key,
    required this.child,
    this.title,
    this.backgroundColor,
    this.actions,
    this.footer,
    this.isScrollable = true,
    this.usePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    // Policy: Use the standard surface color from the theme (now white in light, slate in dark).
    final Color effectiveBackgroundColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final Color foregroundColor = Theme.of(context).colorScheme.onSurface;

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
      bottomNavigationBar: footer != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: footer,
              ),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: isScrollable
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: usePadding ? const EdgeInsets.all(AppSpacing.md) : EdgeInsets.zero,
                child: child,
              )
            : Padding(
                padding: usePadding ? const EdgeInsets.all(AppSpacing.md) : EdgeInsets.zero,
                child: child,
              ),
      ),
    );
  }
}
