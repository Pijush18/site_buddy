import 'package:site_buddy/core/design_system/sb_icons.dart';


import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/branding/branding_provider.dart';

/// WIDGET: AppHeader
/// PURPOSE: Reusable top section used by a number of screens to enforce a
/// consistent title/subtitle layout and common actions (back/share).
class AppHeader extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool showShare;
  final VoidCallback? onBack;
  final VoidCallback? onShare;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.showShare = false,
    this.onBack,
    this.onShare,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.xxl,
        vertical: SbSpacing.xxl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBackButton) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed:
                  onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
            ),
            const SizedBox(width: SbSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                if ((subtitle ?? branding.engineerName).isNotEmpty) ...[
                  SizedBox(height: SbSpacing.xs),
                  Text(
                    subtitle ?? branding.engineerName,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                ],
              ],
            ),
          ),
          if (showShare)
            IconButton(
              icon: const Icon(SbIcons.share),
              onPressed: onShare,
            ),
        ],
      ),
    );
  }
}







