import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppScreenWrapper extends StatelessWidget {
  final Widget child;

  const AppScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: child,
    );
  }
}
