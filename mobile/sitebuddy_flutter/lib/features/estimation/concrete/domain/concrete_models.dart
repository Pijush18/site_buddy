
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';

/// MODEL: ConcreteInput
class ConcreteInput {
  final double length;
  final double width;
  final double depth;
  final ConcreteMix? grade;
  final double steelPercentage;

  ConcreteInput({
    required this.length,
    required this.width,
    required this.depth,
    this.grade,
    this.steelPercentage = 0.0,
  });
}

/// MODEL: ConcreteMaterialResult
class ConcreteMaterialResult {
  final double concreteVolume;
  final double cementBags;
  final double cementWeight;
  final double sandVolume;
  final double aggregateVolume;
  final double steelWeight;
  final double bindingWire;
  final String concreteGrade;
  final double dryVolumeFactor;

  ConcreteMaterialResult({
    required this.concreteVolume,
    required this.cementBags,
    required this.cementWeight,
    required this.sandVolume,
    required this.aggregateVolume,
    required this.steelWeight,
    required this.bindingWire,
    required this.concreteGrade,
    required this.dryVolumeFactor,
  });

  Map<String, dynamic> toMap() => {
    'concreteVolume': concreteVolume,
    'cementBags': cementBags,
    'cementWeight': cementWeight,
    'sandVolume': sandVolume,
    'aggregateVolume': aggregateVolume,
    'steelWeight': steelWeight,
    'bindingWire': bindingWire,
    'concreteGrade': concreteGrade,
    'dryVolumeFactor': dryVolumeFactor,
  };
}
