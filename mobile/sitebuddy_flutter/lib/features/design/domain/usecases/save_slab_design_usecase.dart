import 'package:uuid/uuid.dart';
import 'package:site_buddy/features/design/domain/repositories/structural_repository.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/application/services/project_session_service.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// USE CASE: SaveSlabDesignUseCase
/// PURPOSE: Handles the multi-repository save flow for Slab designs.
class SaveSlabDesignUseCase {
  final StructuralRepository _structuralRepository;
  final CalculationRepository _calculationRepository;
  final HistoryRepository _designReportRepository;
  final ProjectSessionService _projectSession;

  SaveSlabDesignUseCase({
    required StructuralRepository structuralRepository,
    required CalculationRepository calculationRepository,
    required HistoryRepository designReportRepository,
    required ProjectSessionService projectSession,
  })  : _structuralRepository = structuralRepository,
        _calculationRepository = calculationRepository,
        _designReportRepository = designReportRepository,
        _projectSession = projectSession;

  Future<void> execute(SlabDesignState state) async {
    final projectId = _projectSession.getActiveProjectId();
    AppLogger.info('Saving Slab Design for Project: $projectId', tag: 'SaveSlabDesign');

    final contextualizedState = state.copyWith(projectId: projectId);
    
    // The structural repository expects SlabDesignResult for persistence in this architecture
    if (contextualizedState.result != null) {
       final resultWithProject = contextualizedState.result!.copyWith(projectId: projectId);
       await _structuralRepository.saveSlab(resultWithProject);
    }

    final entryId = const Uuid().v4();
    final entry = CalculationHistoryEntry(
      id: entryId,
      projectId: projectId,
      calculationType: CalculationType.slab,
      timestamp: DateTime.now(),
      inputParameters: {
        'lx': state.lx,
        'ly': state.ly,
        'd': state.d,
        'deadLoad': state.deadLoad,
        'liveLoad': state.liveLoad,
      },
      resultSummary:
          "Slab saved (${state.lx.toStringAsFixed(1)}x${state.ly.toStringAsFixed(1)} m). Bending Moment: ${state.result?.bendingMoment.toStringAsFixed(2)} kNm/m",
      resultData: {
        'bendingMoment': state.result?.bendingMoment,
        'mainRebar': state.result?.mainRebar,
        'isShearSafe': state.result?.isShearSafe,
      },
    );
    await _calculationRepository.addEntry(entry);

    final report = DesignReportMapper.fromSlab(contextualizedState, projectId);
    await _designReportRepository.save(report);
    
    AppLogger.info('Slab Design synchronized with HistoryRepository', tag: 'SaveSlabDesign');
  }
}
