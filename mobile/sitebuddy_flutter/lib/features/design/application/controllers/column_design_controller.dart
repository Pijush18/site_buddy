import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/features/design/application/services/column_design_service.dart';
import 'package:site_buddy/features/design/application/services/column_validator.dart';
import 'package:site_buddy/core/services/design_report_service.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/features/design/domain/usecases/save_column_design_usecase.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';

final saveColumnDesignUseCaseProvider = Provider<SaveColumnDesignUseCase>((
  ref,
) {
  final structuralRepo = ref.watch(structuralRepositoryProvider);
  final calculationRepo = ref.watch(sharedHistoryRepositoryProvider);
  final designReportRepo = ref.watch(historyRepositoryProvider);
  final projectSession = ref.watch(projectSessionServiceProvider);

  return SaveColumnDesignUseCase(
    structuralRepository: structuralRepo,
    calculationRepository: calculationRepo,
    designReportRepository: designReportRepo,
    projectSession: projectSession,
  );
});

/// PROVIDER: columnDesignControllerProvider
final columnDesignControllerProvider =
    NotifierProvider<ColumnDesignController, ColumnDesignState>(() {
      return ColumnDesignController();
    });

/// CONTROLLER: ColumnDesignController
/// PURPOSE: Manages Column Design state and business logic coordination.
class ColumnDesignController extends Notifier<ColumnDesignState> {
  final _service = ColumnDesignService();
  final _validator = ColumnValidator();

  @override
  ColumnDesignState build() {
    // Initialize with selected project if any
    final project = ref.watch(activeProjectProvider);
    return ColumnDesignState(projectId: project?.id);
  }

  void updateInput({
    ColumnType? type,
    double? b,
    double? d,
    double? length,
    EndCondition? endCondition,
    double? cover,
    String? concreteGrade,
    String? steelGrade,
  }) {
    state = state.copyWith(
      type: type,
      b: b,
      d: d,
      length: length,
      endCondition: endCondition,
      cover: cover,
      concreteGrade: concreteGrade,
      steelGrade: steelGrade,
      projectId: state.projectId,
    );
    _runPipeline();
  }

  void updateLoads({double? pu, double? mx, double? my}) {
    state = state.copyWith(pu: pu, mx: mx, my: my, projectId: state.projectId);
    _runPipeline();
  }

  void updateReinforcement({
    bool? isAutoSteel,
    double? steelPercentage,
    double? mainBarDia,
    double? tieDia,
  }) {
    state = state.copyWith(
      isAutoSteel: isAutoSteel,
      steelPercentage: steelPercentage,
      mainBarDia: mainBarDia,
      tieDia: tieDia,
      projectId: state.projectId,
    );
    _runPipeline();
  }

  void updateDesignMethod(DesignMethod method) {
    state = state.copyWith(designMethod: method, projectId: state.projectId);
    _runPipeline();
  }

  void _runPipeline() {
    // 1. Reset transient flags
    state = state.copyWith(clearError: true, projectId: state.projectId);

    // 2. Validate basic inputs
    final error = _validator.validateInputs(state);
    if (error != null) {
      state = state.copyWith(errorMessage: error, projectId: state.projectId);
      return;
    }

    // 3. Execution pipeline
    var newState = state;
    newState = _service.calculateSlenderness(newState);
    newState = _service.calculateDesign(newState);
    newState = _service.calculateDetailing(newState);

    state = newState;
  }

  Future<void> saveToHistory(String name) async {
    final useCase = ref.read(saveColumnDesignUseCaseProvider);
    await useCase.execute(state);
  }

  Future<void> generateReport() async {
    await DesignReportService.generateColumnReport(state);
  }

  // Restore state from history (used by HistoryDetailScreen)
  void restore(ColumnDesignState newState) {
    state = newState;
    _runPipeline();
  }

  void reset() {
    final project = ref.read(activeProjectProvider);
    state = ColumnDesignState(projectId: project?.id);
  }

  void optimizeDesign() {
    state = state.copyWith(
      isOptimizing: !state.isOptimizing,
      projectId: state.projectId,
    );
  }
}
