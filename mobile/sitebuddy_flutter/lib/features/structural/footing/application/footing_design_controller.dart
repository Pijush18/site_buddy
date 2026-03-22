import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/structural/shared/presentation/providers/design_providers.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_state.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_type.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_service.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/features/structural/footing/domain/usecases/save_footing_design_usecase.dart';

final saveFootingDesignUseCaseProvider = Provider<SaveFootingDesignUseCase>((ref) {
  final structuralRepo = ref.watch(structuralRepositoryProvider);
  final calculationRepo = ref.watch(sharedHistoryRepositoryProvider);
  final designReportRepo = ref.watch(historyRepositoryProvider);
  final projectSession = ref.watch(projectSessionServiceProvider);

  return SaveFootingDesignUseCase(
    structuralRepository: structuralRepo,
    calculationRepository: calculationRepo,
    designReportRepository: designReportRepo,
    projectSession: projectSession,
  );
});

/// PROVIDER: footingDesignControllerProvider
final footingDesignControllerProvider =
    NotifierProvider<FootingDesignController, FootingDesignState>(() {
      return FootingDesignController();
    });

class FootingDesignController extends Notifier<FootingDesignState> {
  late final FootingDesignService _service;

  @override
  FootingDesignState build() {
    final standard = ref.watch(designStandardProvider);
    _service = FootingDesignService(standard);

    final project = ref.read(activeProjectProvider);
    return FootingDesignState(projectId: project?.id);
  }

  Future<void> saveToHistory(String name) async {
    final useCase = ref.read(saveFootingDesignUseCaseProvider);
    await useCase.execute(state);
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
    final reportService = ref.read(designReportServiceProvider);
    await reportService.generateFootingReport(state);
  }

  // Restore state from history (used by HistoryDetailScreen)
  void restore(FootingDesignState newState) {
    state = newState;
    _runPipeline();
  }
}




