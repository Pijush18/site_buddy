import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_list_item_tile.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

class ProjectCard extends StatelessWidget {
  final String name;
  final String date;
  final String location;
  final int logsCount;
  final int calcsCount;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.name,
    required this.date,
    required this.location,
    required this.logsCount,
    required this.calcsCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SbListItemTile(
      icon: SbIcons.terrain,
      title: name,
      subtitle: '$date • $location',
      trailing: Icon(
        Icons.chevron_right,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant, // 👈 Softened trailing icon
      ),
      onTap: onTap ?? () {},
    );
  }
}
