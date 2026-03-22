/// MODEL: ExcavationInput
/// PURPOSE: Strong-typed input for excavation design.
class ExcavationInput {
  final double length;
  final double width;
  final double depth;
  final double clearance;
  final double swellFactor;

  ExcavationInput({
    required this.length,
    required this.width,
    required this.depth,
    this.clearance = 0.3,
    this.swellFactor = 1.25,
  });
}
