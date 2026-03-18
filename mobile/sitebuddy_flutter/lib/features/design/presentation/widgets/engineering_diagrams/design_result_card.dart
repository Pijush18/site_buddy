import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
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
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm / 2,
        ),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          isSafe ? 'SAFE' : 'UNSAFE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
        ),
      ),
      child: SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: item.isCritical ? statusColor : null,
                              ),
                            ),
                            if (item.unit != null) ...[
                              const SizedBox(width: 4),
                              Text(
                                item.unit!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (codeReference != null) ...[
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 14,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    codeReference!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
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