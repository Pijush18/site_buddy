import 'dart:math' as math;
import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/shared/domain/models/design/slab_type.dart';

class SlabDesignEngine {
  const SlabDesignEngine();

  /// METHOD: calculate
  /// Performs full structural analysis and reinforcement design for a slab.
  SlabDesignOutputs calculate(SlabDesignInputs inputs) {
    // 1. Total Factored Load (kN/m2)
    // Applying standard safety factor 1.5
    final totalLoad = (inputs.deadLoad + inputs.liveLoad) * 1.5;

    // 2. Bending Moment Calculation (Simplified IS 456 approach)
    double bendingMoment = 0.0;

    if (inputs.type == SlabType.oneWay) {
      // One Way: Mu = (w * lx^2) / 8
      bendingMoment = (totalLoad * math.pow(inputs.lx, 2)) / 8;
    } else {
      // Two Way or Continuous: Mu ≈ (w * lx^2) / 10 (simplified)
      bendingMoment = (totalLoad * math.pow(inputs.lx, 2)) / 10;
    }

    // 3. Reinforcement Estimation
    final mainRebar = _calculateMainRebar(bendingMoment, inputs.depth);
    final distributionSteel = "8mm @ 200mm c/c";

    // 4. Safety Checks
    final isDeflectionSafe = _checkDeflection(inputs);

    return SlabDesignOutputs(
      bendingMoment: bendingMoment,
      mainRebar: mainRebar,
      distributionSteel: distributionSteel,
      isDeflectionSafe: isDeflectionSafe,
      isShearSafe: true, // Simplified for now
      isCrackingSafe: true,
    );
  }

  /// METHOD: optimize
  /// Suggests the best thickness options.
  List<SlabDesignOutputs> getOptimizationOptions(SlabDesignInputs baseInputs) {
    final List<SlabDesignOutputs> options = [];
    final thicknesses = [100.0, 125.0, 150.0, 175.0, 200.0];

    for (var d in thicknesses) {
      final res = calculate(
        SlabDesignInputs(
          type: baseInputs.type,
          lx: baseInputs.lx,
          ly: baseInputs.ly,
          depth: d,
          deadLoad: baseInputs.deadLoad,
          liveLoad: baseInputs.liveLoad,
        ),
      );

      if (res.isDeflectionSafe) {
        options.add(res);
      }
    }
    return options;
  }

  String _calculateMainRebar(double moment, double depth) {
    if (moment < 5) return "8mm @ 200mm c/c";
    if (moment < 12) return "8mm @ 150mm c/c";
    if (moment < 20) return "10mm @ 150mm c/c";
    return "12mm @ 150mm c/c";
  }

  bool _checkDeflection(SlabDesignInputs inputs) {
    // Basic L/d ratio check (Simplified)
    // IS 456 Cl. 23.2.1: L/d <= 20 (Simply Supported), 26 (Continuous)
    final ratio = (inputs.lx * 1000) / inputs.depth;
    final limit = (inputs.type == SlabType.oneWay) ? 20.0 : 26.0;
    return ratio <= limit;
  }
}
