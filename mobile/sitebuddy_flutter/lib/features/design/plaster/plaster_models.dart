/// MODEL: PlasterInput
/// PURPOSE: Strong-typed input for plastering design.
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
