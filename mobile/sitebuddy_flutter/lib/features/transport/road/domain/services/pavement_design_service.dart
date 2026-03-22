
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_layer.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_design_result.dart';

/// SERVICE: PavementDesignService
/// PURPOSE: Performs professional-level flexible pavement design (IRC).
class PavementDesignService {
  final RoadStandard standard;

  PavementDesignService(this.standard);

  PavementDesignResult designPavement({
    required double cbr,
    required double msa,
    required bool isProUser,
  }) {
    final double totalT = standard.thicknessFromCBR(cbr: cbr, traffic: msa);
    
    List<PavementLayer> allLayers = standard.designLayers(cbr: cbr, msa: msa);
    
    // Pro User restrictions:
    if (!isProUser) {
      // Lock all but the most basic layer (GSB) or obscure details
      allLayers = allLayers.map((l) {
        if (l.name.contains('GSB')) return l;
        return PavementLayer(
          name: 'Restricted Layer',
          thickness: l.thickness,
          materialType: 'Pro Feature Only',
          isLocked: true,
        );
      }).toList();
    }

    final String safety = _evaluateSafety(cbr, totalT);

    return PavementDesignResult(
      totalThickness: totalT,
      layers: allLayers,
      safetyClassification: safety,
      isProUser: isProUser,
      cbrProvided: cbr,
      msaDesign: msa,
    );
  }

  String _evaluateSafety(double cbr, double thickness) {
    if (cbr < 3.0 && thickness < 600.0) return 'CRITICAL (Subgrade too weak for current thickness)';
    if (thickness > 800.0) return 'OVER-DESIGNED (Consider optimization)';
    return 'SAFE (As per IRC 37-2018)';
  }
}
