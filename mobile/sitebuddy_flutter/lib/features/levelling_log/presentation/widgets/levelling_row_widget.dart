import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// ----------------------------------------------

import 'package:flutter/material.dart';

///
/// PURPOSE:
/// Reusable engineering table row for data entry of BS, IS, FS, and view for HI, RL.
/// ----------------------------------------------

import 'package:site_buddy/features/levelling_log/domain/entities/levelling_entry.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class LevellingRowWidget extends StatelessWidget {
  final LevellingEntry entry;
  final int index;
  final ValueChanged<LevellingEntry> onChanged;
  final VoidCallback onDelete;

  const LevellingRowWidget({
    super.key,
    required this.entry,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbCard(
      child: Padding(
        padding: const EdgeInsets.all(AppLayout.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Row ${index + 1}: ',
                        style: SbTextStyles.body(context).copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppLayout.sm),
                      Expanded(
                        child: TextFormField(
                          initialValue: entry.station,
                          decoration: const InputDecoration(
                            hintText: 'Station Name',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: SbTextStyles.body(context).copyWith(
                            color: colorScheme.primary,
                          ),
                          onChanged: (val) =>
                              onChanged(entry.copyWith(station: val)),
                        ),
                      ),
                    ],
                  ),
                ),
                SbButton.icon(
                  icon: SbIcons.delete,
                  onPressed: onDelete,
                  tooltip: 'Delete Row',
                ),
              ],
            ),
            const SizedBox(height: AppLayout.elementGap),
            const Divider(),
            const SizedBox(height: AppLayout.elementGap),

            // Data Entry Row
            Row(
              children: [
                Expanded(
                  child: _NumberInput(
                    label: 'BS (m)',
                    value: entry.bs,
                    onChanged: (val) => onChanged(
                      entry.copyWith(bs: val, nullifyBS: val == null),
                    ),
                  ),
                ),
                AppLayout.hGap8,
                Expanded(
                  child: _NumberInput(
                    label: 'IS (m)',
                    value: entry.isReading,
                    onChanged: (val) => onChanged(
                      entry.copyWith(isReading: val, nullifyIS: val == null),
                    ),
                  ),
                ),
                AppLayout.hGap8,
                Expanded(
                  child: _NumberInput(
                    label: 'FS (m)',
                    value: entry.fs,
                    onChanged: (val) => onChanged(
                      entry.copyWith(fs: val, nullifyFS: val == null),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppLayout.cardPadding),

            // Computed Row & Remarks
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: _ComputedValue(label: 'H.I.', value: entry.hi),
                ),
                const SizedBox(width: AppLayout.sm),
                Expanded(
                  flex: 1,
                  child: _ComputedValue(
                    label: 'R.L.',
                    value: entry.rl,
                    highlight: true,
                  ),
                ),
                const SizedBox(width: AppLayout.md),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: entry.remark,
                    decoration: const InputDecoration(
                      labelText: 'Remarks',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      isDense: true,
                    ),
                    style: SbTextStyles.body(context),
                    onChanged: (val) => onChanged(entry.copyWith(remark: val)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberInput extends StatefulWidget {
  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;

  const _NumberInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<_NumberInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void didUpdateWidget(_NumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value?.toString() != oldWidget.value?.toString() &&
        double.tryParse(_controller.text) != widget.value) {
      _controller.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: widget.label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        isDense: true,
      ),
      style: SbTextStyles.body(context),
      onChanged: (val) {
        final parsed = double.tryParse(val);
        if (val.isEmpty) {
          widget.onChanged(null);
        } else if (parsed != null) {
          widget.onChanged(parsed);
        }
      },
    );
  }
}

class _ComputedValue extends StatelessWidget {
  final String label;
  final double? value;
  final bool highlight;

  const _ComputedValue({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valStr = value?.toStringAsFixed(3) ?? '—';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SbTextStyles.caption(context).copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppLayout.xs),
        Text(
          valStr,
          style: SbTextStyles.body(context).copyWith(
            color: highlight ? theme.colorScheme.primary : null,
          ),
        ),
      ],
    );
  }
}