import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';

/// CLASS: SegmentedToggle
/// PURPOSE: Reusable multi-option slider toggle with theme-aware styling.
/// REFINED: Supports any number of options and generic types.
class SegmentedToggle<T> extends StatelessWidget {
  final List<T> items;
  final T value;
  final String Function(T) labelBuilder;
  final Function(T) onChanged;

  const SegmentedToggle({
    super.key,
    required this.items,
    required this.value,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 44, // Professional height (40–44px)
      padding: const EdgeInsets.all(SbSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: SbRadius.borderMedium,
      ),
      child: Row(
        children: items.map((item) {
          final isSelected = item == value;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isSelected) return;
                onChanged(item);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: SbRadius.borderMd,
                  border: isSelected
                      ? Border.all(color: colorScheme.primary, width: 1)
                      : Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                          width: 1,
                        ),
                ),
                child: Center(
                  child: Text(
                    labelBuilder(item),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium!,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}








