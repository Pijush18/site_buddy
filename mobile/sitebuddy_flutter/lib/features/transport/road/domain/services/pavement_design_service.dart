
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_layer.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_design_result.dart';

/// SERVICE: PavementDesignService
/// PURPOSE: Performs professional-level flexible pavement design (IRC).
/// 
/// DOMAIN PURITY: This service contains ONLY business logic.
/// No user plan, subscription status, or policy decisions.
/// Policy decisions are handled in the Application layer (Notifiers).
class PavementDesignService {
  final RoadStandard standard;

  PavementDesignService(this.standard);

  /// Designs pavement and returns COMPLETE results.
  /// 
  /// The domain layer ALWAYS returns full, unbiased engineering results.
  /// Pro/premium features are computed but not gated here.
  PavementDesignResult designPavement({
    required double cbr,
    required double msa,
  }) {
    // 1. Compute total thickness from standard
    final double totalT = standard.thicknessFromCBR(cbr: cbr, traffic: msa);
    
    // 2. Get all layers from standard (always full results)
    final List<PavementLayer> allLayers = standard.designLayers(cbr: cbr, msa: msa);
    
    // 3. Evaluate safety classification
    final String safety = standard.evaluateSafety(cbr: cbr, thickness: totalT);
    
    // 4. Compute optimization suggestion (if applicable)
    double? suggestedOptimization;
    if (totalT > 800.0) {
      // Suggest reduction if over-designed (domain computes, application shows)
      suggestedOptimization = totalT * 0.9; // Suggest 10% reduction
    }

    // 5. Return complete result (no gating)
    return PavementDesignResult(
      totalThickness: totalT,
      layers: allLayers,
      safetyClassification: safety,
      cbrProvided: cbr,
      msaDesign: msa,
      suggestedOptimization: suggestedOptimization,
    );
  }
}
