import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// CLASS: AppScreenWrapper
/// PURPOSE: Standardized layout wrapper for all application screens.
class AppScreenWrapper extends StatelessWidget {
  final Widget? child;
  final List<Widget>? sections;
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final effectiveBackgroundColor = backgroundColor ?? theme.colorScheme.surface;
    final foregroundColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: effectiveBackgroundColor,
      appBar: title != null
          ? AppBar(
              title: Text(
                title!,
                style: textTheme.titleLarge,
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
        bottom: false,
        child: isScrollable
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: usePadding 
                    ? const EdgeInsets.symmetric(
                        horizontal: SbSpacing.lg, 
                        vertical: SbSpacing.lg,
                      ) 
                    : EdgeInsets.zero,
                child: sections != null 
                    ? Column(children: sections!)
                    : child ?? const SizedBox(),
              )
            : Padding(
                padding: usePadding 
                    ? const EdgeInsets.symmetric(
                        horizontal: SbSpacing.lg, 
                        vertical: SbSpacing.lg,
                      ) 
                    : EdgeInsets.zero,
                child: sections != null 
                    ? Column(children: sections!)
                    : child ?? const SizedBox(),
              ),
      ),
    );
  }
}



