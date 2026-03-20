import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

class AppScreenWrapper extends StatelessWidget {
  final Widget child;

  const AppScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SbSpacing.lg),
      child: child,
    );
  }
}




