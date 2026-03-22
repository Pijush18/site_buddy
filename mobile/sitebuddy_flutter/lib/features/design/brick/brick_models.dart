/// MODEL: BrickInput
/// PURPOSE: Strong-typed input for brick masonry design.
class BrickInput {
  final double length; // in metres
  final double height; // in metres
  final double thickness; // in metres
  final String mortarRatio; // e.g., "1:6"

  BrickInput({
    required this.length,
    required this.height,
    required this.thickness,
    required this.mortarRatio,
  });
}
