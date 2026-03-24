import 'package:flutter/material.dart';

/// WIDGET: SbListGroup
/// PURPOSE: Standardized container for a vertical list of items.
class SbListGroup extends StatelessWidget {
  final List<Widget> children;
  final bool isSubtle;

  const SbListGroup({
    super.key,
    required this.children,
    this.isSubtle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1)
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
        ],
      ],
    );
  }
}

