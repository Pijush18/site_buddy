import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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


    return SbSection(
      title: title,
      child: SbGrid(
        children: items.map((item) {
          return SBGridActionCard(
            icon: item.icon,
            label: item.label,
            onTap: () => context.push(item.route),
          );
        }).toList(),
      ),
    );
  }
}





