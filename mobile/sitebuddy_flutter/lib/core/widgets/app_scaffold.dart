import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: app_scaffold.dart
/// Feature: core (design system)
/// Layer: presentation/widgets
///
/// PURPOSE:
/// Premium reusable scaffold system providing an app-wide standardized layout,
/// adhering to "Site Buddy" architectural and UI rules.
/// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/branding/branding_provider.dart';
import 'package:site_buddy/core/constants/ui_elevation.dart';

/// CLASS: AppScaffold
/// Standard layout shell for screens, injecting safe areas and standard padding.
class AppScaffold extends ConsumerWidget {
  final String? title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final EdgeInsetsGeometry? padding;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    final content = NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        final colorScheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return [
          if (title != null)
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: automaticallyImplyLeading,
              leading: automaticallyImplyLeading && context.canPop()
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: AppLayout.pSmall,
                      ), // Adds to internal default to reach 16px visual edge
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                      ),
                    )
                  : null,
              leadingWidth: automaticallyImplyLeading && context.canPop()
                  ? 56.0 + 8.0
                  : null,
              backgroundColor: isDark
                  ? Theme.of(context).colorScheme.surface
                  : colorScheme.surface,
              elevation: innerBoxIsScrolled
                  ? AppElevation.level2
                  : AppElevation.level0,
              scrolledUnderElevation: AppElevation.level0,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.black.withValues(alpha: isDark ? 0.5 : 0.1),
              forceElevated: innerBoxIsScrolled,
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title!,
                    style: SbTextStyles.headline(context).copyWith(
                      color: isDark ? Colors.white : colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    branding.engineerName,
                    style: SbTextStyles.body(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: actions,
            ),
        ];
      },
      body: SafeArea(
        top: title == null,
        bottom: true,
        child: body,
      ),
    );

    if (hasScaffoldAncestor) {
      return content;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: content,
    );
  }
}