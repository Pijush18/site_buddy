import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
      margin: const EdgeInsets.only(top: AppLayout.pMedium),
      padding: AppLayout.paddingMedium,
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
              const SizedBox(width: AppLayout.pSmall),
              Text(
                'IS 456:2000 REFERENCE',
                style: AppTextStyles.caption(context).copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.pSmall),
          Text(
            reference.title,
            style: AppTextStyles.caption(context).copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppLayout.pTiny),
          Text(
            reference.description,
            style: AppTextStyles.body(context, secondary: true).copyWith(
              fontSize: 11, 
              height: 1.4,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (reference.formula != null) ...[
            const SizedBox(height: AppLayout.pMedium),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppLayout.pSmall),
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