import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';

/// A standardized loading indicator for the SiteBuddy application.
/// 
/// Provides a centered [CircularProgressIndicator] with an optional message.
class SBLoading extends StatelessWidget {
  /// Optional message to display below the loading indicator.
  final String? message;

  /// Whether the loading indicator should take up the full screen/available space.
  final bool fullScreen;

  const SBLoading({
    super.key,
    this.message,
    this.fullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: TextStyle(
                fontSize: AppFontSizes.tab,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );

    if (fullScreen) {
      return Scaffold(
        body: content,
      );
    }

    return content;
  }
}
