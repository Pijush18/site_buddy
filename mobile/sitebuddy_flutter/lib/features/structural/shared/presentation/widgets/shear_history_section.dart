
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/structural/shared/application/controllers/safety_check_controller.dart';

class ShearHistorySection extends ConsumerWidget {
  const ShearHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
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
    final isSafe = check['isSafe'] as bool;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm),
            child: SbCard(
              child: Row(
                children: [
                  Icon(
                    isSafe ? SbIcons.checkFilled : SbIcons.error,
                    color: isSafe ? colorScheme.primary : colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: SbSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'τv: ${check['tv'].toStringAsFixed(2)} N/mm²',
                          style: Theme.of(context).textTheme.labelMedium!,
                        ),
                        Text(
                          DateTime.parse(check['date']).toString().substring(0, 16),
                          style: Theme.of(context).textTheme.labelMedium!,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isSafe ? 'SAFE' : 'FAIL',
                    style: Theme.of(context).textTheme.bodyLarge!,
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









