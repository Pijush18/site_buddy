import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

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
      padding: const EdgeInsets.all(AppLayout.pTiny),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppLayout.buttonRadius),
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
                  borderRadius: BorderRadius.circular(AppLayout.buttonRadius - 4),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                          width: 1,
                        ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    labelBuilder(item),
                    maxLines: 1,
                    style: SbTextStyles.caption(context).copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
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