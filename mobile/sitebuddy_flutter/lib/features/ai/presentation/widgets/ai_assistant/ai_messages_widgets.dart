import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

import 'package:flutter/material.dart';

class UserMessageWidget extends StatelessWidget {
  final String query;

  const UserMessageWidget({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: AppSpacing.lg,
          left: AppSpacing.xxl,
          right: AppSpacing.lg,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: SbRadius.radiusMedium,
            topRight: SbRadius.radiusMedium,
            bottomLeft: SbRadius.radiusMedium,
            bottomRight: SbRadius.radiusSmall,
          ),
        ),
        child: Text(
          query,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ),
    );
  }
}

class AiErrorWidget extends StatelessWidget {
  final String error;

  const AiErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
      child: Center(
        child: Text(
          error,
          style: Theme.of(context).textTheme.bodyLarge!,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}












