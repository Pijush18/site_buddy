import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';

class BalanceIndicator extends StatelessWidget {
  final double sumBS;
  final double sumFS;
  final bool isBalanced;
  final int entryCount;

  const BalanceIndicator({
    super.key,
    required this.sumBS,
    required this.sumFS,
    required this.isBalanced,
    required this.entryCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final statusColor = isBalanced ? Colors.green.shade600 : colorScheme.error;
    final statusText = isBalanced ? 'Balanced' : 'Error';
    final statusIcon = isBalanced ? SbIcons.checkFilled : SbIcons.error;

    if (entryCount < 2) {
      return Container(
        padding: const EdgeInsets.all(AppLayout.cardPadding),
        decoration: AppLayout.sbCommonDecoration(context),
        alignment: Alignment.center,
        child: Text(
          'Waiting for sufficient readings...',
          style: SbTextStyles.body(context).copyWith(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.pMedium,
        vertical: AppLayout.cardPadding,
      ),
      decoration: AppLayout.sbCommonDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'ΣBS', value: sumBS.toStringAsFixed(3)),

          Container(
            width: 1,
            height: 40,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),

          _Stat(label: 'ΣFS', value: sumFS.toStringAsFixed(3)),

          Container(
            width: 1,
            height: 40,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              AppLayout.hGap8,
              Text(
                statusText,
                style: SbTextStyles.caption(context).copyWith(
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: SbTextStyles.caption(context).copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: AppLayout.xs),
        Text(value, style: SbTextStyles.title(context)),
      ],
    );
  }
}