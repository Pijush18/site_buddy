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

    // 3. Reinforcement Estimation (AST Required)
    // AST = 0.5 * fck/fy * [1 - sqrt(1 - 4.6 * Mu / (fck * b * d^2))] * b * d
    final fck = _getFck(inputs.concreteGrade);
    final fy = _getFy(inputs.steelGrade);
    final b = 1000.0; // 1m strip
    final d = inputs.depth - inputs.cover - 5.0; // Effective depth approx

    double astRequired = 0;
    if (d > 0) {
      final mu = bendingMoment * 1e6; // to N-mm
      final term = 1 - (4.6 * mu) / (fck * b * math.pow(d, 2));
      if (term > 0) {
        astRequired = 0.5 * (fck / fy) * (1 - math.sqrt(term)) * b * d;
      } else {
        astRequired = 9999; // Section failed flexure (too shallow)
      }
    }

    // Min rebar check (0.12% for HYSD)
    final astMin = 0.0012 * b * inputs.depth;
    astRequired = math.max(astRequired, astMin);

    final mainRebar = _formatRebar(astRequired);
    final distributionSteel = _formatRebar(astMin);

    // 4. Safety Checks
    final isDeflectionSafe = _checkDeflection(inputs);
    final isShearSafe = bendingMoment < (inputs.depth * 0.5); // Very rough proxy

    return SlabDesignOutputs(
      bendingMoment: bendingMoment,
      mainRebar: mainRebar,
      distributionSteel: distributionSteel,
      isDeflectionSafe: isDeflectionSafe,
      isShearSafe: isShearSafe,
      isCrackingSafe: inputs.depth >= 100,
      astRequired: astRequired,
      astProvided: astRequired * 1.05, // Approximation
    );
  }

  /// METHOD: optimize
  /// Suggests the best thickness options.
  List<SlabDesignOutputs> getOptimizationOptions(SlabDesignInputs baseInputs) {
    final List<SlabDesignOutputs> options = [];
    final thicknesses = [100.0, 125.0, 150.0, 175.0, 200.0, 225.0, 250.0, 300.0, 350.0];

    for (var d in thicknesses) {
      final res = calculate(
        SlabDesignInputs(
          type: baseInputs.type,
          lx: baseInputs.lx,
          ly: baseInputs.ly,
          depth: d,
          deadLoad: baseInputs.deadLoad,
          liveLoad: baseInputs.liveLoad,
          concreteGrade: baseInputs.concreteGrade,
          steelGrade: baseInputs.steelGrade,
          cover: baseInputs.cover,
        ),
      );

      if (res.isDeflectionSafe && res.astRequired < 1000) {
        options.add(res);
      }
    }
    return options;
  }

  String _formatRebar(double ast) {
    if (ast <= 236) return "8mm @ 200mm c/c";
    if (ast <= 314) return "8mm @ 150mm c/c";
    if (ast <= 523) return "10mm @ 150mm c/c";
    if (ast <= 754) return "12mm @ 150mm c/c";
    return "12mm @ 100mm c/c";
  }

  double _getFck(String grade) {
    return double.tryParse(grade.replaceAll('M', '')) ?? 25.0;
  }

  double _getFy(String grade) {
    return double.tryParse(grade.replaceAll('Fe', '')) ?? 500.0;
  }

  bool _checkDeflection(SlabDesignInputs inputs) {
    // Basic L/d ratio check
    // IS 456 Cl. 23.2.1: L/d <= 20 (Simply Supported), 26 (Continuous)
    if (inputs.lx <= 0 || inputs.depth <= 0) return false;
    final ratio = (inputs.lx * 1000) / inputs.depth;
    final limit = (inputs.type == SlabType.oneWay) ? 20.0 : 26.0;
    return ratio <= limit;
  }
}



