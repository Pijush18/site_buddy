import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_result.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/slab_type.dart';
import 'package:site_buddy/core/services/design_report_service.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

/// Provider for SlabDesignController.
final slabDesignControllerProvider =
    NotifierProvider<SlabDesignController, SlabDesignState>(
      SlabDesignController.new,
    );

class SlabDesignController extends Notifier<SlabDesignState> {
  @override
  SlabDesignState build() {
    final project = ref.read(activeProjectProvider);
    return SlabDesignState(projectId: project?.id);
  }

  Future<void> saveToHistory(String name) async {
    if (state.projectId == null || state.result == null) return;

    final resultToSave = SlabDesignResult(
      bendingMoment: state.result!.bendingMoment,
      mainRebar: state.result!.mainRebar,
      distributionSteel: state.result!.distributionSteel,
      projectId: state.projectId,
      isShearSafe: state.result!.isShearSafe,
      isDeflectionSafe: state.result!.isDeflectionSafe,
      isCrackingSafe: state.result!.isCrackingSafe,
    );

    final repo = ref.read(structuralRepositoryProvider);
    await repo.saveSlab(resultToSave);

    // Record calculation history
    final historyRepo = ref.read(sharedHistoryRepositoryProvider);
    final entry = CalculationHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: state.projectId!,
      calculationType: CalculationType.slab,
      timestamp: DateTime.now(),
      inputParameters: {
        'type': state.type.index,
        'lx': state.lx,
        'ly': state.ly,
        'd': state.d,
        'deadLoad': state.deadLoad,
        'liveLoad': state.liveLoad,
      },
      resultSummary: "Slab design saved (Lx: ${state.lx}m, Ly: ${state.ly}m)",
    );
    await historyRepo.addEntry(entry);
  }

  void updateType(SlabType type) {
    state = state.copyWith(
      type: type,
      clearResult: true,
      projectId: state.projectId,
    );
  }

  void updateLx(double lx) {
    state = state.copyWith(
      lx: lx,
      clearResult: true,
      projectId: state.projectId,
    );
  }

  void updateLy(double ly) {
    state = state.copyWith(
      ly: ly,
      clearResult: true,
      projectId: state.projectId,
    );
  }

  void updateDepth(double d) {
    state = state.copyWith(d: d, clearResult: true, projectId: state.projectId);
  }

  void updateLoads({double? dl, double? ll}) {
    state = state.copyWith(
      deadLoad: dl,
      liveLoad: ll,
      clearResult: true,
      projectId: state.projectId,
    );
  }

  void calculate() {
    final engine = ref.read(slabEngineProvider);
    final inputs = SlabDesignInputs(
      type: state.type,
      lx: state.lx,
      ly: state.ly,
      depth: state.d,
      deadLoad: state.deadLoad,
      liveLoad: state.liveLoad,
    );

    final outputs = engine.calculate(inputs);

    final result = SlabDesignResult(
      bendingMoment: outputs.bendingMoment,
      mainRebar: outputs.mainRebar,
      distributionSteel: outputs.distributionSteel,
      isShearSafe: outputs.isShearSafe,
      isDeflectionSafe: outputs.isDeflectionSafe,
      isCrackingSafe: outputs.isCrackingSafe,
      projectId: state.projectId,
    );

    state = state.copyWith(result: result, projectId: state.projectId);
  }

  Future<void> generateReport() async {
    await DesignReportService.generateSlabReport(state);
  }

  // Restore state from history (used by HistoryDetailScreen)
  void restore(SlabDesignState newState) {
    state = newState;
    calculate();
  }
}
