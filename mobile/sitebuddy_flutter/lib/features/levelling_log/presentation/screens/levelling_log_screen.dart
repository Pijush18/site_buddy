import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/levelling_log/presentation/providers/levelling_log_provider.dart';
import 'package:site_buddy/features/levelling_log/presentation/widgets/levelling_table.dart';
import 'package:site_buddy/features/levelling_log/presentation/widgets/balance_indicator.dart';
import 'package:site_buddy/features/levelling_log/presentation/widgets/quick_entry_panel.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';

class LevellingLogScreen extends ConsumerWidget {
  const LevellingLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final logState = ref.watch(levellingLogProvider);
    final logNotifier = ref.read(levellingLogProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Filter out the initial empty dummy row
    final visibleEntries = logState.entries
        .where((e) => e.hasReading || e.station != 'STN 1')
        .toList();

    return SbPage.detail(
      title: l10n.levellingLog,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Section 1: Benchmark / Instrument ───────────────────────────
          SbCard(
            child: Column(
              children: [
                SbInput(
                  label: l10n.projectName,
                  initialValue: logState.projectName,
                  onChanged: logNotifier.updateProjectName,
                ),
                AppLayout.vGap16,
                SbInput(
                  label: l10n.benchmarkRL,
                  initialValue: logState.benchmarkRL.toStringAsFixed(3),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) {
                    final rl = double.tryParse(val);
                    if (rl != null) {
                      logNotifier.updateBenchmarkRL(rl);
                    }
                  },
                ),
              ],
            ),
          ),

          AppLayout.vGap24,

          SbCard(
            color: colorScheme.primary,
            child: Column(
              children: [
                Text(
                  l10n.currentReducedLevel.toUpperCase(),
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    letterSpacing: 1.2,
                  ),
                ),
                AppLayout.vGap16,
                Text(
                  logState.entries.where((e) => e.hasReading).isNotEmpty
                      ? '${logState.entries.last.rl?.toStringAsFixed(3) ?? '--.--'} m'
                      : '--.-- m',
                  style: SbTextStyles.headline(context).copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),

          AppLayout.vGap24,

          // ── Section 3: Quick Reading Entry ──────────────────────────────
          QuickEntryPanel(
            onAdd: ({required station, bs, isReading, fs}) {
              logNotifier.addQuickEntry(
                station: station,
                bs: bs,
                isReading: isReading,
                fs: fs,
              );
            },
          ),

          AppLayout.vGap24,

          if (visibleEntries.any((e) => e.hi != null)) ...[
            Center(
              child: SbCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.instrumentHeight.toUpperCase(),
                      style: SbTextStyles.title(context).copyWith(
                        color: colorScheme.secondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    AppLayout.vGap8,
                    Text(
                      '${visibleEntries.lastWhere((e) => e.hi != null).hi?.toStringAsFixed(3) ?? '--.--'} m',
                      style: SbTextStyles.title(context).copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppLayout.vGap24,
          ],

          // ── Section 5: Field Book Table ─────────────────────────────────
          Text(l10n.fieldBook, style: SbTextStyles.title(context)),
          AppLayout.vGap16,
          LevellingTable(
            entries: visibleEntries,
            onEntryDeleted: (idx) {
              final targetEntry = visibleEntries[idx];
              final realIdx = logState.entries.indexOf(targetEntry);
              if (realIdx != -1) logNotifier.removeEntry(realIdx);
            },
          ),

          AppLayout.vGap24,

          // ── Section 6: Balance Check Panel ──────────────────────────────
          BalanceIndicator(
            sumBS: logState.sumBS,
            sumFS: logState.sumFS,
            isBalanced: logState.isBalanced,
            entryCount: visibleEntries.length,
          ),

          AppLayout.vGap24,
        ],
      ),
    );
  }
}
