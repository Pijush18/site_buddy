import 'package:uuid/uuid.dart';
import 'package:site_buddy/features/design/domain/repositories/structural_repository.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/application/services/project_session_service.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// USE CASE: SaveColumnDesignUseCase
/// PURPOSE: Handles the multi-repository save flow for Column designs.
class SaveColumnDesignUseCase {
  final StructuralRepository _structuralRepository;
  final CalculationRepository _calculationRepository;
  final HistoryRepository _designReportRepository;
  final ProjectSessionService _projectSession;

  SaveColumnDesignUseCase({
    required StructuralRepository structuralRepository,
    required CalculationRepository calculationRepository,
    required HistoryRepository designReportRepository,
    required ProjectSessionService projectSession,
  })  : _structuralRepository = structuralRepository,
        _calculationRepository = calculationRepository,
        _designReportRepository = designReportRepository,
        _projectSession = projectSession;

  Future<void> execute(ColumnDesignState state) async {
    final projectId = _projectSession.getActiveProjectId();
    AppLogger.info('Saving Column Design for Project: $projectId', tag: 'SaveColumnDesign');

    final contextualizedState = state.copyWith(projectId: projectId);

    await _structuralRepository.saveColumn(contextualizedState);

    final entryId = const Uuid().v4();
    final entry = CalculationHistoryEntry(
      id: entryId,
      projectId: projectId,
      calculationType: CalculationType.column,
      timestamp: DateTime.now(),
      inputParameters: {
        'type': state.type.index,
        'b': state.b,
        'd': state.d,
        'length': state.length,
        'pu': state.pu,
        'mx': state.mx,
        'my': state.my,
      },
      resultSummary:
          "Column saved (${state.b.toInt()}x${state.d.toInt()} mm). Interaction Ratio: ${state.interactionRatio.toStringAsFixed(2)}",
      resultData: {
        'interactionRatio': state.interactionRatio,
        'astProvided': state.astProvided,
        'isCapacitySafe': state.isCapacitySafe,
        'failureMode': state.failureMode.index,
      },
    );
    await _calculationRepository.addEntry(entry);

    final report = DesignReportMapper.fromColumn(contextualizedState, projectId);
    await _designReportRepository.save(report);
    AppLogger.info('Column Design synchronized with HistoryRepository');
  }
}
