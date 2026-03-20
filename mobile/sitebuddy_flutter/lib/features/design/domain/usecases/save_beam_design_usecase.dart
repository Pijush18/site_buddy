import 'package:site_buddy/features/design/domain/repositories/structural_repository.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';

class SaveBeamDesignUseCase {
  final StructuralRepository structuralRepository;
  final HistoryRepository historyRepository;

  SaveBeamDesignUseCase(this.structuralRepository, this.historyRepository);

  Future<void> execute(BeamDesignState state) async {
    if (state.projectId == null) return;

    await structuralRepository.saveBeam(state);

    final entry = CalculationHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: state.projectId!,
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
    );

    await historyRepository.addEntry(entry);
  }
}



