import 'dart:math' as math;
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_models.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_type.dart';

/// SERVICE: SlabDesignService
/// PURPOSE: Encapsulates all engineering formulas and logic for slab design.
class SlabDesignService {
  final DesignStandard standard;

  SlabDesignService(this.standard);

  /// METHOD: designSlab
  /// Performs full structural design based on the provided input.
  SlabResult designSlab(SlabInput input) {
    // 1. Total Factored Load (kN/m2)
    final totalLoad = (input.deadLoad + input.liveLoad) * standard.gammaLoad;

    // 2. Bending Moment Calculation
    double bendingMoment = 0.0;
    if (input.type == SlabType.oneWay) {
      bendingMoment = (totalLoad * math.pow(input.lx, 2)) / 8;
    } else {
      bendingMoment = (totalLoad * math.pow(input.lx, 2)) / 10;
    }

    // 3. Reinforcement Design (AST Required)
    final fck = _getGradeValue(input.concreteGrade);
    final fy = _getGradeValue(input.steelGrade);
    const b = 1000.0; // 1m strip
    final d = input.depth - input.cover - 5.0;

    double astRequired = 0;
    if (d > 0) {
      final mu = bendingMoment * 1e6; // to N-mm
      final term = 1 - (4.6 * mu) / (fck * b * math.pow(d, 2));
      if (term > 0) {
        astRequired = 0.5 * (fck / fy) * (1 - math.sqrt(term)) * b * d;
      } else {
        astRequired = 9999; // Failure
      }
    }

    // Min rebar check
    final astMin = standard.minReinforcementRatio * b * input.depth;
    astRequired = math.max(astRequired, astMin);

    final mainRebar = _formatRebar(astRequired);
    final distributionSteel = _formatRebar(astMin);

    // 4. Safety Checks
    final isDeflectionSafe = _checkDeflection(input);
    final isShearSafe = bendingMoment < (input.depth * 0.5);

    return SlabResult(
      bendingMoment: bendingMoment,
      mainRebar: mainRebar,
      distributionSteel: distributionSteel,
      isDeflectionSafe: isDeflectionSafe,
      isShearSafe: isShearSafe,
      isCrackingSafe: input.depth >= 100,
      astRequired: astRequired,
      astProvided: astRequired * 1.05,
    );
  }

  String _formatRebar(double ast) {
    if (ast <= 236) return "8mm @ 200mm c/c";
    if (ast <= 314) return "8mm @ 150mm c/c";
    if (ast <= 523) return "10mm @ 150mm c/c";
    if (ast <= 754) return "12mm @ 150mm c/c";
    return "12mm @ 100mm c/c";
  }

  double _getGradeValue(String grade) {
    return double.tryParse(grade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
  }

  bool _checkDeflection(SlabInput input) {
    if (input.lx <= 0 || input.depth <= 0) return false;
    final ratio = (input.lx * 1000) / input.depth;
    final limit = (input.type == SlabType.oneWay) ? 20.0 : 26.0;
    return ratio <= limit;
  }
}

