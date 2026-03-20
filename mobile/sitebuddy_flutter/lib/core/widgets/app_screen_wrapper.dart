import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// CLASS: AppScreenWrapper
/// PURPOSE: Standardized layout wrapper for all application screens.
class AppScreenWrapper extends StatelessWidget {
  final Widget? child;
  final List<Widget>? sections; // Native Layout-Driven Engine
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? footer;
  final bool isScrollable;
  final bool usePadding;

  const AppScreenWrapper({
    super.key,
    this.child,
    this.sections,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: effectiveBackgroundColor,
      appBar: title != null
          ? AppBar(
              title: Text(
                title!,
                style: AppTextStyles.screenTitle(context).copyWith(
                  color: colorScheme.onSurface,
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
              top: false,
              child: footer!,
            )
          : null,
      body: SafeArea(
        bottom: false, // Prevents unintended padding accumulation above bottom navigations natively
        child: isScrollable
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: usePadding 
                    ? const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal, vertical: AppSpacing.screenVertical) 
                    : EdgeInsets.zero,
                child: sections != null 
                    ? Column(children: sections!) // If sections is passed, layout controls it automatically. We use raw column here because we'll rely on SbSection's native margins.
                    : child ?? const SizedBox(),
              )
            : Padding(
                padding: usePadding 
                    ? const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal, vertical: AppSpacing.screenVertical) 
                    : EdgeInsets.zero,
                child: sections != null 
                    ? Column(children: sections!)
                    : child ?? const SizedBox(),
              ),
      ),
    );
  }
}
