import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';

/// FIX: Get history entries from session - no projectId parameter
final projectHistoryProvider =
    FutureProvider.autoDispose<List<CalculationHistoryEntry>>((ref) {
      // Get projectId from session - throws if no active project
      final projectId = ref
          .read(projectSessionServiceProvider)
          .getActiveProjectId();
      return ref
          .read(sharedHistoryRepositoryProvider)
          .getEntriesByProject(projectId);
    });

class CalculationHistoryScreen extends ConsumerWidget {
  const CalculationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(projectHistoryProvider);

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
            children: [
              for (var i = 0; i < sortedEntries.length; i++) ...[
                _HistoryEntryCard(entry: sortedEntries[i]),
                if (i < sortedEntries.length - 1)
                  const SizedBox(height: SbSpacing.sm),
              ],
            ],
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
      padding: const EdgeInsets.symmetric(
        vertical: SbSpacing.sm,
      ).copyWith(top: 0),
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
      case CalculationType.beam:
        return SbIcons.viewArray;
      case CalculationType.column:
        return SbIcons.viewColumn;
      case CalculationType.slab:
        return SbIcons.layers;
      case CalculationType.footing:
        return SbIcons.foundation;
      case CalculationType.rebar:
        return SbIcons.rebar;
      case CalculationType.cement:
      case CalculationType.brick:
      case CalculationType.plaster:
      case CalculationType.sand:
        return SbIcons.grain;
      case CalculationType.levelLog:
        return SbIcons.terrain;
      case CalculationType.excavation:
        return SbIcons.construction;
      case CalculationType.shuttering:
        return SbIcons.construction;
      case CalculationType.gradient:
        return Icons.auto_graph_rounded;
      case CalculationType.unitConverter:
        return Icons.transform_rounded;
      case CalculationType.currencyConverter:
        return Icons.currency_exchange_rounded;
    }
  }
}
