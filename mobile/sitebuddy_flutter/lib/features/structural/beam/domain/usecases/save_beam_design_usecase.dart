import 'package:uuid/uuid.dart';
import 'package:site_buddy/features/structural/shared/domain/repositories/structural_repository.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/application/services/project_session_service.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// USE CASE: SaveBeamDesignUseCase
/// PURPOSE: Handles the multi-repository save flow for Beam designs.
///
/// ENFORCEMENT:
/// - Guarantees every save is tied to the active project session.
/// - Synchronizes structural data, raw history, and unified design reports.
class SaveBeamDesignUseCase {
  final StructuralRepository _structuralRepository;
  final CalculationRepository _calculationRepository; // Raw history
  final HistoryRepository _designReportRepository; // Unified reports
  final ProjectSessionService _projectSession;

  SaveBeamDesignUseCase({
    required StructuralRepository structuralRepository,
    required CalculationRepository calculationRepository,
    required HistoryRepository designReportRepository,
    required ProjectSessionService projectSession,
  }) : _structuralRepository = structuralRepository,
       _calculationRepository = calculationRepository,
       _designReportRepository = designReportRepository,
       _projectSession = projectSession;

  Future<void> execute(BeamDesignState state) async {
    // 1. Validate active project exists - throws StateError if not set
    final projectId = _projectSession.getActiveProjectId();
    AppLogger.info(
      'Saving Beam Design for Project: $projectId',
      tag: 'SaveBeamDesign',
    );

    // 2. Enrich state with project context
    final contextualizedState = state.copyWith(projectId: projectId);

    // 3. Save to Structural Repository (Design-specific persistence)
    await _structuralRepository.saveBeam(contextualizedState);

    // 4. Save to Calculation Repository (Raw history entry / legacy support)
    final entryId = const Uuid().v4();
    final entry = CalculationHistoryEntry(
      id: entryId,
      projectId: projectId,
      calculationType: CalculationType.beam,
      timestamp: DateTime.now(),
      inputParameters: {
        'type': state.type.index,
        'span': state.span,
        'width': state.width,
        'depth': state.overallDepth,
        'deadLoad': state.deadLoad,
        'liveLoad': state.liveLoad,
        'pointLoad': state.pointLoad,
      },
      resultSummary:
          "Beam design saved (${state.width.toInt()}x${state.overallDepth.toInt()} mm). Ast Provided: ${state.astProvided.toInt()} mm²",
      resultData: {
        'mu': state.mu,
        'vu': state.vu,
        'astProvided': state.astProvided,
        'isFlexureSafe': state.isFlexureSafe,
        'isShearSafe': state.isShearSafe,
      },
    );
    await _calculationRepository.addEntry(entry);

    // 5. Save to Unified Report History (Production report system)
    final report = DesignReportMapper.fromBeam(contextualizedState, projectId);
    await _designReportRepository.save(report);

    AppLogger.info('Beam Design synchronized with HistoryRepository');
  }
}


