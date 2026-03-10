import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_scaffold.dart';

/// A simple widget that ensures every screen uses the same outer padding.
///
/// Screens should wrap their entire body with this widget rather than
/// sprinkling `Padding` widgets around.
class AppScreenWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? footer;

  const AppScreenWrapper({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.pMedium,
            vertical: AppLayout.pMedium,
          ),
          child: child,
        ),
      ),
    );

    if (title != null || footer != null) {
      return AppScaffold(
        title: title,
        actions: actions,
        padding: EdgeInsets.zero,
        bottomNavigationBar: footer != null
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppLayout.pMedium),
                  child: footer,
                ),
              )
            : null,
        body: content,
      );
    }

    return content;
  }
}
