import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';

part 'footing_design_state.g.dart';

/// ENTITY: FootingDesignState
/// PURPOSE: Holds all parameters and calculated results for the Footing Design workflow.
@HiveType(typeId: 13)
class FootingDesignState {
  @HiveField(0)
  final String? projectId;
  // Step 1: Type Selection
  @HiveField(1)
  final FootingType type;

  // Step 2: Soil & Load
  @HiveField(2)
  final double columnLoad; // kN (P1)
  @HiveField(3)
  final double columnLoad2; // kN (P2 - for Combined/Strap)
  @HiveField(4)
  final double momentX; // kNm (Mx1)
  @HiveField(5)
  final double momentY; // kNm (My1)
  @HiveField(6)
  final double momentX2; // kNm (Mx2)
  @HiveField(7)
  final double momentY2; // kNm (My2)
  @HiveField(8)
  final double sbc; // kN/m^2 (Safe Bearing Capacity)
  @HiveField(9)
  final double foundationDepth; // m
  @HiveField(10)
  final double unitWeightSoil; // kN/m^3

  // Step 3: Geometry
  @HiveField(11)
  final double footingLength; // mm (L)
  @HiveField(12)
  final double footingWidth; // mm (B)
  @HiveField(13)
  final double footingThickness; // mm (D)
  @HiveField(14)
  final double columnSpacing; // mm (for Combined/Strap)
  @HiveField(15)
  final double colA; // mm (Column dimension in X)
  @HiveField(16)
  final double colB; // mm (Column dimension in Y)
  @HiveField(17)
  final double pileCapacity; // kN/pile
  @HiveField(18)
  final double pileDiameter; // mm
  @HiveField(19)
  final int pileCount; // number of piles

  // Step 4: Analysis (Calculated)
  @HiveField(20)
  final double requiredArea; // m^2
  @HiveField(21)
  final double providedArea; // m^2
  @HiveField(22)
  final double maxSoilPressure; // kN/m^2 (Working q_max)
  @HiveField(23)
  final double minSoilPressure; // kN/m^2 (Working q_min)
  @HiveField(24)
  final double qu; // kN/m^2 (Factored Net Pressure)
  @HiveField(25)
  final double eccentricityX; // mm
  @HiveField(26)
  final double eccentricityY; // mm

  // Step 5: Reinforcement (Calculated)
  @HiveField(27)
  final String concreteGrade; // e.g., "M25"
  @HiveField(28)
  final String steelGrade; // e.g., "Fe500"
  @HiveField(29)
  final double mainBarDia; // mm
  @HiveField(30)
  final double crossBarDia; // mm
  @HiveField(31)
  final double astRequiredX; // mm^2
  @HiveField(32)
  final double astRequiredY; // mm^2
  @HiveField(33)
  final double astProvidedX; // mm^2
  @HiveField(34)
  final double astProvidedY; // mm^2
  @HiveField(35)
  final double mainBarSpacing; // mm
  @HiveField(36)
  final double crossBarSpacing; // mm
  @HiveField(37)
  final double mu; // kNm (Factored Moment at face)

  // Step 6: Safety Checks (Calculated)
  @HiveField(38)
  final bool isAreaSafe;
  @HiveField(39)
  final bool isOneWayShearSafe;
  @HiveField(40)
  final bool isPunchingShearSafe;
  @HiveField(41)
  final bool isBendingSafe;
  @HiveField(42)
  final bool isSettlementWarning;
  @HiveField(43)
  final double vu; // kN (Factored One-way Shear)
  @HiveField(44)
  final double vup; // kN (Factored Punching Shear)
  @HiveField(45)
  final double tauC; // N/mm^2 (Permissible shear)
  @HiveField(46)
  final double tauV; // N/mm^2 (Actual shear)
  @HiveField(47)
  final double effDepth; // mm

  // Metadata
  @HiveField(48)
  final String? errorMessage;

  FootingDesignState({
    this.type = FootingType.isolated,
    this.columnLoad = 800,
    this.columnLoad2 = 0,
    this.momentX = 0,
    this.momentY = 0,
    this.momentX2 = 0,
    this.momentY2 = 0,
    this.sbc = 200,
    this.foundationDepth = 1.5,
    this.unitWeightSoil = 18,
    this.footingLength = 2000,
    this.footingWidth = 2000,
    this.footingThickness = 450,
    this.columnSpacing = 0,
    this.colA = 300,
    this.colB = 300,
    this.pileCapacity = 500,
    this.pileDiameter = 450,
    this.pileCount = 0,
    this.requiredArea = 0,
    this.providedArea = 0,
    this.maxSoilPressure = 0,
    this.minSoilPressure = 0,
    this.qu = 0,
    this.eccentricityX = 0,
    this.eccentricityY = 0,
    this.concreteGrade = 'M25',
    this.steelGrade = 'Fe500',
    this.mainBarDia = 12,
    this.crossBarDia = 12,
    this.mainBarSpacing = 150,
    this.crossBarSpacing = 150,
    this.astRequiredX = 0,
    this.astRequiredY = 0,
    this.astProvidedX = 0,
    this.astProvidedY = 0,
    this.mu = 0,
    this.isAreaSafe = false,
    this.isOneWayShearSafe = false,
    this.isPunchingShearSafe = false,
    this.isBendingSafe = false,
    this.isSettlementWarning = false,
    this.vu = 0,
    this.vup = 0,
    this.tauC = 0,
    this.tauV = 0,
    this.effDepth = 0,
    this.errorMessage,
    this.projectId,
  });

