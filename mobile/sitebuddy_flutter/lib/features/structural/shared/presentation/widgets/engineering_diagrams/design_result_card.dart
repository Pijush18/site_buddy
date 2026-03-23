import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';



class DesignResultCard extends StatelessWidget {
  final String title;
  final List<DesignResultItem> items;
  final bool isSafe;
  final String? codeReference;

  const DesignResultCard({
    super.key,
    required this.title,
    required this.items,
    required this.isSafe,
    this.codeReference,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = isSafe ? colorScheme.primary : colorScheme.error;

    return SbSection(
      title: title,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SbSpacing.sm,
          vertical: SbSpacing.sm / 2,
        ),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isSafe ? 'SAFE' : 'UNSAFE',
          style: SbTypography.caption.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: SbSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          style: SbTypography.body.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: SbSpacing.lg),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Text(
                              item.value,
                              style: SbTypography.title.copyWith(
                                    color: item.isCritical ? statusColor : colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          if (item.unit != null) ...[
                            const SizedBox(width: SbSpacing.xs),
                            Text(
                              item.unit!,
                              style: SbTypography.caption.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: SbSpacing.xs),
                    Text(
                      item.subtitle!,
                      style: SbTypography.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (codeReference != null) ...[
            const Divider(),
            const SizedBox(height: SbSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(width: SbSpacing.sm),
                Text(
                  codeReference!,
                  style: SbTypography.caption.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}


class DesignResultItem {
  final String label;
  final String value;
  final String? unit;
  final String? subtitle;
  final bool isCritical;

  const DesignResultItem({
    required this.label,
    required this.value,
    this.unit,
    this.subtitle,
    this.isCritical = false,
  });
}







