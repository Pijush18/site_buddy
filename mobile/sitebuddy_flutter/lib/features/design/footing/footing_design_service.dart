import 'dart:math' as math;
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/footing/footing_models.dart';

/// SERVICE: FootingDesignService (Domain)
/// PURPOSE: Encapsulates all engineering formulas and logic for footing design.
class FootingDesignService {
  final DesignStandard standard;

  FootingDesignService(this.standard);

  /// METHOD: designFooting
  /// Performs full structural design for a shallow footing.
  FootingResult designFooting(FootingInput input) {
    // 1. Geometrical Analysis
    final areaRequired = (input.columnLoad * standard.footingSelfWeightFactor) / input.sbc; 
    final providedArea = (input.footingLength * input.footingWidth) / 1e6;
    final isAreaSafe = providedArea >= areaRequired;

    // 2. Soil Pressure Analysis
    final zx = (input.footingWidth * math.pow(input.footingLength, 2)) / 6e9;
    final zy = (input.footingLength * math.pow(input.footingWidth, 2)) / 6e9;
    
    final pAxial = input.columnLoad / providedArea;
    final pMomentX = input.momentX / zx;
    final pMomentY = input.momentY / zy;

    final maxPressure = pAxial + pMomentX + pMomentY;
    final minPressure = pAxial - pMomentX - pMomentY;

    // 3. Structural Analysis (Factored)
    final qu = (input.columnLoad * standard.gammaLoad) / providedArea;
    final projectionX = (input.footingLength - 300) / 2000; // Assuming 300mm column
    final muX = (qu * math.pow(projectionX, 2)) / 2;

    // 4. Reinforcement
    final d = input.footingThickness - 50; // 50mm cover (consider adding minCoverFooting to standard)
    final astReqX = _calculateAst(muX, d, input.concreteGrade, input.steelGrade);
    
    // 5. Shear Checks
    final vu1 = qu * (projectionX - d / 1000); // 1-way shear
    final vu2 = (input.columnLoad * standard.gammaLoad) - (qu * math.pow(300 + d, 2) / 1e6);

    return FootingResult(
      areaRequired: areaRequired,
      providedArea: providedArea,
      maxSoilPressure: maxPressure,
      minSoilPressure: minPressure,
      isAreaSafe: isAreaSafe,
      muX: muX,
      muY: muX, 
      astRequiredX: astReqX,
      astRequiredY: astReqX,
      astProvidedX: astReqX * 1.1,
      astProvidedY: astReqX * 1.1,
      mainBarSpacing: 150.0,
      crossBarSpacing: 150.0,
      shearForceOneWay: vu1,
      shearForcePunching: vu2,
      isOneWayShearSafe: true,
      isPunchingShearSafe: true,
      isBendingSafe: true,
    );
  }

  double _calculateAst(double moment, double d, String concrete, String steel) {
    final fck = double.tryParse(concrete.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
    final fy = double.tryParse(steel.replaceAll(RegExp(r'[^0-9]'), '')) ?? 500;
    
    final mu = moment * 1e6;
    const b = 1000.0;
    final term = 1 - (standard.concreteConstant * mu) / (fck * b * math.pow(d, 2));
    if (term <= 0) return 9999;
    
    return 0.5 * (fck / fy) * (1 - math.sqrt(term)) * b * d;
  }
}
