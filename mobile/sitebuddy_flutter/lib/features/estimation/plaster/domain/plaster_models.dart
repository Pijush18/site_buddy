
/// MODEL: PlasterInput
class PlasterInput {
  final double area;
  final double thickness;
  final String mortarRatio;

  PlasterInput({
    required this.area,
    required this.thickness,
    required this.mortarRatio,
  });
}

/// MODEL: PlasterMaterialResult
class PlasterMaterialResult {
  final double plasterArea;
  final double thickness;
  final double wetVolume;
  final double dryVolume;
  final double cementBags;
  final double cementWeight;
  final double sandVolume;
  final String mortarRatio;
  final double dryVolumeFactor;

  PlasterMaterialResult({
    required this.plasterArea,
    required this.thickness,
    required this.wetVolume,
    required this.dryVolume,
    required this.cementBags,
    required this.cementWeight,
    required this.sandVolume,
    required this.mortarRatio,
    required this.dryVolumeFactor,
  });

  Map<String, dynamic> toMap() => {
    'plasterArea': plasterArea,
    'thickness': thickness,
    'wetVolume': wetVolume,
    'dryVolume': dryVolume,
    'cementBags': cementBags,
    'cementWeight': cementWeight,
    'sandVolume': sandVolume,
    'mortarRatio': mortarRatio,
    'dryVolumeFactor': dryVolumeFactor,
  };
}
