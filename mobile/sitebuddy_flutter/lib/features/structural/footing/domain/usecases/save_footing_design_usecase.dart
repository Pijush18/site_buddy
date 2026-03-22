import 'package:uuid/uuid.dart';
import 'package:site_buddy/features/structural/shared/domain/repositories/structural_repository.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_state.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/application/services/project_session_service.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// USE CASE: SaveFootingDesignUseCase
/// PURPOSE: Handles the multi-repository save flow for Footing designs.
class SaveFootingDesignUseCase {
  final StructuralRepository _structuralRepository;
  final CalculationRepository _calculationRepository;
  final HistoryRepository _designReportRepository;
  final ProjectSessionService _projectSession;

  SaveFootingDesignUseCase({
    required StructuralRepository structuralRepository,
    required CalculationRepository calculationRepository,
    required HistoryRepository designReportRepository,
    required ProjectSessionService projectSession,
  })  : _structuralRepository = structuralRepository,
        _calculationRepository = calculationRepository,
        _designReportRepository = designReportRepository,
        _projectSession = projectSession;

  Future<void> execute(FootingDesignState state) async {
    final projectId = _projectSession.getActiveProjectId();
    AppLogger.info('Saving Footing Design for Project: $projectId', tag: 'SaveFootingDesign');

    final contextualizedState = state.copyWith(projectId: projectId);

    await _structuralRepository.saveFooting(contextualizedState);

    final entryId = const Uuid().v4();
    final entry = CalculationHistoryEntry(
      id: entryId,
      projectId: projectId,
      calculationType: CalculationType.footing,
      timestamp: DateTime.now(),
      inputParameters: {
        'L': state.footingLength,
        'B': state.footingWidth,
        'D': state.footingThickness,
        'columnLoad': state.columnLoad,
        'sbc': state.sbc,
      },
      resultSummary:
          "Footing saved (${state.footingLength.toInt()}x${state.footingWidth.toInt()} mm). SBC: ${state.sbc.toInt()} kN/m²",
      resultData: {
        'maxSoilPressure': state.maxSoilPressure,
        'astRequiredX': state.astRequiredX,
        'isAreaSafe': state.isAreaSafe,
        'isBendingSafe': state.isBendingSafe,
      },
    );
    await _calculationRepository.addEntry(entry);

    final report = DesignReportMapper.fromFooting(contextualizedState, projectId);
    await _designReportRepository.save(report);
    AppLogger.info('Footing Design synchronized with HistoryRepository', tag: 'SaveFootingDesign');
  }
}


