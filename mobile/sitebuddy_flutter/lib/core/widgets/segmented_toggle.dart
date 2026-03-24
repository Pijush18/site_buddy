import 'package:flutter/material.dart';

import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/theme/app_border.dart';

/// CLASS: SegmentedToggle
/// PURPOSE: Unified, production-grade segmented control system.
/// ENFORCEMENT: 36px height, zero-gap, strict state colors.
class SegmentedToggle<T> extends StatelessWidget {
  final List<T> items;
  final T value;
  final String Function(T) labelBuilder;
  final Function(T) onChanged;
  final double? width;

  const SegmentedToggle({
    super.key,
    required this.items,
    required this.value,
    required this.labelBuilder,
    required this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 36,
      width: width,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer, // Solid unselected base
        borderRadius: BorderRadius.circular(SbRadius.standard),
        border: Border.all(
          color: colorScheme.outline,
          width: AppBorder.width,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                ),
                child: Text(
                  labelBuilder(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? colorScheme.onPrimary 
                        : colorScheme.onSurface,
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
