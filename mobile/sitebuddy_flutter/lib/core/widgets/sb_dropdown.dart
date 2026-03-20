import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';


class SbDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onChanged;

  const SbDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppLayout.borderRadiusInput,
        border: Border.all(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(
            SbIcons.chevronDown,
            color: colorScheme.onSurfaceVariant,
          ),
          style: Theme.of(context).textTheme.bodyLarge!,
          dropdownColor: colorScheme.surface,
          borderRadius: AppLayout.borderRadiusInput,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabelBuilder(item),
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}









