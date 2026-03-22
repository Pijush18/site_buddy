import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/services/project_session_service.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

/// SCREEN: ColumnHistoryScreen
/// PURPOSE: History of all column designs and checks.
class ColumnHistoryScreen extends ConsumerWidget {
  const ColumnHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch projectSessionServiceProvider for reactivity - auto-updates when project switches
    final projectSession = ref.watch(projectSessionServiceProvider);
    final selectedProject = projectSession.getActiveProject();
    final historyRepo = ref.watch(sharedHistoryRepositoryProvider);

    if (selectedProject == null) {
      return const SbPage.scaffold(
        title: ScreenTitles.columnHistory,
        body: SbEmptyState(
          icon: Icons.domain_disabled_outlined,
          title: AppStrings.noProjectSelected,
          subtitle: AppStrings.selectProjectDesc,
        ),
      );
    }

    // DEBUG: Log history fetch
    debugPrint('[History] Fetch for project: ${selectedProject.id}');

    return SbPage.list(
      title: ScreenTitles.columnHistory,
      body: FutureBuilder<List<CalculationHistoryEntry>>(
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
              title: ScreenTitles.columnHistory,
              subtitle: AppStrings.noEntriesFound,
            );
          }

          // Sort by timestamp descending
          columnHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return Column(
            children: columnHistory
                .map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: SbSpacing.lg),
                      child: _HistoryCard(entry: entry),
                    ))
                .toList(),
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
    final dateStr = DateFormat('MMM dd, hh:mm a').format(entry.timestamp);

    return SbListItemTile(
      icon: SbIcons.viewColumn,
      title: entry.resultSummary,
      subtitle: 'ID: ${entry.id.substring(0, 8)}...',
      trailing: dateStr,
      onTap: () {
        context.push('/history-detail', extra: entry);
      },
    );
  }
}





