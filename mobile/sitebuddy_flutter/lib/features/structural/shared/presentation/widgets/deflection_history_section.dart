import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/structural/shared/application/controllers/safety_check_controller.dart';

class DeflectionHistorySection extends ConsumerWidget {
  const DeflectionHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref
        .watch(safetyCheckControllerProvider)
        .history
        .where((e) => e['type'] == 'Deflection')
        .toList();

    if (history.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return SbSection(
      title: 'Recent Deflection Checks',
      child: Column(
        children: history.take(3).map((check) {
          final isSafe = check['isSafe'] as bool;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: SbCard(
              child: Row(
                children: [
                  Icon(
                    isSafe ? SbIcons.checkFilled : SbIcons.error,
                    color: isSafe ? theme.colorScheme.primary : theme.colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'L/d: ${check['actual'].toStringAsFixed(2)}',
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
                      color: isSafe ? theme.colorScheme.primary : theme.colorScheme.error,
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





