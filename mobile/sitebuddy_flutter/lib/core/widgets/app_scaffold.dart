import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/branding/branding_provider.dart';

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
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    this.title,
    required this.body, // Fixed missing required
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;
    final colorScheme = Theme.of(context).colorScheme;

    final content = NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          if (title != null)
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: automaticallyImplyLeading,
              leading: automaticallyImplyLeading && context.canPop()
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppLayout.pSmall),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                      ),
                    )
                  : null,
              leadingWidth: automaticallyImplyLeading && context.canPop()
                  ? 56.0 + 8.0
                  : null,
              backgroundColor: colorScheme.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              forceElevated: innerBoxIsScrolled,
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title!,
                    style: AppTextStyles.screenTitle(context).copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    branding.engineerName,
                    style: AppTextStyles.body(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
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
        bottom: false,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: body,
        ),
      ),
    );

    if (hasScaffoldAncestor) {
      return content;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: content,
    );
  }
}