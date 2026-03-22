import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/presentation/widgets/design_report_view.dart';

// Controllers (Required for Restore logic)
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/features/calculator/application/controllers/cement_controller.dart';
import 'package:site_buddy/features/calculator/application/controllers/rebar_controller.dart';
import 'package:site_buddy/features/calculator/application/controllers/brick_wall_controller.dart';
import 'package:site_buddy/features/calculator/application/controllers/plaster_controller.dart';
import 'package:site_buddy/features/calculator/application/controllers/excavation_controller.dart';
import 'package:site_buddy/features/calculator/application/controllers/shuttering_controller.dart';
import 'package:site_buddy/features/calculator/application/controllers/sand_controller.dart';

// States (Required for Restore logic)
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

/// SCREEN: HistoryDetailScreen
/// PURPOSE: Displays the details of a historical calculation using the unified DesignReport system.
/// 
/// FEATURES:
/// - Uses [DesignReportMapper] for data conversion.
/// - Uses [DesignReportView] for standardized rendering.
/// - RESTORE Logic: Allows users to reload a past calculation into the active workspace.
class HistoryDetailScreen extends ConsumerWidget {
  final CalculationHistoryEntry entry;

  const HistoryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Convert entry to standardized report for rendering
    final report = DesignReportMapper.fromHistoryEntry(entry);

    return SbPage.detail(
      title: 'History Detail',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SbSpacing.md),
        child: Column(
          children: [
            // Standardized Report View
            DesignReportView(report: report),
            
            const SizedBox(height: SbSpacing.lg),
            
            // Interaction Section (Restore)
            PrimaryCTA(
              onPressed: () => _handleRestore(context, ref),
              label: 'Restore this Version',
              width: double.infinity,
              icon: Icons.restore_rounded,
            ),
            const SizedBox(height: SbSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// Restores the history entry values back into the active controllers.
  void _handleRestore(BuildContext context, WidgetRef ref) {
    final params = entry.inputParameters;

    switch (entry.calculationType) {
      case CalculationType.column:
        ref.read(columnDesignControllerProvider.notifier).restore(
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
        ref.read(beamDesignControllerProvider.notifier).restore(
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
        ref.read(slabDesignControllerProvider.notifier).restore(
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
        ref.read(footingDesignControllerProvider.notifier).restore(
              FootingDesignState(
                projectId: entry.projectId,
                columnLoad: (params['columnLoad'] as num?)?.toDouble() ?? 1000.0,
                sbc: (params['sbc'] as num?)?.toDouble() ?? 200.0,
                footingLength: (params['length'] as num?)?.toDouble() ?? 2.0,
                footingWidth: (params['width'] as num?)?.toDouble() ?? 2.0,
                footingThickness: (params['thickness'] as num?)?.toDouble() ?? 500.0,
                columnSpacing: (params['spacing'] as num?)?.toDouble() ?? 0.0,
              ),
            );
        break;

      case CalculationType.cement:
        ref.read(cementControllerProvider.notifier).restore(params);
        break;
      case CalculationType.rebar:
        ref.read(rebarControllerProvider.notifier).restore(params);
        break;
      case CalculationType.brick:
        ref.read(brickWallProvider.notifier).restore(params);
        break;
      case CalculationType.plaster:
        ref.read(plasterProvider.notifier).restore(params);
        break;
      case CalculationType.excavation:
        ref.read(excavationProvider.notifier).restore(params);
        break;
      case CalculationType.shuttering:
        ref.read(shutteringProvider.notifier).restore(params);
        break;
      case CalculationType.sand:
      case CalculationType.levelLog:
      case CalculationType.gradient:
      case CalculationType.unitConverter:
      case CalculationType.currencyConverter:
        break;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${entry.calculationType.name.toUpperCase()} version restored.')),
      );
      context.pop();
    }
  }
}
