import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/structural/shared/application/controllers/safety_check_controller.dart';

class CrackingHistorySection extends ConsumerWidget {
  const CrackingHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref
        .watch(safetyCheckControllerProvider)
        .history
        .where((e) => e['type'] == 'Cracking')
        .toList();

    if (history.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return SbSection(
      title: 'Recent Cracking Checks',
      child: Column(
        children: history.take(3).map((check) {
          final isSafe = check['isSafe'] as bool;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm),
            child: SbCard(
              child: Row(
                children: [
                  Icon(
                    isSafe ? SbIcons.checkFilled : SbIcons.error,
                    color: isSafe ? AppColors.success(context) : Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: SbSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'w: ${check['crackWidth'].toStringAsFixed(3)} mm',
                          style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          DateTime.parse(check['date']).toString().substring(0, 16),
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isSafe ? 'SAFE' : 'FAIL',
                    style: theme.textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSafe ? AppColors.success(context) : theme.colorScheme.error,
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





