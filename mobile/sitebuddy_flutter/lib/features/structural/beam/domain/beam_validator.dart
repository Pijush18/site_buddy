

/// SERVICE: BeamValidator
/// PURPOSE: Validates beam design inputs before calculation.
class BeamValidator {
  static String? validateGeometry({
    required double span,
    required double width,
    required double depth,
  }) {
    if (span <= 0) return 'Span must be greater than zero.';
    if (width <= 0) return 'Width must be greater than zero.';
    if (depth <= 0) return 'Depth must be greater than zero.';
    if (width > depth) return 'Width should typically be less than or equal to depth.';
    return null;
  }

  static String? validateLoads({
    required double deadLoad,
    required double liveLoad,
  }) {
    if (deadLoad < 0 || liveLoad < 0) {
      return 'Loads cannot be negative.';
    }
    return null;
  }
}
