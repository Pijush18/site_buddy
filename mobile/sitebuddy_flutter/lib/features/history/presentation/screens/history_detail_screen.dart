import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final CalculationHistoryEntry entry;

  const HistoryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('MMM dd, yyyy - HH:mm').format(entry.timestamp);

    return SbPage.detail(
      title: 'History Detail',
      body: SbSectionList(
        sections: [
          SbSection(
            child: _buildHeader(context, dateStr),
          ),
          SbSection(
            title: 'Input Parameters',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildParametersList(context),
                const SizedBox(height: SbSpacing.xxl),
                SbButton.primary(
                  onPressed: () => _restoreVersion(context, ref),
                  label: 'Restore this Version',
                  width: double.infinity,
                ),
                const SizedBox(height: SbSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String dateStr) {
    return SbCard(
      child: Column(
        children: [
          Text(
            entry.calculationType.name.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const Divider(height: SbSpacing.lg), // Replaced Divider(16)
          const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
          Text(
            entry.resultSummary,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
          Text(
            dateStr,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
        ],
      ),
    );
  }

  Widget _buildParametersList(BuildContext context) {
    final params = entry.inputParameters;
    if (params.isEmpty) {
      return Text(
        'No parameters recorded.',
        style: Theme.of(context).textTheme.bodyLarge!,
      );
    }

    return Column(
      children: params.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: SbSpacing.sm),
          child: SbListItemTile(
            title: e.key,
            onTap: () {}, // Immutable detail view
            trailing: Text(
              e.value.toString(),
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _restoreVersion(BuildContext context, WidgetRef ref) {
    final params = entry.inputParameters;

    switch (entry.calculationType) {
      case CalculationType.column:
        ref
            .read(columnDesignControllerProvider.notifier)
            .restore(
              ColumnDesignState(
                projectId: entry.projectId,
                type: params['type'] != null
                    ? ColumnType.values[params['type']]
                    : ColumnType.rectangular,
                b: (params['b'] as num?)?.toDouble() ?? 300.0,
                d: (params['d'] as num?)?.toDouble() ?? 300.0,
                length: (params['length'] as num?)?.toDouble() ?? 3000.0,
                pu: (params['pu'] as num?)?.toDouble() ?? 1000.0,
                mx: (params['mx'] as num?)?.toDouble() ?? 0.0,
                my: (params['my'] as num?)?.toDouble() ?? 0.0,
              ),
            );
        break;

      case CalculationType.beam:
        ref
            .read(beamDesignControllerProvider.notifier)
            .restore(
              BeamDesignState(
                projectId: entry.projectId,
                span: (params['span'] as num?)?.toDouble() ?? 4000.0,
                width: (params['width'] as num?)?.toDouble() ?? 230.0,
                overallDepth: (params['depth'] as num?)?.toDouble() ?? 450.0,
                deadLoad: (params['deadLoad'] as num?)?.toDouble() ?? 10.0,
                liveLoad: (params['liveLoad'] as num?)?.toDouble() ?? 5.0,
                pointLoad: (params['pointLoad'] as num?)?.toDouble() ?? 0.0,
              ),
            );
        break;

      case CalculationType.slab:
        ref
            .read(slabDesignControllerProvider.notifier)
            .restore(
              SlabDesignState(
                projectId: entry.projectId,
                lx: (params['lx'] as num?)?.toDouble() ?? 4.0,
                ly: (params['ly'] as num?)?.toDouble() ?? 6.0,
                d: (params['d'] as num?)?.toDouble() ?? 150.0,
                deadLoad: (params['deadLoad'] as num?)?.toDouble() ?? 1.0,
                liveLoad: (params['liveLoad'] as num?)?.toDouble() ?? 2.0,
              ),
            );
        break;

      case CalculationType.footing:
        ref
            .read(footingDesignControllerProvider.notifier)
            .restore(
              FootingDesignState(
                projectId: entry.projectId,
                columnLoad:
                    (params['columnLoad'] as num?)?.toDouble() ?? 1000.0,
                sbc: (params['sbc'] as num?)?.toDouble() ?? 200.0,
                footingLength: (params['length'] as num?)?.toDouble() ?? 2.0,
                footingWidth: (params['width'] as num?)?.toDouble() ?? 2.0,
                footingThickness:
                    (params['thickness'] as num?)?.toDouble() ?? 500.0,
                columnSpacing: (params['spacing'] as num?)?.toDouble() ?? 0.0,
              ),
            );
        break;

      case CalculationType.levelLog:
        SbFeedback.showToast(
          context: context,
          message:
              'Level Log versioning is handled via the Project Saved Sessions.',
        );
        return;
    }

    SbFeedback.showToast(
      context: context,
      message: '${entry.calculationType.name.toUpperCase()} version restored.',
    );
    context.pop();
    context.pop();
  }
}










