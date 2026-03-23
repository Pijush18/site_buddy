import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';

import 'package:flutter/material.dart';


class SbDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onChanged;
  final String? label;

  const SbDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SbSpacing.sm),

        ],
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(Offset.zero, ancestor: overlay),
                  button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                ),
                Offset.zero & overlay.size,
              );

              showMenu<T>(
                context: context,
                position: position,
                color: colorScheme.surface,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: SbRadius.borderMd,
                  side: BorderSide(
                    color: context.colors.outline,
                    width: AppBorder.width,
                  ),
                ),
                items: items.map((T item) {
                  return PopupMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabelBuilder(item),
                      style: textTheme.bodyLarge,
                    ),
                  );
                }).toList(),
              ).then(onChanged);
            },
            borderRadius: SbRadius.borderMd,
            child: Container(
              height: 44.0,

              padding: const EdgeInsets.symmetric(horizontal: SbSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: SbRadius.borderMd,
                border: Border.all(
                  color: context.colors.outline,
                  width: AppBorder.width,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value != null ? itemLabelBuilder(value as T) : 'Select Option',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge?.copyWith(
                        color: value != null 
                            ? colorScheme.onSurface 
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Icon(
                    SbIcons.chevronDown,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}









