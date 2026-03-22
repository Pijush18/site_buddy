
/// MODEL: BrickInput
class BrickInput {
  final double length;
  final double height;
  final double thickness;
  final String mortarRatio;

  BrickInput({
    required this.length,
    required this.height,
    required this.thickness,
    required this.mortarRatio,
  });
}

/// MODEL: BrickWallResult
class BrickWallResult {
  final double wallVolume;
  final int numberOfBricks;
  final double brickVolume;
  final double mortarVolume;
  final double dryMortarVolume;
  final double cementBags;
  final double cementWeight;
  final double sandVolume;
  final String mortarRatio;

  BrickWallResult({
    required this.wallVolume,
    required this.numberOfBricks,
    required this.brickVolume,
    required this.mortarVolume,
    required this.dryMortarVolume,
    required this.cementBags,
    required this.cementWeight,
    required this.sandVolume,
    required this.mortarRatio,
  });

  Map<String, dynamic> toMap() => {
    'wallVolume': wallVolume,
    'numberOfBricks': numberOfBricks,
    'brickVolume': brickVolume,
    'mortarVolume': mortarVolume,
    'dryMortarVolume': dryMortarVolume,
    'cementBags': cementBags,
    'cementWeight': cementWeight,
    'sandVolume': sandVolume,
    'mortarRatio': mortarRatio,
  };
}
