import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
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
import 'package:site_buddy/shared/domain/models/prefill_data.dart';

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

    final resultToSave = state.result!.copyWith(
      projectId: state.projectId,
    );

    final repo = ref.read(structuralRepositoryProvider);
    await repo.saveSlab(resultToSave);

    // Record calculation history
    final historyRepo = ref.read(sharedHistoryRepositoryProvider);
    final entry = CalculationHistoryEntry(
      id: const Uuid().v4(),
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
        'concrete': state.concreteGrade,
        'steel': state.steelGrade,
      },
      resultSummary: "Slab design saved (${state.lx}m x ${state.ly}m)",
      resultData: state.result?.props.isNotEmpty == true ? {
        'bendingMoment': state.result?.bendingMoment,
        'mainRebar': state.result?.mainRebar,
        'astProvided': state.result?.astProvided,
        'isDeflectionSafe': state.result?.isDeflectionSafe,
      } : {},
    );
    await historyRepo.addEntry(entry);
  }

  void updateType(SlabType type) => state = state.copyWith(type: type, clearResult: true);
  void updateLx(double lx) => state = state.copyWith(lx: lx, clearResult: true);
  void updateLy(double ly) => state = state.copyWith(ly: ly, clearResult: true);
  void updateDepth(double d) => state = state.copyWith(d: d, clearResult: true);
  void updateConcreteGrade(String grade) => state = state.copyWith(concreteGrade: grade, clearResult: true);
  void updateSteelGrade(String grade) => state = state.copyWith(steelGrade: grade, clearResult: true);
  void updateCover(double cover) => state = state.copyWith(cover: cover, clearResult: true);

  void updateLoads({double? dl, double? ll}) {
    state = state.copyWith(
      deadLoad: dl,
      liveLoad: ll,
      clearResult: true,
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
      concreteGrade: state.concreteGrade,
      steelGrade: state.steelGrade,
      cover: state.cover,
    );

    final outputs = engine.calculate(inputs);

    final result = SlabDesignResult(
      bendingMoment: outputs.bendingMoment,
      mainRebar: outputs.mainRebar,
      distributionSteel: outputs.distributionSteel,
      isShearSafe: outputs.isShearSafe,
      isDeflectionSafe: outputs.isDeflectionSafe,
      isCrackingSafe: outputs.isCrackingSafe,
      astRequired: outputs.astRequired,
      astProvided: outputs.astProvided,
      projectId: state.projectId,
    );

    state = state.copyWith(result: result);
  }

  Future<void> generateReport() async {
    await DesignReportService.generateSlabReport(state);
  }

  void restore(SlabDesignState newState) {
    state = newState;
    calculate();
  }

  void initializeWithPrefill(dynamic prefill) {
    if (prefill is! SlabDesignPrefillData) return;
    state = state.copyWith(
      lx: prefill.lx ?? state.lx,
      ly: prefill.ly ?? state.ly,
      d: prefill.depth ?? state.d,
      clearResult: true,
    );
  }
}



