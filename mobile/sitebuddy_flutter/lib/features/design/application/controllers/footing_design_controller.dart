import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/services/footing_design_service.dart';
import 'package:site_buddy/core/services/design_report_service.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

/// PROVIDER: footingDesignControllerProvider
final footingDesignControllerProvider =
    NotifierProvider<FootingDesignController, FootingDesignState>(() {
      return FootingDesignController();
    });

/// CONTROLLER: FootingDesignController
/// PURPOSE: Manages Footing Design state and business logic coordination.
class FootingDesignController extends Notifier<FootingDesignState> {
  final _service = FootingDesignService();

  @override
  FootingDesignState build() {
    final project = ref.read(activeProjectProvider);
    return FootingDesignState(projectId: project?.id);
  }

  Future<void> saveToHistory(String name) async {
    if (state.projectId == null) return;
    final repo = ref.read(structuralRepositoryProvider);
    await repo.saveFooting(state);

    // Record calculation history snapshot
    final historyRepo = ref.read(sharedHistoryRepositoryProvider);
    final entry = CalculationHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: state.projectId!,
      calculationType: CalculationType.footing,
      timestamp: DateTime.now(),
      inputParameters: {
        'type': state.type.index,
        'length': state.footingLength,
        'width': state.footingWidth,
        'thickness': state.footingThickness,
        'spacing': state.columnSpacing,
        'sbc': state.sbc,
        'columnLoad': state.columnLoad,
      },
      resultSummary:
          "Footing design saved (${state.footingLength}m x ${state.footingWidth}m). Max Pressure: ${state.maxSoilPressure.toStringAsFixed(1)} kN/m²",
    );
    await historyRepo.addEntry(entry);
  }

  void updateType(FootingType type) {
    state = state.copyWith(type: type, projectId: state.projectId);
  }

  void updateSoilLoad({
    double? columnLoad,
    double? columnLoad2,
    double? sbc,
    double? foundationDepth,
    double? unitWeight,
    double? mx,
    double? my,
    double? mx2,
    double? my2,
  }) {
    state = state.copyWith(
      columnLoad: columnLoad,
      columnLoad2: columnLoad2,
      sbc: sbc,
      foundationDepth: foundationDepth,
      unitWeightSoil: unitWeight,
      momentX: mx,
      momentY: my,
      momentX2: mx2,
      momentY2: my2,
      projectId: state.projectId,
    );
    _runPipeline();
  }

  void updateGeometry({
    double? length,
    double? width,
    double? thickness,
    double? spacing,
    double? colA,
    double? colB,
    double? pileCap,
    double? pileDia,
    int? pileCount,
  }) {
    state = state.copyWith(
      footingLength: length,
      footingWidth: width,
      footingThickness: thickness,
      columnSpacing: spacing,
      colA: colA,
      colB: colB,
      pileCapacity: pileCap,
      pileDiameter: pileDia,
      pileCount: pileCount,
      projectId: state.projectId,
    );
    _runPipeline();
  }

  void updateReinforcement({
    double? mainDia,
    double? mainSpacing,
    double? crossDia,
    double? crossSpacing,
  }) {
    state = state.copyWith(
      mainBarDia: mainDia,
      mainBarSpacing: mainSpacing,
      crossBarDia: crossDia,
      crossBarSpacing: crossSpacing,
      projectId: state.projectId,
    );
    _runPipeline();
  }

  void _runPipeline() {
    state = state.copyWith(clearError: true, projectId: state.projectId);
    state = _service.runPipeline(state);
  }

  void calculate() {
    _runPipeline();
  }

  Future<void> generateReport() async {
    await DesignReportService.generateFootingReport(state);
  }

  // Restore state from history (used by HistoryDetailScreen)
  void restore(FootingDesignState newState) {
    state = newState;
    _runPipeline();
  }
}



