import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/optimization/optimization_result.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/domain/repositories/structural_repository.dart';
import 'package:site_buddy/features/design/data/hive_structural_repository.dart';
import 'package:site_buddy/features/design/domain/usecases/get_project_structural_calculations_usecase.dart';

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
