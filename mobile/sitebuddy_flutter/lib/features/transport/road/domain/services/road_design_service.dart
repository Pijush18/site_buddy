import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_input.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_result.dart';

/// lib/features/transport/road/domain/services/road_design_service.dart
///
/// Engineering service responsible for road pavement calculations.
/// This service is strictly stateless and depends only on RoadStandard.
class RoadDesignService {
  final RoadStandard standard;

  const RoadDesignService(this.standard);

  /// Performs the full pavement design based on inputs and standards.
  PavementResult designPavement(PavementInput input) {
    // 1. Calculate total thickness using CBR method from Standard
    final double totalT = standard.thicknessFromCBR(
      cbr: input.subgradeCBR,
      traffic: input.trafficMSA,
    );

    // 2. Distribute thickness into layers according to input ratios
    // These are simplified rules for demonstration purposes
    final double bituminousT = totalT * input.bituminousPercent;
    final double remainingT = totalT - bituminousT;
    
    // Split remaining thickness between Base and Sub-base (60/40 ratio)
    final double baseT = remainingT * 0.6;
    final double subBaseT = remainingT * 0.4;

    return PavementResult(
      totalThickness: totalT,
      bituminousThickness: bituminousT,
      baseThickness: baseT,
      subBaseThickness: subBaseT,
      designCode: standard.codeIdentifier,
    );
  }
}
