import 'package:site_buddy/core/design_system/sb_spacing.dart';

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
        margin: const EdgeInsets.only(bottom: SbSpacing.lg, left: SbSpacing.xxl, right: SbSpacing.lg),
        padding: const EdgeInsets.all(SbSpacing.lg),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.xxl, horizontal: SbSpacing.lg),
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












