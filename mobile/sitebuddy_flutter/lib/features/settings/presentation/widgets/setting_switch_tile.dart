
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// WIDGET: SettingSwitchTile
/// PURPOSE: A reusable switch item for settings screens.
class SettingSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SbListItemTile(
      title: title,
      onTap: () => onChanged(!value),
      trailing: SbSwitch(value: value, onChanged: onChanged),
    );
  }
}



