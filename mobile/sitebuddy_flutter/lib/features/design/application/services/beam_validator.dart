

/// UTILITY: BeamValidator
/// PURPOSE: Validates engineering constraints for Beam Design.
class BeamValidator {
  static String? validateGeometry({
    required double span,
    required double width,
    required double depth,
  }) {
    if (span <= 0) return 'Span must be greater than zero.';
    if (width < 200) return 'Minimum width for beams is 200mm per IS 456.';
    if (depth < 150) return 'Depth is too small for structural beams.';
    if (depth > span / 2) return 'Depth looks unrealistic (D > L/2).';
    return null;
  }

  static String? validateLoads({
    required double deadLoad,
    required double liveLoad,
  }) {
    if (deadLoad < 0 || liveLoad < 0) return 'Loads cannot be negative.';
    if (deadLoad + liveLoad == 0) return 'At least one load must be defined.';
    return null;
  }
}
