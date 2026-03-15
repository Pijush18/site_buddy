import 'package:site_buddy/shared/domain/models/design/slab_type.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/shared/domain/models/design_result.dart';

/// BASE: DesignInput
abstract class DesignInput {
  const DesignInput();
}

// --- SLAB ---

class SlabDesignInputs extends DesignInput {
  final SlabType type;
  final double lx;
  final double ly;
  final double depth;
  final double deadLoad;
  final double liveLoad;
  final String concreteGrade;
  final String steelGrade;
  final double cover;

  const SlabDesignInputs({
    required this.type,
    required this.lx,
    required this.ly,
    required this.depth,
    required this.deadLoad,
    required this.liveLoad,
    this.concreteGrade = 'M25',
    this.steelGrade = 'Fe500',
    this.cover = 20.0,
  });
}

class SlabDesignOutputs extends DesignResult {
  final double bendingMoment;
  final String mainRebar;
  final String distributionSteel;
  final bool isShearSafe;
  final bool isDeflectionSafe;
  final bool isCrackingSafe;
  final double astProvided;
  final double astRequired;

  const SlabDesignOutputs({
    required this.bendingMoment,
    required this.mainRebar,
    required this.distributionSteel,
    this.isShearSafe = true,
    this.isDeflectionSafe = true,
    this.isCrackingSafe = true,
    this.astProvided = 0,
    this.astRequired = 0,
  });

  @override
  Map<String, dynamic> toJson() => {
    'bendingMoment': bendingMoment,
    'mainRebar': mainRebar,
    'distributionSteel': distributionSteel,
    'isShearSafe': isShearSafe,
    'isDeflectionSafe': isDeflectionSafe,
    'isCrackingSafe': isCrackingSafe,
    'astProvided': astProvided,
    'astRequired': astRequired,
  };
}

// --- BEAM ---

class BeamDesignInputs extends DesignInput {
  final BeamType type;
  final double span;
  final double width;
  final double overallDepth;
  final double cover;
  final String concreteGrade;
  final String steelGrade;
  final double deadLoad;
  final double liveLoad;
  final double pointLoad;

  const BeamDesignInputs({
    required this.type,
    required this.span,
    required this.width,
    required this.overallDepth,
    required this.cover,
    required this.concreteGrade,
    required this.steelGrade,
    required this.deadLoad,
    required this.liveLoad,
    this.pointLoad = 0,
  });
}

class BeamDesignOutputs extends DesignResult {
  final double bendingMoment;
  final double shearForce;
  final String topRebar;
  final String bottomRebar;
  final String stirrups;
  final bool isFlexureSafe;
  final bool isShearSafe;
  final bool isDeflectionSafe;

  const BeamDesignOutputs({
    required this.bendingMoment,
    required this.shearForce,
    required this.topRebar,
    required this.bottomRebar,
    required this.stirrups,
    required this.isFlexureSafe,
    required this.isShearSafe,
    required this.isDeflectionSafe,
  });

  @override
  Map<String, dynamic> toJson() => {
    'bendingMoment': bendingMoment,
    'shearForce': shearForce,
    'topRebar': topRebar,
    'bottomRebar': bottomRebar,
    'stirrups': stirrups,
    'isFlexureSafe': isFlexureSafe,
    'isShearSafe': isShearSafe,
    'isDeflectionSafe': isDeflectionSafe,
  };
}

// --- COLUMN ---

class ColumnDesignInputs extends DesignInput {
  final ColumnType type;
  final double b; // Width or Diameter
  final double d; // Depth (for rectangular)
  final double length;
  final EndCondition endCondition;
  final double cover;
  final String concreteGrade;
  final String steelGrade;
  final double pu; // Factored Axial Load
  final double mx; // Factored Moment X
  final double my; // Factored Moment Y

  const ColumnDesignInputs({
    required this.type,
    required this.b,
    this.d = 0,
    required this.length,
    required this.endCondition,
    required this.cover,
    required this.concreteGrade,
    required this.steelGrade,
    required this.pu,
    this.mx = 0,
    this.my = 0,
  });
}

class ColumnDesignOutputs extends DesignResult {
  final String reinforcement;
  final String ties;
  final double interactionRatio;
  final bool isCapacitySafe;
  final bool isSlendernessSafe;

  const ColumnDesignOutputs({
    required this.reinforcement,
    required this.ties,
    required this.interactionRatio,
    required this.isCapacitySafe,
    required this.isSlendernessSafe,
  });

  @override
  Map<String, dynamic> toJson() => {
    'reinforcement': reinforcement,
    'ties': ties,
    'interactionRatio': interactionRatio,
    'isCapacitySafe': isCapacitySafe,
    'isSlendernessSafe': isSlendernessSafe,
  };
}
