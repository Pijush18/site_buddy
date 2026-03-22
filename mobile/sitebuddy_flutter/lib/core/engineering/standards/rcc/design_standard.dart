import 'package:site_buddy/core/engineering/standards/design_code.dart';

/// INTERFACE: DesignStandard
/// PURPOSE: Defines the contract for all engineering standards (IS 456, ACI 318, etc.)
abstract class DesignStandard {
  /// The specific governing code (e.g., IS 456, ACI 318).
  DesignCode get designCode;

  /// Human-readable name of the standard.
  String get displayName;

  // --- MATERIAL SAFETY FACTORS ---

  /// Partial safety factor for concrete (e.g., 1.5 for IS 456).
  double get gammaConcrete;

  /// Partial safety factor for steel (e.g., 1.15 for IS 456).
  double get gammaSteel;

  /// Partial safety factor for loads (e.g., 1.5).
  double get gammaLoad;

  // --- FLEXURAL DESIGN CONSTANTS ---

  /// Stress block factor (e.g., 0.446 for IS 456).
  double get stressBlockFactor;

  /// Factor for compression steel (e.g., 0.75).
  double get compressionSteelFactor;

  /// Maximum depth of neutral axis factor (x_max/d).
  double xMaxOverD(double fy);

  /// Ultimate moment of resistance factor (Mu_lim / fck.b.d^2).
  double muLimitFactor(double fy);

  /// Concrete constant for area of steel calculation (e.g., 4.6).
  double get concreteConstant;

  // --- REINFORCEMENT LIMITS ---

  /// Maximum reinforcement ratio allowed (e.g., 0.04 or 0.06).
  double get maxReinforcementRatio;

  /// Minimum reinforcement ratio allowed (e.g., 0.008 for columns).
  double get minReinforcementRatio;

  /// Multiplier for steel design strength (e.g., 0.87 for IS 456).
  double get steelDesignStrengthFactor;

  // --- DEFLECTION LIMITS (Span/Depth) ---

  /// Span/depth limit for simply supported beams/slabs.
  double get deflectionLimitSimplySupported;

  /// Span/depth limit for cantilever beams/slabs.
  double get deflectionLimitCantilever;

  /// Span/depth limit for continuous beams/slabs.
  double get deflectionLimitContinuous;

  // --- COLUMN DESIGN PARAMETERS ---

  /// Minimum eccentricity factor for length (L/500).
  double get eccentricityFactorL;

  /// Minimum eccentricity factor for dimension (D/30).
  double get eccentricityFactorD;

  /// Absolute minimum eccentricity in mm (e.g., 20mm).
  double get eccentricityMin;

  /// Minimum number of bars in rectangular columns.
  int get minBarsRectangular;

  /// Minimum number of bars in circular columns.
  int get minBarsCircular;

  /// Low-end limit for interaction formula (e.g., 0.2).
  double get interactionLimitLow;

  /// High-end limit for interaction formula (e.g., 0.8).
  double get interactionLimitHigh;

  /// Power 'n' for interaction formula when Pu/Puz <= limitLow.
  double get interactionPowerLow;

  /// Power 'n' for interaction formula when Pu/Puz >= limitHigh.
  double get interactionPowerHigh;

  // --- DETAILING RULES ---

  /// Factor for lateral tie spacing (e.g., 16 * dia).
  double get tieSpacingFactor;

  /// Maximum lateral tie spacing in mm (e.g., 300mm).
  double get tieSpacingLimit;

  /// Minimum longitudinal bar diameter for columns (e.g., 12.0).
  double get minLongitudinalBarDia;

  // --- FOOTING DESIGN ---
  
  /// Factor for footing self-weight (e.g., 1.1).
  double get footingSelfWeightFactor;

  /// Factor for punching shear capacity (e.g., 0.25).
  double get punchingShearFactor;

  // --- MATERIAL ESTIMATION ---

  /// Dry-to-wet volume conversion factor for concrete (e.g., 1.54).
  double get concreteDryVolumeFactor;

  /// Dry-to-wet volume conversion factor for mortar (e.g., 1.30).
  double get mortarDryVolumeFactor;

  /// Bulk density of cement in kg/m3 (e.g., 1440.0).
  double get cementBulkDensity;

  /// Weight of a single cement bag in kg (e.g., 50.0).
  double get cementBagWeight;

  /// Standard modular brick length in metres (e.g., 0.19).
  double get standardBrickLength;

  /// Standard modular brick width in metres (e.g., 0.09).
  double get standardBrickWidth;

  /// Standard modular brick height in metres (e.g., 0.09).
  double get standardBrickHeight;

  /// Standard mortar joint thickness in metres (e.g., 0.01).
  double get standardMortarJoint;

  /// Standard brick wastage factor (e.g., 1.05).
  double get brickWastageFactor;

  /// Density of reinforcement steel in kg/m3 (e.g., 7850.0).
  double get steelDensity;

  // --- DEVELOPMENT LENGTH ---

  /// Calculates development length (Ld).
  double developmentLength({
    required double barDiameter,
    required double yieldStrength,
    required double concreteGrade,
    bool isCompression = false,
  });
}
