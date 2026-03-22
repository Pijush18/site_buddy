import 'dart:math';
import 'package:hive/hive.dart';
import 'package:site_buddy/features/structural/column/domain/column_enums.dart';

part 'column_design_state.g.dart';

/// ENTITY: ColumnDesignState
/// PURPOSE: Holds all parameters and results for Column Design workflow.
@HiveType(typeId: 2)
class ColumnDesignState {
  @HiveField(0)
  final String? projectId;

  double get astProvided => numBars * (pi * mainBarDia * mainBarDia / 4);

  // Step 1: Geometry & Materials
  @HiveField(1)
  final ColumnType type;
  @HiveField(2)
  final double b; // Width or Diameter (mm)
  @HiveField(3)
  final double d; // Depth (mm)
  @HiveField(4)
  final double length; // mm
  @HiveField(5)
  final EndCondition endCondition;
  @HiveField(6)
  final double cover; // mm
  @HiveField(7)
  final String concreteGrade;
  @HiveField(8)
  final String steelGrade;

  // Step 2: Loads
  @HiveField(9)
  final double pu; // kN
  @HiveField(10)
  final double mx; // kNm
  @HiveField(11)
  final double my; // kNm
  @HiveField(12)
  final LoadType loadType;

  // Step 3: Slenderness
  @HiveField(13)
  final double lex; // effective length (mm)
  @HiveField(14)
  final double ley; // effective length (mm)
  @HiveField(15)
  final double slendernessX;
  @HiveField(16)
  final double slendernessY;
  @HiveField(17)
  final bool isShort;
  @HiveField(18)
  final double eminX;
  @HiveField(19)
  final double eminY;

  // Step 4: Design
  @HiveField(20)
  final double astRequired; // mm^2
  @HiveField(21)
  final double steelPercentage;
  @HiveField(22)
  final double ag; // Gross area (mm^2)
  @HiveField(23)
  final bool isAutoSteel;
  @HiveField(24)
  final DesignMethod designMethod;

  // Step 5: Detailing
  @HiveField(25)
  final double mainBarDia;
  @HiveField(26)
  final int numBars;
  @HiveField(27)
  final double tieDia;
  @HiveField(28)
  final double tieSpacing;

  // Step 6: Safety
  @HiveField(29)
  final bool isSlendernessSafe;
  @HiveField(30)
  final bool isCapacitySafe;
  @HiveField(31)
  final bool isReinforcementSafe;
  @HiveField(32)
  final double interactionRatio;
  @HiveField(33)
  final double magnifiedMx;
  @HiveField(34)
  final double magnifiedMy;
  @HiveField(35)
  final ColumnFailureMode failureMode;
  @HiveField(36)
  final String? errorMessage;
  @HiveField(37)
  final bool isOptimizing;

  ColumnDesignState({
    this.type = ColumnType.rectangular,
    this.b = 300,
    this.d = 300,
    this.length = 3000,
    this.endCondition = EndCondition.fixed,
    this.cover = 40,
    this.concreteGrade = 'M25',
    this.steelGrade = 'Fe500',
    this.pu = 1000,
    this.mx = 0,
    this.my = 0,
    this.loadType = LoadType.axial,
    this.lex = 0,
    this.ley = 0,
    this.slendernessX = 0,
    this.slendernessY = 0,
    this.isShort = true,
    this.eminX = 20,
    this.eminY = 20,
    this.astRequired = 0,
    this.steelPercentage = 0,
    this.ag = 0,
    this.isAutoSteel = true,
    this.designMethod = DesignMethod.analytical,
    this.mainBarDia = 16,
    this.numBars = 4,
    this.tieDia = 8,
    this.tieSpacing = 300,
    this.isSlendernessSafe = false,
    this.isCapacitySafe = false,
    this.isReinforcementSafe = false,
    this.interactionRatio = 0,
    this.magnifiedMx = 0,
    this.magnifiedMy = 0,
    this.failureMode = ColumnFailureMode.axial,
    this.errorMessage,
    this.isOptimizing = false,
    this.projectId,
  });

  ColumnDesignState copyWith({
    ColumnType? type,
    double? b,
    double? d,
    double? length,
    EndCondition? endCondition,
    double? cover,
    String? concreteGrade,
    String? steelGrade,
    double? pu,
    double? mx,
    double? my,
    LoadType? loadType,
    double? lex,
    double? ley,
    double? slendernessX,
    double? slendernessY,
    bool? isShort,
    double? eminX,
    double? eminY,
    double? astRequired,
    double? steelPercentage,
    double? ag,
    bool? isAutoSteel,
    DesignMethod? designMethod,
    double? mainBarDia,
    int? numBars,
    double? tieDia,
    double? tieSpacing,
    bool? isSlendernessSafe,
    bool? isCapacitySafe,
    bool? isReinforcementSafe,
    double? interactionRatio,
    double? magnifiedMx,
    double? magnifiedMy,
    ColumnFailureMode? failureMode,
    String? errorMessage,
    bool clearError = false,
    bool? isOptimizing,
    String? projectId,
  }) {
    return ColumnDesignState(
      type: type ?? this.type,
      b: b ?? this.b,
      d: d ?? this.d,
      length: length ?? this.length,
      endCondition: endCondition ?? this.endCondition,
      cover: cover ?? this.cover,
      concreteGrade: concreteGrade ?? this.concreteGrade,
      steelGrade: steelGrade ?? this.steelGrade,
      pu: pu ?? this.pu,
      mx: mx ?? this.mx,
      my: my ?? this.my,
      loadType: loadType ?? this.loadType,
      lex: lex ?? this.lex,
      ley: ley ?? this.ley,
      slendernessX: slendernessX ?? this.slendernessX,
      slendernessY: slendernessY ?? this.slendernessY,
      isShort: isShort ?? this.isShort,
      eminX: eminX ?? this.eminX,
      eminY: eminY ?? this.eminY,
      astRequired: astRequired ?? this.astRequired,
      steelPercentage: steelPercentage ?? this.steelPercentage,
      ag: ag ?? this.ag,
      isAutoSteel: isAutoSteel ?? this.isAutoSteel,
      designMethod: designMethod ?? this.designMethod,
      mainBarDia: mainBarDia ?? this.mainBarDia,
      numBars: numBars ?? this.numBars,
      tieDia: tieDia ?? this.tieDia,
      tieSpacing: tieSpacing ?? this.tieSpacing,
      isSlendernessSafe: isSlendernessSafe ?? this.isSlendernessSafe,
      isCapacitySafe: isCapacitySafe ?? this.isCapacitySafe,
      isReinforcementSafe: isReinforcementSafe ?? this.isReinforcementSafe,
      interactionRatio: interactionRatio ?? this.interactionRatio,
      magnifiedMx: magnifiedMx ?? this.magnifiedMx,
      magnifiedMy: magnifiedMy ?? this.magnifiedMy,
      failureMode: failureMode ?? this.failureMode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isOptimizing: isOptimizing ?? this.isOptimizing,
      projectId: projectId ?? this.projectId,
    );
  }
}




