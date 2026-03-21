import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// CLASS: AppScreenWrapper
/// PURPOSE: Per-screen layout shell. Each screen gets its own [Scaffold].
///
/// ARCHITECTURE:
///   - Nested Scaffolds are correct and expected in Flutter.
///   - NavigationShell owns the outer Scaffold (bottom tab bar).
///   - Each screen owns its inner Scaffold (AppBar + body + CTA).
///   - Flutter handles this nesting automatically.
///
/// PARAMETERS:
///   [title]        — AppBar title. If null, no AppBar is rendered.
///   [actions]      — AppBar trailing actions.
///   [bottomAction] — Pinned CTA via [Scaffold.bottomNavigationBar].
///   [isScrollable] — Wraps child in [SingleChildScrollView] when true.
///   [usePadding]   — Applies standard edge insets (SbSpacing.lg).
class AppScreenWrapper extends StatelessWidget {
  final Widget? child;
  final List<Widget>? sections;
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  /// Pinned bottom-bar widget for primary actions (Calculate, Next, etc.).
  /// Rendered via [Scaffold.bottomNavigationBar] so it never scrolls away
  /// and is never hidden by the keyboard.
  final Widget? bottomAction;

  final bool isScrollable;
  final bool usePadding;

  const AppScreenWrapper({
    super.key,
    this.child,
    this.sections,
    this.title,
    this.backgroundColor,
    this.actions,
    this.bottomAction,
    this.isScrollable = false,
    this.usePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surface;
    final foregroundColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: effectiveBackgroundColor,
      resizeToAvoidBottomInset: true,
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
              shape: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1.0,
                ),
              ),
            )
          : null,
      bottomNavigationBar: bottomAction != null
          ? _BottomActionBar(child: bottomAction!)
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

/// Styled bottom bar with top border, matching the app's design system.
class _BottomActionBar extends StatelessWidget {
  final Widget child;
  const _BottomActionBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(SbSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1.0,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
