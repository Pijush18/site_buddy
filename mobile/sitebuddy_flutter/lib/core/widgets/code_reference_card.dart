import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/models/code_reference.dart';

/// WIDGET: CodeReferenceCard
/// PURPOSE: Displays a specific IS Code clause Reference for educational context.
class CodeReferenceCard extends StatelessWidget {
  final CodeReference reference;

  const CodeReferenceCard({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: SbSpacing.lg),
      padding: const EdgeInsets.all(SbSpacing.lg),
      decoration: AppLayout.sbCommonDecoration(context).copyWith(
        color: colorScheme.primaryContainer.withOpacity(0.1),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, size: 16, color: colorScheme.primary),
              const SizedBox(width: SbSpacing.sm),
              Text(
                'IS 456:2000 REFERENCE',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.sm),
          Text(
            reference.title,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.xs),
          Text(
            reference.description,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          if (reference.formula != null) ...[
            const SizedBox(height: SbSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(SbSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  reference.formula!,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}









