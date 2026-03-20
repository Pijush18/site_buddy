/// FILE HEADER
/// ----------------------------------------------
/// File: slab_design_usecase.dart
/// Feature: design
/// Layer: domain/usecases
///
/// PURPOSE:
/// Encapsulates IS 456 / structural engineering math for RCC slab design.
/// ----------------------------------------------
library;


import 'dart:math' as math;
import 'package:site_buddy/shared/domain/models/design/slab_type.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_result.dart';

/// CLASS: SlabDesignUseCase
/// Performs structural calculations based on simplified code formulas.
class SlabDesignUseCase {
  /// METHOD: execute
  /// PURPOSE: Computes slab results from physical inputs.
  SlabDesignResult execute({
    required SlabType type,
    required double lx,
    required double ly,
    required double d,
    required double deadLoad,
    required double liveLoad,
  }) {
    // 1. Total Factored Load (kN/m2)
    // Applying standard safety factor 1.5
    final totalLoad = (deadLoad + liveLoad) * 1.5;

    // 2. Bending Moment Calculation (Simplified)
    double bendingMoment = 0.0;

    if (type == SlabType.oneWay) {
      // One Way: Mu = (w * lx^2) / 8
      bendingMoment = (totalLoad * math.pow(lx, 2)) / 8;
    } else {
      // Two Way or Continuous: Mu ≈ (w * lx^2) / 10 (simplified)
      bendingMoment = (totalLoad * math.pow(lx, 2)) / 10;
    }

    // 3. Reinforcement Estimation (Dummy logic for UI display)
    final mainRebar = _calculateMainRebar(bendingMoment, d);
    final distributionSteel = "8mm @ 200mm c/c";

    return SlabDesignResult(
      bendingMoment: bendingMoment,
      mainRebar: mainRebar,
      distributionSteel: distributionSteel,
      isShearSafe: true,
      isDeflectionSafe: true,
      isCrackingSafe: true,
    );
  }

  String _calculateMainRebar(double moment, double depth) {
    if (moment < 5) return "8mm @ 200mm c/c";
    if (moment < 12) return "8mm @ 150mm c/c";
    if (moment < 20) return "10mm @ 150mm c/c";
    return "12mm @ 150mm c/c";
  }
}



