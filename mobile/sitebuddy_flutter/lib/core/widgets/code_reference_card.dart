

import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
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
      margin: const EdgeInsets.only(top: SbSpacing.lg),
      color: colorScheme.primaryContainer.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, size: 16, color: colorScheme.primary),
              const SizedBox(width: SbSpacing.sm),
              Text(
                'IS 456:2000 REFERENCE',
                style: textTheme.labelMedium,
              ),
            ],
          ),
          SizedBox(height: SbSpacing.sm),
          Text(
            reference.title,
            style: textTheme.labelMedium,
          ),
          SizedBox(height: SbSpacing.xs),
          Text(
            reference.description,
            style: textTheme.bodyMedium,
          ),
          if (reference.formula != null) ...[
            SizedBox(height: SbSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(SbSpacing.sm),
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