  FootingDesignState copyWith({
    FootingType? type,
    double? columnLoad,
    double? columnLoad2,
    double? momentX,
    double? momentY,
    double? momentX2,
    double? momentY2,
    double? sbc,
    double? foundationDepth,
    double? unitWeightSoil,
    double? footingLength,
    double? footingWidth,
    double? footingThickness,
    double? columnSpacing,
    double? colA,
    double? colB,
    double? pileCapacity,
    double? pileDiameter,
    int? pileCount,
    double? requiredArea,
    double? providedArea,
    double? maxSoilPressure,
    double? minSoilPressure,
    double? qu,
    double? eccentricityX,
    double? eccentricityY,
    String? concreteGrade,
    String? steelGrade,
    double? mainBarDia,
    double? crossBarDia,
    double? mainBarSpacing,
    double? crossBarSpacing,
    double? astRequiredX,
    double? astRequiredY,
    double? astProvidedX,
    double? astProvidedY,
    double? mu,
    bool? isAreaSafe,
    bool? isOneWayShearSafe,
    bool? isPunchingShearSafe,
    bool? isBendingSafe,
    bool? isSettlementWarning,
    double? vu,
    double? vup,
    double? tauC,
    double? tauV,
    double? effDepth,
    String? errorMessage,
    String? projectId,
    bool clearError = false,
  }) {
    return FootingDesignState(
      type: type ?? this.type,
      columnLoad: columnLoad ?? this.columnLoad,
      columnLoad2: columnLoad2 ?? this.columnLoad2,
      momentX: momentX ?? this.momentX,
      momentY: momentY ?? this.momentY,
      momentX2: momentX2 ?? this.momentX2,
      momentY2: momentY2 ?? this.momentY2,
      sbc: sbc ?? this.sbc,
      foundationDepth: foundationDepth ?? this.foundationDepth,
      unitWeightSoil: unitWeightSoil ?? this.unitWeightSoil,
      footingLength: footingLength ?? this.footingLength,
      footingWidth: footingWidth ?? this.footingWidth,
      footingThickness: footingThickness ?? this.footingThickness,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      colA: colA ?? this.colA,
      colB: colB ?? this.colB,
      pileCapacity: pileCapacity ?? this.pileCapacity,
      pileDiameter: pileDiameter ?? this.pileDiameter,
      pileCount: pileCount ?? this.pileCount,
      requiredArea: requiredArea ?? this.requiredArea,
      providedArea: providedArea ?? this.providedArea,
      maxSoilPressure: maxSoilPressure ?? this.maxSoilPressure,
      minSoilPressure: minSoilPressure ?? this.minSoilPressure,
      qu: qu ?? this.qu,
      eccentricityX: eccentricityX ?? this.eccentricityX,
      eccentricityY: eccentricityY ?? this.eccentricityY,
      concreteGrade: concreteGrade ?? this.concreteGrade,
      steelGrade: steelGrade ?? this.steelGrade,
      mainBarDia: mainBarDia ?? this.mainBarDia,
      crossBarDia: crossBarDia ?? this.crossBarDia,
      mainBarSpacing: mainBarSpacing ?? this.mainBarSpacing,
      crossBarSpacing: crossBarSpacing ?? this.crossBarSpacing,
      astRequiredX: astRequiredX ?? this.astRequiredX,
      astRequiredY: astRequiredY ?? this.astRequiredY,
      astProvidedX: astProvidedX ?? this.astProvidedX,
      astProvidedY: astProvidedY ?? this.astProvidedY,
      mu: mu ?? this.mu,
      isAreaSafe: isAreaSafe ?? this.isAreaSafe,
      isOneWayShearSafe: isOneWayShearSafe ?? this.isOneWayShearSafe,
      isPunchingShearSafe: isPunchingShearSafe ?? this.isPunchingShearSafe,
      isBendingSafe: isBendingSafe ?? this.isBendingSafe,
      isSettlementWarning: isSettlementWarning ?? this.isSettlementWarning,
      vu: vu ?? this.vu,
      vup: vup ?? this.vup,
      tauC: tauC ?? this.tauC,
      tauV: tauV ?? this.tauV,
      effDepth: effDepth ?? this.effDepth,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      projectId: projectId ?? this.projectId,
    );
  }
}
