import 'package:site_buddy/core/engineering/standards/design_code.dart';
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';

/// CLASS: IS456Standard
/// PURPOSE: Concrete implementation of Indian Standard IS 456:2000.
class IS456Standard implements DesignStandard {
  @override
  DesignCode get designCode => DesignCode.is456;

  @override
  String get displayName => "IS 456:2000";

  @override
  double get gammaConcrete => 1.5;

  @override
  double get gammaSteel => 1.15;

  @override
  double get gammaLoad => 1.5;

  @override
  double get stressBlockFactor => 0.446;

  @override
  double get compressionSteelFactor => 0.75;

  @override
  double get maxReinforcementRatio => 0.06;

  @override
  double get minReinforcementRatio => 0.008;

  @override
  double get steelDesignStrengthFactor => 0.87;

  @override
  double xMaxOverD(double fy) {
    if (fy <= 250) return 0.53;
    if (fy <= 415) return 0.48;
    if (fy <= 500) return 0.46;
    return 0.44;
  }

  @override
  double muLimitFactor(double fy) {
    if (fy <= 250) return 0.149;
    if (fy <= 415) return 0.138;
    return 0.133;
  }

  @override
  double get concreteConstant => 4.6;

  @override
  double get deflectionLimitSimplySupported => 20.0;

  @override
  double get deflectionLimitCantilever => 7.0;

  @override
  double get deflectionLimitContinuous => 26.0;

  @override
  double get interactionLimitLow => 0.2;

  @override
  double get interactionLimitHigh => 0.8;

  @override
  double get interactionPowerLow => 1.0;

  @override
  double get interactionPowerHigh => 2.0;

  @override
  double get tieSpacingFactor => 16.0;

  @override
  double get tieSpacingLimit => 300.0;

  @override
  double get minLongitudinalBarDia => 12.0;

  @override
  double get footingSelfWeightFactor => 1.1;

  @override
  double get punchingShearFactor => 0.25;

  @override
  double get concreteDryVolumeFactor => 1.54;

  @override
  double get mortarDryVolumeFactor => 1.30;

  @override
  double get cementBulkDensity => 1440.0;

  @override
  double get cementBagWeight => 50.0;

  @override
  double get standardBrickLength => 0.19;

  @override
  double get standardBrickWidth => 0.09;

  @override
  double get standardBrickHeight => 0.09;

  @override
  double get standardMortarJoint => 0.01;

  @override
  double get brickWastageFactor => 1.05;

  @override
  double get steelDensity => 7850.0;

  @override
  double get eccentricityFactorL => 500.0;

  @override
  double get eccentricityFactorD => 30.0;

  @override
  double get eccentricityMin => 20.0;

  @override
  int get minBarsRectangular => 4;

  @override
  int get minBarsCircular => 6;

  @override
  double developmentLength({
    required double barDiameter,
    required double yieldStrength,
    required double concreteGrade,
    bool isCompression = false,
  }) {
    final tauBd = _getTauBd(concreteGrade);
    final factor = isCompression ? 1.25 : 1.0;
    final designFy = steelDesignStrengthFactor * yieldStrength;
    return (barDiameter * designFy) / (4 * tauBd * factor);
  }

  double _getTauBd(double fck) {
    if (fck < 20) return 1.2;
    if (fck < 25) return 1.2;
    if (fck < 30) return 1.4;
    if (fck < 35) return 1.5;
    if (fck < 40) return 1.7;
    return 1.9;
  }
}
