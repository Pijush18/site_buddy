import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// Model class for items in the Tool Grid.
class ToolGridItem {
  final IconData icon;
  final String label;
  final String route;

  const ToolGridItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

/// A reusable section containing a grid of tool cards.
class SbToolGridSection extends StatelessWidget {
  final String title;
  final List<ToolGridItem> items;

  const SbToolGridSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SbSection(
      title: title,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: SbSpacing.lg,
          crossAxisSpacing: SbSpacing.lg,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return SbActionTile(
            icon: item.icon,
            label: item.label,
            color: colorScheme.primary,
            isVibrant: true,
            onTap: () => context.push(item.route),
          );
        },
      ),
    );
  }
}




