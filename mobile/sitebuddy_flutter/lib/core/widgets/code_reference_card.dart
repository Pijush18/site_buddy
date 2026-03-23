

import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';
import 'package:site_buddy/core/models/code_reference.dart';

import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: CodeReferenceCard
/// PURPOSE: Displays a specific IS Code clause Reference for educational context.
class CodeReferenceCard extends StatelessWidget {
  final CodeReference reference;

  const CodeReferenceCard({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SbCard(
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      color: colorScheme.primaryContainer.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, size: 16, color: colorScheme.onSurfaceVariant),

              const SizedBox(width: AppSpacing.sm),
              Text(
                'IS 456:2000 REFERENCE',
                style: textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            reference.title,
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            reference.description,
            style: textTheme.bodyMedium,
          ),
          if (reference.formula != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: SbRadius.borderSmall,
                border: Border.all(
                  color: context.colors.outline,
                  width: AppBorder.width,
                ),
              ),
              child: Center(
                child: Text(
                  reference.formula!,
                  style: textTheme.labelMedium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
