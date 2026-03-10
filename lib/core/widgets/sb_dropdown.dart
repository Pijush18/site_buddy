import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
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
          style: SbTextStyles.body(context).copyWith(color: colorScheme.onSurface),
          dropdownColor: colorScheme.surface,
          borderRadius: AppLayout.borderRadiusInput,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabelBuilder(item),
                style: SbTextStyles.body(context).copyWith(color: colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}