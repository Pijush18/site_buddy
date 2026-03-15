import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = isSafe ? colorScheme.primary : colorScheme.error;

    return SbCard(
      padding: AppLayout.paddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              AppLayout.hGap8,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.md,
                  vertical: AppLayout.xs,
                ),
                
                child: Text(
                  isSafe ? 'SAFE' : 'UNSAFE',
                  style: SbTextStyles.caption(context).copyWith(
                    color: statusColor,
                    
                  ),
                ),
              ),
            ],
          ),

          AppLayout.vGap16,

          /// RESULT ITEMS
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: SbTextStyles.body(context).copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      AppLayout.hGap8,
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                item.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: SbTextStyles.title(context).copyWith(
                                  color: item.isCritical
                                      ? statusColor
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (item.unit != null) ...[
                              AppLayout.hGap8,
                              Text(
                                item.unit!,
                                maxLines: 1,
                                style: SbTextStyles.caption(context).copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (item.subtitle != null) ...[
                    AppLayout.vGap4,
                    Text(
                      item.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SbTextStyles.caption(context).copyWith(
                        color: colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          /// CODE REFERENCE
          if (codeReference != null) ...[
            AppLayout.vGap8,
            Divider(height: 1, color: colorScheme.outlineVariant),
            AppLayout.vGap12,
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                AppLayout.hGap8,
                Text(
                  codeReference!,
                  style: SbTextStyles.caption(context).copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    fontStyle: FontStyle.italic,
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