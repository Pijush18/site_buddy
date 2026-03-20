import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
        margin: const EdgeInsets.only(bottom: AppSpacing.md, left: AppSpacing.xl, right: AppSpacing.md),
        padding: AppLayout.paddingMedium,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          query,
          style: AppTextStyles.body(context).copyWith(
            color: colorScheme.onPrimary,
          ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      child: Center(
        child: Text(
          error,
          style: AppTextStyles.body(context).copyWith(
            color: colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}