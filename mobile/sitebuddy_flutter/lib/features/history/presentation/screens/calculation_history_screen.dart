import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
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
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const SbEmptyState(
              icon: Icons.history_toggle_off_outlined,
              title: 'No Calculations Found',
              subtitle:
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
    final dateStr = DateFormat('MMM dd, hh:mm a').format(entry.timestamp);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm).copyWith(top: 0),
      child: SbListItemTile(
        icon: _getTypeIcon(entry.calculationType),
        title: entry.resultSummary,
        subtitle: 'ID: ${entry.id.substring(0, 8)}...',
        trailing: dateStr,
        onTap: () {
          context.push('/history-detail', extra: entry);
        },
      ),
    );
  }

  IconData _getTypeIcon(CalculationType type) {
    switch (type) {
      case CalculationType.column:
        return SbIcons.viewColumn;
      case CalculationType.beam:
        return SbIcons.viewArray;
      case CalculationType.slab:
        return SbIcons.layers;
      case CalculationType.footing:
        return SbIcons.foundation;
      case CalculationType.levelLog:
        return SbIcons.layers; // Using layers for level log as well for now
    }
  }
}







