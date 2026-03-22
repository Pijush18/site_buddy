import 'package:hive/hive.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_type.dart';

part 'beam_design_state.g.dart';

/// MODEL: DiagramPoint
/// PURPOSE: A single point on a BMD or SFD curve.
@HiveType(typeId: 9)
class DiagramPoint {
  @HiveField(0)
  final double x; // mm
  @HiveField(1)
  final double value; // kN or kNm
  DiagramPoint(this.x, this.value);
}

/// MODEL: DesignSuggestion
/// PURPOSE: Engineering advice for improving the design.
@HiveType(typeId: 10)
class DesignSuggestion {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String action;
  DesignSuggestion({
    required this.title,
    required this.description,
    required this.action,
  });
}

/// ENTITY: BeamDesignState
/// PURPOSE: Professional-grade state for Beam Design (IS 456:2000).
@HiveType(typeId: 11)
class BeamDesignState {
  @HiveField(0)
  final String? projectId;
  // 1. Basic Inputs
  @HiveField(1)
  final BeamType type;
  @HiveField(2)
  final double span; // mm
  @HiveField(3)
  final double width; // mm
  @HiveField(4)
  final double overallDepth; // mm
  @HiveField(5)
  final double cover; // mm
  @HiveField(6)
  final String concreteGrade;
  @HiveField(7)
  final String steelGrade;

  // 2. Loads
  @HiveField(8)
  final double deadLoad; // kN/m
  @HiveField(9)
  final double liveLoad; // kN/m
  @HiveField(10)
  final double pointLoad; // kN
  @HiveField(11)
  final bool isULS;

  // 3. Analysis Results
  @HiveField(12)
  final double mu; // kNm
  @HiveField(13)
  final double vu; // kN
  @HiveField(14)
  final double wu; // kN/m
  @HiveField(15)
  final List<DiagramPoint> sfdPoints;
  @HiveField(16)
  final List<DiagramPoint> bmdPoints;

  // 4. Reinforcement (Flexure)
  @HiveField(17)
  final double mainBarDia;
  @HiveField(18)
  final int numBars;
  @HiveField(19)
  final double astRequired;
  @HiveField(20)
  final double astProvided;
  @HiveField(21)
  final double astMin;
  @HiveField(22)
  final double astMax;
  @HiveField(23)
  final double xu;
  @HiveField(24)
  final double xuMax;
  @HiveField(25)
  final bool isAutoDesign;

  // 5. Reinforcement (Shear)
  @HiveField(26)
  final double stirrupDia;
  @HiveField(27)
  final double stirrupSpacing;
  @HiveField(28)
  final int stirrupLegs;
  @HiveField(29)
  final double tv;
  @HiveField(30)
  final double tc;
  @HiveField(31)
  final double tcMax;

  // 6. Safety & Insights
  @HiveField(32)
  final bool isFlexureSafe;
  @HiveField(33)
  final bool isShearSafe;
  @HiveField(34)
  final bool isDeflectionSafe;
  @HiveField(35)
  final List<DesignSuggestion> suggestions;
  @HiveField(36)
  final String? errorMessage;

  // 7. Optimization
  @HiveField(37)
  final bool isOptimizing;

  BeamDesignState({
    this.type = BeamType.simplySupported,
    this.span = 0,
    this.width = 0,
    this.overallDepth = 0,
    this.cover = 25,
    this.concreteGrade = 'M25',
    this.steelGrade = 'Fe500',
    this.deadLoad = 0,
    this.liveLoad = 0,
    this.pointLoad = 0,
    this.isULS = true,
    this.mu = 0,
    this.vu = 0,
    this.wu = 0,
    this.sfdPoints = const [],
    this.bmdPoints = const [],
    this.mainBarDia = 16,
    this.numBars = 0,
    this.astRequired = 0,
    this.astProvided = 0,
    this.astMin = 0,
    this.astMax = 0,
    this.xu = 0,
    this.xuMax = 0,
    this.isAutoDesign = true,
    this.stirrupDia = 8,
    this.stirrupSpacing = 0,
    this.stirrupLegs = 2,
    this.tv = 0,
    this.tc = 0,
    this.tcMax = 0,
    this.isFlexureSafe = false,
    this.isShearSafe = false,
    this.isDeflectionSafe = false,
    this.suggestions = const [],
    this.errorMessage,
    this.isOptimizing = false,
    this.projectId,
  });

  BeamDesignState copyWith({
    BeamType? type,
    double? span,
    double? width,
    double? overallDepth,
    double? cover,
    String? concreteGrade,
    String? steelGrade,
    double? deadLoad,
    double? liveLoad,
    double? pointLoad,
    bool? isULS,
    double? mu,
    double? vu,
    double? wu,
    List<DiagramPoint>? sfdPoints,
    List<DiagramPoint>? bmdPoints,
    double? mainBarDia,
    int? numBars,
    double? astRequired,
    double? astProvided,
    double? astMin,
    double? astMax,
    double? xu,
    double? xuMax,
    bool? isAutoDesign,
    double? stirrupDia,
    double? stirrupSpacing,
    int? stirrupLegs,
    double? tv,
    double? tc,
    double? tcMax,
    bool? isFlexureSafe,
    bool? isShearSafe,
    bool? isDeflectionSafe,
    List<DesignSuggestion>? suggestions,
    String? errorMessage,
    bool? isOptimizing,
    String? projectId,
    bool clearError = false,
  }) {
    return BeamDesignState(
      type: type ?? this.type,
      span: span ?? this.span,
      width: width ?? this.width,
      overallDepth: overallDepth ?? this.overallDepth,
      cover: cover ?? this.cover,
      concreteGrade: concreteGrade ?? this.concreteGrade,
      steelGrade: steelGrade ?? this.steelGrade,
      deadLoad: deadLoad ?? this.deadLoad,
      liveLoad: liveLoad ?? this.liveLoad,
      pointLoad: pointLoad ?? this.pointLoad,
      isULS: isULS ?? this.isULS,
      mu: mu ?? this.mu,
      vu: vu ?? this.vu,
      wu: wu ?? this.wu,
      sfdPoints: sfdPoints ?? this.sfdPoints,
      bmdPoints: bmdPoints ?? this.bmdPoints,
      mainBarDia: mainBarDia ?? this.mainBarDia,
      numBars: numBars ?? this.numBars,
      astRequired: astRequired ?? this.astRequired,
      astProvided: astProvided ?? this.astProvided,
      astMin: astMin ?? this.astMin,
      astMax: astMax ?? this.astMax,
      xu: xu ?? this.xu,
      xuMax: xuMax ?? this.xuMax,
      isAutoDesign: isAutoDesign ?? this.isAutoDesign,
      stirrupDia: stirrupDia ?? this.stirrupDia,
      stirrupSpacing: stirrupSpacing ?? this.stirrupSpacing,
      stirrupLegs: stirrupLegs ?? this.stirrupLegs,
      tv: tv ?? this.tv,
      tc: tc ?? this.tc,
      tcMax: tcMax ?? this.tcMax,
      isFlexureSafe: isFlexureSafe ?? this.isFlexureSafe,
      isShearSafe: isShearSafe ?? this.isShearSafe,
      isDeflectionSafe: isDeflectionSafe ?? this.isDeflectionSafe,
      suggestions: suggestions ?? this.suggestions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isOptimizing: isOptimizing ?? this.isOptimizing,
      projectId: projectId ?? this.projectId,
    );
  }

  double get effectiveDepth => overallDepth - cover - (mainBarDia / 2);
  double get b => width;
  double get d => effectiveDepth;
}




