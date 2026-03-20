import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';

class ShearHistorySection extends ConsumerWidget {
  const ShearHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref
        .watch(safetyCheckControllerProvider)
        .history
        .where((e) => e['type'] == 'Shear')
        .toList();

    if (history.isEmpty) return const SizedBox.shrink();

    return SbSection(
      title: 'Recent Shear Checks',
      child: Column(
        children: history.take(3).map((check) {
          final colorScheme = Theme.of(context).colorScheme;
    final isSafe = check['isSafe'] as bool;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: SbCard(
              child: Row(
                children: [
                  Icon(
                    isSafe ? SbIcons.checkFilled : SbIcons.error,
                    color: isSafe ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'τv: ${check['tv'].toStringAsFixed(2)} N/mm²',
                          style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          DateTime.parse(check['date']).toString().substring(0, 16),
                          style: AppTextStyles.caption(context).copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isSafe ? 'SAFE' : 'FAIL',
                    style: AppTextStyles.body(context).copyWith(
                      color: isSafe ? colorScheme.primary : colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
