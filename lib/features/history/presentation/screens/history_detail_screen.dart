import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
//     final theme = Theme.of(context);

    return SbPage.detail(
      title: 'History Detail',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, dateStr),
          AppLayout.vGap24,
          Text('Input Parameters', style: SbTextStyles.title(context)),
          AppLayout.vGap16,
          _buildParametersList(context),
          AppLayout.vGap32,
          SbButton.primary(
            onPressed: () => _restoreVersion(context, ref),
            label: 'Restore this Version',
          ),
          AppLayout.vGap32,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String dateStr) {
//     final theme = Theme.of(context);
    return SbCard(
      child: Column(
        children: [
          Text(
            entry.calculationType.name.toUpperCase(),
            style: SbTextStyles.body(context).copyWith(letterSpacing: 1.2),
          ),
          const Divider(height: 16),
          AppLayout.vGap8,
          Text(
            entry.resultSummary,
            textAlign: TextAlign.center,
            style: SbTextStyles.title(context),
          ),
          AppLayout.vGap8,
          Text(dateStr, style: SbTextStyles.body(context)),
        ],
      ),
    );
  }

  Widget _buildParametersList(BuildContext context) {
//     final theme = Theme.of(context);
    final params = entry.inputParameters;
    if (params.isEmpty) {
      return Text('No parameters recorded.', style: SbTextStyles.body(context));
    }

    return SbCard(
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: params.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final key = params.keys.elementAt(index);
          final value = params.values.elementAt(index);
          return SbListItem(
            title: key,
            trailing: Text(value.toString(), style: SbTextStyles.body(context)),
          );
        },
      ),
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