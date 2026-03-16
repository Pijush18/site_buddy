import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';

/// SCREEN: ColumnHistoryScreen
/// PURPOSE: History of all column designs and checks.
class ColumnHistoryScreen extends ConsumerWidget {
  const ColumnHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyRepo = ref.watch(sharedHistoryRepositoryProvider);
    final selectedProject = ref.watch(activeProjectProvider);

    if (selectedProject == null) {
      return const AppScreenWrapper(
        title: 'Column History',
        child: SbEmptyState(
          icon: SbIcons.projectOff,
          title: 'No Project Selected',
          subtitle:
              'Please select or create a project to view its calculation history.',
        ),
      );
    }

    return AppScreenWrapper(
      title: 'Column History',
      child: FutureBuilder<List<CalculationHistoryEntry>>(
        future: historyRepo.getEntriesByProject(selectedProject.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allEntries = snapshot.data ?? [];
          final columnHistory = allEntries
              .where((e) => e.calculationType == CalculationType.column)
              .toList();

          if (columnHistory.isEmpty) {
            return const SbEmptyState(
              icon: Icons.history_toggle_off_outlined,
              title: 'No Column History',
              subtitle:
                  'Results from your column calculations will appear here.',
            );
          }

          // Sort by timestamp descending
          columnHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: columnHistory.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            itemBuilder: (context, index) {
              final entry = columnHistory[index];
              return _HistoryCard(entry: entry);
            },
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final CalculationHistoryEntry entry;
  const _HistoryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateStr = DateFormat('MMM dd, yyyy - HH:mm').format(entry.timestamp);

    return SbCard(
      onTap: () {
        context.push('/history-detail', extra: entry);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'COLUMN DESIGN',
                style: TextStyle(
                  fontSize: AppFontSizes.tab,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: AppFontSizes.tab,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          Text(
            entry.resultSummary,
            style: const TextStyle(fontSize: AppFontSizes.subtitle),
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap4 (closest standard)
          Text(
            'ID: ${entry.id.substring(0, 8)}...',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
