import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/level_log/application/controllers/level_log_controller.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_method.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/core/utils/ui_formatters.dart';

/// SCREEN: LevelLogScreen
/// PURPOSE: Dedicated interface for recording and viewing high-precision level measurements.
class LevelLogScreen extends ConsumerWidget {
  final String? logId;
  final String projectId;

  const LevelLogScreen({super.key, this.logId, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(levelLogControllerProvider);
    final notifier = ref.read(levelLogControllerProvider.notifier);

    return AppScreenWrapper(
      title: l10n.levelLogSession,
      actions: [
        IconButton(
          icon: const Icon(SbIcons.add),
          tooltip: l10n.addStation,
          onPressed: notifier.addEntry,
        ),
      ],
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: l10n.addStation,
            icon: SbIcons.locationAdd,
            onPressed: notifier.addEntry,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          SbButton.outline(
            label: l10n.exportPdfReport,
            icon: SbIcons.pdf,
            onPressed: notifier.exportReport,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Method selector ──────────────────────────────
          _MethodSelectorCard(state: state, notifier: notifier),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          // ── Station list OR empty state ──────────
          if (state.entries.isEmpty)
            const _EmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.entries.length,
              separatorBuilder: (_, index) => const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
              itemBuilder: (context, i) => SbCard(
                child: _StationCardContent(
                  entry: state.entries[i],
                  index: i,
                  method: state.method,
                  colorScheme: colorScheme,
                  onDelete: state.entries.length > 1
                      ? () => notifier.removeEntry(i)
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              SbIcons.list,
              size: 64,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            Text(
              l10n.noLevelingLogsYet,
              style: const TextStyle(
                fontSize: AppFontSizes.subtitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
            Text(
              l10n.tapAddStationToStart,
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodSelectorCard extends StatelessWidget {
  final LevelLogState state;
  final LevelLogController notifier;

  const _MethodSelectorCard({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.calculationMethod.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          Row(
            children: [
              Expanded(
                child: _MethodToggle(
                  label: l10n.hiMethod,
                  isActive: state.method == LevelMethod.heightOfInstrument,
                  onTap: () =>
                      notifier.setMethod(LevelMethod.heightOfInstrument),
                ),
              ),
              const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
              Expanded(
                child: _MethodToggle(
                  label: l10n.riseFall,
                  isActive: state.method == LevelMethod.riseFall,
                  onTap: () => notifier.setMethod(LevelMethod.riseFall),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MethodToggle extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MethodToggle({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              fontWeight: FontWeight.bold,
              color: isActive ? colorScheme.onPrimary : colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StationCardContent extends StatelessWidget {
  final LevelEntry entry;
  final int index;
  final LevelMethod method;
  final ColorScheme colorScheme;
  final VoidCallback? onDelete;

  const _StationCardContent({
    required this.entry,
    required this.index,
    required this.method,
    required this.colorScheme,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  SbIcons.location,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.station,
                    style: const TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (entry.chainage != null)
                    Text(
                      'Ch: ${UiFormatters.chainage(entry.chainage!)}',
                      style: TextStyle(
                        fontSize: AppFontSizes.tab,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(SbIcons.delete, size: 20),
                onPressed: onDelete,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
        Divider(color: colorScheme.outlineVariant),
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

        Row(
          children: [
            _ReadingPill(
              label: l10n.bs,
              value: entry.bs,
              colorScheme: colorScheme,
            ),
            _ReadingPill(
              label: l10n.isReading,
              value: entry.isReading,
              colorScheme: colorScheme,
            ),
            _ReadingPill(
              label: l10n.fs,
              value: entry.fs,
              colorScheme: colorScheme,
            ),
            if (method == LevelMethod.heightOfInstrument)
              _ReadingPill(
                label: l10n.hi,
                value: entry.hi,
                colorScheme: colorScheme,
              ),
            _ReadingPill(
              label: l10n.rl,
              value: entry.rl,
              colorScheme: colorScheme,
              highlight: true,
            ),
          ],
        ),

        if (entry.remark != null && entry.remark!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          Text(
            entry.remark!,
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

class _ReadingPill extends StatelessWidget {
  final String label;
  final double? value;
  final ColorScheme colorScheme;
  final bool highlight;

  const _ReadingPill({
    required this.label,
    required this.value,
    required this.colorScheme,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm / 2), // Replaced AppLayout.vGap8
          Text(
            UiFormatters.decimal(value, fractionDigits: 3, fallback: '—'),
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight
                  ? colorScheme.primary
                  : (value != null ? null : colorScheme.outlineVariant),
            ),
          ),
        ],
      ),
    );
  }
}