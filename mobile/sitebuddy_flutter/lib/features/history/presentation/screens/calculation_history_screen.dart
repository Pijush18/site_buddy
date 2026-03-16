import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
import 'package:site_buddy/core/widgets/components/sb_empty_state.dart';
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

    return AppScreenWrapper(
      title: 'Calculation History',
      child: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading history: $err',
            style: const TextStyle(fontSize: AppFontSizes.subtitle),
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const SBEmptyState(
              icon: Icons.history_toggle_off_outlined,
              title: 'No Calculations Found',
              description:
                  'Results from your engineering designs will appear here as you save them.',
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
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: SBCard(
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
                  style: TextStyle(
                    fontSize: AppFontSizes.tab,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.md
            Text(
              entry.resultSummary,
              style: const TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.sm
            Text(
              'ID: ${entry.id}',
              style: TextStyle(
                fontSize: AppFontSizes.tab,
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
        horizontal: AppSpacing.sm, // 8
        vertical: AppSpacing.sm / 2, // Replaced AppLayout.xs (4)
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSizes.tab,
          color: chipColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}