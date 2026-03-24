import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_border.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/level_log/application/controllers/level_log_controller.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_method.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/core/utils/ui_formatters.dart';

/// SCREEN: LevelLogScreen
/// PURPOSE: Dedicated interface for recording and viewing high-precision level measurements.
/// FIX: projectId now comes from ProjectSessionService only - no constructor parameter
class LevelLogScreen extends ConsumerWidget {
  final String? logId;

  const LevelLogScreen({super.key, this.logId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // FIX: Get projectId from session only - no parameter
    final state = ref.watch(levelLogControllerProvider);
    final notifier = ref.read(levelLogControllerProvider.notifier);

    return SbPage.form(
      title: l10n.levelLogSession,
      appBarActions: [
        IconButton(
          icon: const Icon(SbIcons.add),
          tooltip: l10n.addStation,
          onPressed: notifier.addEntry,
        ),
      ],
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.addStation,
            icon: SbIcons.locationAdd,
            onPressed: notifier.addEntry,
            width: double.infinity,
          ),
          const SizedBox(height: SbSpacing.lg),
          SecondaryButton(
            isOutlined: true,
            label: l10n.exportPdfReport,
            icon: SbIcons.pdf,
            onPressed: notifier.exportReport,
            width: double.infinity,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MethodSelectorCard(state: state, notifier: notifier),
          const SizedBox(height: SbSpacing.lg),
          if (state.entries.isEmpty)
            const _EmptyState()
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < state.entries.length; i++) ...[
                  SbCard(
                    onTap: () => _showEditStationDialog(
                      context,
                      ref,
                      i,
                      state.entries[i],
                    ),
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
                  if (i < state.entries.length - 1)
                    const SizedBox(height: SbSpacing.sm),
                ],
                const SizedBox(height: SbSpacing.xl),
              ],
            ),
        ],
      ),
    );
  }

  void _showEditStationDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    LevelEntry entry,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(levelLogControllerProvider.notifier);

    // Controllers for the dialog fields
    final stationController = TextEditingController(text: entry.station);
    final chainageController = TextEditingController(
      text: entry.chainage?.toString() ?? '',
    );
    final bsController = TextEditingController(text: entry.bs?.toString() ?? '');
    final isController = TextEditingController(
      text: entry.isReading?.toString() ?? '',
    );
    final fsController = TextEditingController(text: entry.fs?.toString() ?? '');
    final remarkController = TextEditingController(text: entry.remark ?? '');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.levelLogSession), // Reusing label for edit
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SbInput(
                    label: 'Station Name',
                    controller: stationController,
                    hint: 'e.g. STN 1',
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: 'Chainage (m)',
                    controller: chainageController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    hint: '0.00',
                  ),
                  const SizedBox(height: SbSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: SbInput(
                          label: 'B.S.',
                          controller: bsController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          hint: '0.000',
                        ),
                      ),
                      const SizedBox(width: SbSpacing.md),
                      Expanded(
                        child: SbInput(
                          label: 'I.S.',
                          controller: isController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          hint: '0.000',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: 'F.S.',
                    controller: fsController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    hint: '0.000',
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: 'Remark',
                    controller: remarkController,
                    hint: 'Optional notes',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final updated = entry.copyWith(
                    station: stationController.text,
                    chainage: double.tryParse(chainageController.text),
                    bs: double.tryParse(bsController.text),
                    isReading: double.tryParse(isController.text),
                    fs: double.tryParse(fsController.text),
                    remark: remarkController.text,
                  );
                  notifier.updateEntry(index, updated);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: SbSpacing.xxl),
          Icon(SbIcons.list, size: 64, color: colorScheme.outlineVariant),
          const SizedBox(height: SbSpacing.md),
          Text(
            l10n.noLevelingLogsYet,
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          const SizedBox(height: SbSpacing.sm),
          Text(
            l10n.tapAddStationToStart,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
        ],
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
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.calculationMethod.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          const SizedBox(height: SbSpacing.lg),
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
              const SizedBox(width: SbSpacing.lg),
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.surface,
          borderRadius: SbRadius.borderSmall,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: AppBorder.width,
          ),
        ),
        child: Center(
          child: Text(label, style: Theme.of(context).textTheme.labelMedium!),
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
            const SizedBox(width: SbSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.station,
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  if (entry.chainage != null)
                    Text(
                      'Ch: ${UiFormatters.chainage(entry.chainage!)}',
                      style: Theme.of(context).textTheme.labelMedium!,
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
        const SizedBox(height: SbSpacing.lg),
        Divider(color: colorScheme.outlineVariant),
        const SizedBox(height: SbSpacing.lg),

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
          const SizedBox(height: SbSpacing.lg),
          Text(entry.remark!, style: Theme.of(context).textTheme.labelMedium!),
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
          Text(label, style: Theme.of(context).textTheme.labelMedium!),
          const SizedBox(height: SbSpacing.sm),
          Text(
            UiFormatters.decimal(value, fractionDigits: 3, fallback: '—'),
            style: Theme.of(context).textTheme.labelMedium!,
          ),
        ],
      ),
    );
  }
}
