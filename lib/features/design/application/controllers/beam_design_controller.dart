import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';
import 'package:site_buddy/features/design/domain/services/beam_design_domain_service.dart';
import 'package:site_buddy/features/design/domain/usecases/save_beam_design_usecase.dart';
import 'package:site_buddy/core/services/design_report_service.dart';
import 'package:site_buddy/shared/application/providers/active_project_provider.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';

final saveBeamDesignUseCaseProvider = Provider((ref) {
  final structuralRepo = ref.watch(structuralRepositoryProvider);
  final historyRepo = ref.watch(sharedHistoryRepositoryProvider);
  return SaveBeamDesignUseCase(structuralRepo, historyRepo);
});

/// PROVIDER: beamDesignControllerProvider
final beamDesignControllerProvider =
    NotifierProvider<BeamDesignController, BeamDesignState>(() {
      return BeamDesignController();
    });

/// CONTROLLER: BeamDesignController
/// PURPOSE: Manages Beam Design state and business logic coordination.
class BeamDesignController extends Notifier<BeamDesignState> {
  final _service = BeamDesignDomainService();

  @override
  BeamDesignState build() {
    final project = ref.watch(activeProjectProvider);
    return BeamDesignState(projectId: project?.id);
  }

  Future<void> saveToHistory(String name) async {
    final useCase = ref.read(saveBeamDesignUseCaseProvider);
    await useCase.execute(state);
  }

  void updateInputs({
    BeamType? type,
    double? span,
    double? width,
    double? depth,
    double? cover,
    String? concrete,
    String? steel,
  }) {
    state = state.copyWith(
      type: type,
      span: span,
      width: width,
      overallDepth: depth,
      cover: cover,
      concreteGrade: concrete,
      steelGrade: steel,
      projectId: state.projectId,
    );
  }

  void updateLoads({double? dl, double? ll, double? pl, bool? isULS}) {
    state = state.copyWith(
      deadLoad: dl,
      liveLoad: ll,
      pointLoad: pl,
      isULS: isULS,
      projectId: state.projectId,
    );
  }

  void updateReinforcement({
    double? dia,
    int? num,
    double? stirrupDia,
    double? spacing,
  }) {
    state = state.copyWith(
      mainBarDia: dia,
      numBars: num,
      stirrupDia: stirrupDia,
      stirrupSpacing: spacing,
      projectId: state.projectId,
    );
  }

  void calculateAnalysis() {
    state = _service.calculateAnalysis(state);
  }

  void calculateReinforcement() {
    state = _service.calculateReinforcement(state);
  }

  void reset() {
    final project = ref.read(activeProjectProvider);
    state = BeamDesignState(projectId: project?.id);
  }

  void optimize() {
    // Basic optimization toggle for UI
    state = state.copyWith(
      isOptimizing: !state.isOptimizing,
      projectId: state.projectId,
    );
  }

  Future<void> generateReport() async {
    await DesignReportService.generateBeamReport(state);
  }

  // Restore state from history (used by HistoryDetailScreen)
  void restore(BeamDesignState newState) {
    state = newState;
    calculateAnalysis();
    calculateReinforcement();
  }
}
