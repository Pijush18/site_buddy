import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/features/levelling_log/domain/entities/levelling_entry.dart';

/// FILE HEADER
/// File: levelling_table.dart
/// Feature: levelling_log
/// Layer: widgets
///
/// PURPOSE:
/// Renders the sequential list of levelling entries using a traditional
/// field-book engineering table layout (Station | BS | IS | FS | HI | RL | Remarks).

class LevellingTable extends StatelessWidget {
  final List<LevellingEntry> entries;
  final void Function(int) onEntryDeleted;

  const LevellingTable({
    super.key,
    required this.entries,
    required this.onEntryDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: AppLayout.sbCommonDecoration(context),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 600.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// HEADER ROW
                  Container(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.05),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppLayout.pTiny,
                      vertical: AppLayout.pSmall,
                    ),
                    child: Row(
                      children: [
                        _HeaderCell(l10n.point, flex: 2, alignLeft: true),
                        _HeaderCell(l10n.bs, flex: 2),
                        _HeaderCell(l10n.isReading, flex: 2),
                        _HeaderCell(l10n.fs, flex: 2),
                        _HeaderCell(l10n.hi, flex: 2),
                        _HeaderCell(l10n.rl, flex: 2),
                        _HeaderCell(l10n.rem, flex: 1),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 1.2),

                  /// EMPTY STATE
                  if (entries.isEmpty)
                    Padding(
                      padding: AppLayout.paddingXL,
                      child: Text(
                        l10n.noReadingsYet,
                        textAlign: TextAlign.center,
                        style:
                            SbTextStyles.body(context).copyWith(
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                      ),
                    )

                  /// DATA ROWS
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final entry = entries[index];

                        return _EngineeringTableRow(
                          entry: entry,
                          onDelete: () => onEntryDeleted(index),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final bool alignLeft;

  const _HeaderCell(
    this.label, {
    this.flex = 1,
    this.alignLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: SbTextStyles.caption(context).copyWith(color: Colors.grey.shade700),
        textAlign: alignLeft ? TextAlign.left : TextAlign.right,
      ),
    );
  }
}

class _EngineeringTableRow extends StatelessWidget {
  final LevellingEntry entry;
  final VoidCallback onDelete;

  const _EngineeringTableRow({
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('${entry.station}-${entry.hashCode}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(SbIcons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: _TableRowContent(entry: entry),
    );
  }
}

class _TableRowContent extends StatelessWidget {
  final LevellingEntry entry;

  const _TableRowContent({
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.pTiny,
        vertical: AppLayout.pSmall,
      ),
      child: Row(
        children: [
          /// STATION
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.station,
                    style: SbTextStyles.body(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (entry.fs != null) ...[
                  AppLayout.hGap8,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      l10n.cp,
                      style: SbTextStyles.caption(context).copyWith(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// BS
          Expanded(
            flex: 2,
            child: Text(
              entry.bs != null ? entry.bs!.toStringAsFixed(3) : '',
              style: SbTextStyles.caption(context).copyWith(fontFamily: 'Courier'),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// IS
          Expanded(
            flex: 2,
            child: Text(
              entry.isReading != null
                  ? entry.isReading!.toStringAsFixed(3)
                  : '',
              style: SbTextStyles.caption(context).copyWith(fontFamily: 'Courier'),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// FS
          Expanded(
            flex: 2,
            child: Text(
              entry.fs != null ? entry.fs!.toStringAsFixed(3) : '',
              style: SbTextStyles.caption(context).copyWith(fontFamily: 'Courier'),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// HI
          Expanded(
            flex: 2,
            child: Text(
              entry.hi != null ? entry.hi!.toStringAsFixed(3) : '',
              style: SbTextStyles.caption(context).copyWith(
                color: Colors.grey.shade600,
                fontFamily: 'Courier',
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// RL
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 4,
              ),
              decoration: entry.rl != null
                  ? BoxDecoration(
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.10),
                      border: Border.all(
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(
                        AppLayout.smallRadius,
                      ),
                    )
                  : null,
              child: Text(
                entry.rl != null ? entry.rl!.toStringAsFixed(3) : '',
                style: SbTextStyles.caption(context).copyWith(
                  color: theme.colorScheme.primary,
                  fontFamily: 'Courier',
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          /// REMARKS
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: entry.remark.isNotEmpty
                  ? Tooltip(
                      message: entry.remark,
                      child: Icon(
                        Icons.comment,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}