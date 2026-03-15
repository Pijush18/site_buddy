import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/features/design/application/controllers/safety_check_controller.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT CRACKING CHECKS',
          style: SbTextStyles.caption(context).copyWith(
            color: const Color(0xFF2563EB),

            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: AppLayout.sm),
        ...history
            .take(3)
            .map(
              (check) => AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppLayout.sm),
                  child: Row(
                    children: [
                      Icon(
                        check['isSafe'] ? SbIcons.checkFilled : SbIcons.error,
                        color: check['isSafe'] ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: AppLayout.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'w: ${check['crackWidth'].toStringAsFixed(3)} mm',
                              style: SbTextStyles.bodySecondary(context),
                            ),
                            Text(
                              DateTime.parse(
                                check['date'],
                              ).toString().substring(0, 16),
                              style: SbTextStyles.caption(context).copyWith(color: const Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        check['isSafe'] ? 'SAFE' : 'FAIL',
                        style: SbTextStyles.body(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
