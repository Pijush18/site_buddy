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
    final selectedIndex = items.indexOf(value);

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppLayout.pSmall),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final buttonWidth = width / items.length;

          return Stack(
            children: [
              // SLIDER (moving highlight)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: selectedIndex * buttonWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppLayout.pSmall - 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // BUTTON LAYER
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items.map((item) {
                  final isSelected = item == value;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isSelected) return;
                        onChanged(item);
                      },
                      child: Center(
                        child: Text(
                          labelBuilder(item),
                          style: SbTextStyles.caption(context).copyWith(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}