import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';

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

    return SbSection(
      title: 'Recent Deflection Checks',
      child: Column(
        children: history.take(3).map((check) {
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
                          'L/d: ${check['actual'].toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          DateTime.parse(check['date']).toString().substring(0, 16),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isSafe ? 'SAFE' : 'FAIL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSafe ? Colors.green : Colors.red,
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
