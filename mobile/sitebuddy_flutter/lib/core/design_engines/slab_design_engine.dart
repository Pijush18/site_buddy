import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/features/design/slab/slab_models.dart';
import 'package:site_buddy/features/design/slab/slab_design_service.dart';

/// ENGINE: SlabDesignEngine
/// Pure orchestrator that delegates engineering logic to SlabDesignService.
class SlabDesignEngine {
  final SlabDesignService service;

  SlabDesignEngine(this.service);

  /// METHOD: calculate
  /// Orchestrates the design process for a slab.
  SlabDesignOutputs calculate(SlabDesignInputs inputs) {
    // 1. Convert Inputs
    final input = SlabInput(
      type: inputs.type,
      lx: inputs.lx,
      ly: inputs.ly,
      depth: inputs.depth,
      deadLoad: inputs.deadLoad,
      liveLoad: inputs.liveLoad,
      concreteGrade: inputs.concreteGrade,
      steelGrade: inputs.steelGrade,
      cover: inputs.cover,
    );

    // 2. Delegate to Service
    final result = service.designSlab(input);

    // 3. Return Outputs
    return SlabDesignOutputs(
      bendingMoment: result.bendingMoment,
      mainRebar: result.mainRebar,
      distributionSteel: result.distributionSteel,
      isDeflectionSafe: result.isDeflectionSafe,
      isShearSafe: result.isShearSafe,
      isCrackingSafe: result.isCrackingSafe,
      astRequired: result.astRequired,
      astProvided: result.astProvided,
    );
  }

  /// METHOD: getOptimizationOptions
  /// Orchestrates multiple calculations for optimization.
  List<SlabDesignOutputs> getOptimizationOptions(SlabDesignInputs baseInputs) {
    final List<SlabDesignOutputs> options = [];
    final thicknesses = [100.0, 125.0, 150.0, 175.0, 200.0, 225.0, 250.0, 300.0, 350.0];

    for (var d in thicknesses) {
      final inputs = SlabDesignInputs(
        type: baseInputs.type,
        lx: baseInputs.lx,
        ly: baseInputs.ly,
        depth: d,
        deadLoad: baseInputs.deadLoad,
        liveLoad: baseInputs.liveLoad,
        concreteGrade: baseInputs.concreteGrade,
        steelGrade: baseInputs.steelGrade,
        cover: baseInputs.cover,
      );

      final res = calculate(inputs);

      if (res.isDeflectionSafe && res.astRequired < 1000) {
        options.add(res);
      }
    }
    return options;
  }
}



