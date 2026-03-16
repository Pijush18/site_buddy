import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';

/// Provider to fetch history entries for a specific project.
/// Decouples UI from Repository implementation.
final projectHistoryProvider = FutureProvider.family.autoDispose<List<CalculationHistoryEntry>, String>((ref, projectId) {
  return ref.read(sharedHistoryRepositoryProvider).getEntriesByProject(projectId);
});

class CalculationHistoryScreen extends ConsumerWidget {
  final String projectId;

  const CalculationHistoryScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(projectHistoryProvider(projectId));

    return SbPage.list(
      title: 'Calculation History',
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading history: $err',
            style: SbTextStyles.body(context),
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const SbEmptyState(
              icon: SbIcons.history,
              title: 'No Calculations Yet',
              subtitle: 'Run a structural calculation to see results here.',
            );
          }

          // Sort entries by timestamp descending
          final sortedEntries = List<CalculationHistoryEntry>.from(entries)
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return Column(
            children: sortedEntries
                .map((entry) => _HistoryEntryCard(entry: entry))
                .toList(),
          );
        },
      ),
    );
  }
}

class _HistoryEntryCard extends StatelessWidget {
  final CalculationHistoryEntry entry;

  const _HistoryEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('MMM dd, yyyy - HH:mm').format(entry.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppLayout.md),
      child: SbCard(
        onTap: () {
          context.push('/history-detail', extra: entry);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TypeChip(type: entry.calculationType),
                Text(
                  dateStr,
                  style: SbTextStyles.caption(context).copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppLayout.md),
            Text(entry.resultSummary, style: SbTextStyles.title(context)),
            const SizedBox(height: AppLayout.sm),
            Text(
              'ID: ${entry.id}',
              style: SbTextStyles.caption(context).copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final CalculationType type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color chipColor;
    String label;

    switch (type) {
      case CalculationType.column:
        chipColor = theme.colorScheme.primary;
        label = 'COLUMN';
        break;
      case CalculationType.beam:
        chipColor = theme.colorScheme.secondary;
        label = 'BEAM';
        break;
      case CalculationType.slab:
        chipColor = theme.colorScheme.tertiary;
        label = 'SLAB';
        break;
      case CalculationType.footing:
        chipColor = theme.colorScheme.primary;
        label = 'FOOTING';
        break;
      case CalculationType.levelLog:
        chipColor = theme.colorScheme.secondary;
        label = 'LEVEL LOG';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.sm,
        vertical: AppLayout.xs,
      ),
      
      child: Text(
        label,
        style: SbTextStyles.caption(context).copyWith(
          color: chipColor,
          
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}