
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// WidGET: SettingTile
/// PURPOSE: A reusable list item for settings screens with icon support and responsive layout.
class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SbListItem(
      leading: icon != null ? Icon(icon) : null,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
