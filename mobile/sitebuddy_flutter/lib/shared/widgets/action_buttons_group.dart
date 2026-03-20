import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

class ActionButtonsGroup extends StatelessWidget {
  final List<Widget> children;

  const ActionButtonsGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SbSpacing.lg,
      runSpacing: SbSpacing.lg,
      children: children.map((child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 140,
            maxWidth: 220,
          ),
          child: child,
        );
      }).toList(),
    );
  }
}




