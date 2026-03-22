/// CLASS: BrickEstimatorResult
class BrickEstimatorResult {
  final double numberOfBricks;
  final double mortarVolume;
  final double wallVolume;

  const BrickEstimatorResult({
    required this.numberOfBricks,
    required this.mortarVolume,
    required this.wallVolume,
  });

  Map<String, dynamic> toMap() {
    return {
      'number_of_bricks': numberOfBricks,
      'mortar_volume': mortarVolume,
      'wall_volume': wallVolume,
    };
  }
}
