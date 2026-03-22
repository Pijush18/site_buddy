import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/optimization/optimization_result.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/structural/slab/application/slab_design_controller.dart';
import 'package:site_buddy/features/structural/beam/application/beam_design_controller.dart';
import 'package:site_buddy/features/structural/column/application/column_design_controller.dart';
import 'package:site_buddy/features/structural/footing/application/footing_design_controller.dart';

import 'package:site_buddy/features/structural/shared/domain/repositories/structural_repository.dart';
import 'package:site_buddy/features/structural/shared/data/hive_structural_repository.dart';
import 'package:site_buddy/features/structural/shared/domain/usecases/get_project_structural_calculations_usecase.dart';

final structuralRepositoryProvider = Provider<StructuralRepository>(
  (ref) => HiveStructuralRepository(),
);

final getProjectStructuralCalculationsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(structuralRepositoryProvider);
  return GetProjectStructuralCalculationsUseCase(repository);
});

final slabOptimizationProvider = Provider<OptimizationResult>((ref) {
  final state = ref.watch(slabDesignControllerProvider);
  final engine = ref.watch(optimizationEngineProvider);
  return engine.optimizeSlabThickness(
    lx: state.lx,
    ly: state.ly,
    deadLoad: state.deadLoad,
    liveLoad: state.liveLoad,
    type: state.type,
  );
});

final beamOptimizationProvider = Provider<OptimizationResult>((ref) {
  final state = ref.watch(beamDesignControllerProvider);
  final engine = ref.watch(optimizationEngineProvider);
  return engine.optimizeBeamSection(
    span: state.span,
    deadLoad: state.deadLoad,
    liveLoad: state.liveLoad,
    concreteGrade: state.concreteGrade,
    steelGrade: state.steelGrade,
    type: state.type,
  );
});

final columnOptimizationProvider = Provider<OptimizationResult>((ref) {
  final state = ref.watch(columnDesignControllerProvider);
  final engine = ref.watch(optimizationEngineProvider);
  return engine.optimizeColumnSection(
    pu: state.pu,
    mx: state.mx,
    my: state.my,
    concreteGrade: state.concreteGrade,
    steelGrade: state.steelGrade,
    length: state.length,
  );
});

final footingOptimizationProvider = Provider<OptimizationResult>((ref) {
  final state = ref.watch(footingDesignControllerProvider);
  final engine = ref.watch(optimizationEngineProvider);
  return engine.optimizeFootingSize(
    columnLoad: state.columnLoad,
    sbc: state.sbc,
    concreteGrade: state.concreteGrade,
    steelGrade: state.steelGrade,
    momentX: state.momentX,
    momentY: state.momentY,
  );
});





