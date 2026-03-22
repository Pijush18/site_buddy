/// MODEL: ShutteringInput
/// PURPOSE: Strong-typed input for shuttering design.
class ShutteringInput {
  final double length;
  final double width;
  final double depth;
  final bool includeBottom;

  ShutteringInput({
    required this.length,
    required this.width,
    required this.depth,
    this.includeBottom = false,
  });
}
