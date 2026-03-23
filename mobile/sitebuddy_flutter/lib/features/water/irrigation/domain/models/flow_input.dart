
/// MODEL: FlowInput
/// PURPOSE: Input parameters for longitudinal water flow simulation.
/// 
/// DOMAIN PURITY: This model contains ONLY business parameters.
/// No user plan or subscription information.
class FlowInput {
  final double initialVelocity;   // V0 (m/s)
  final double initialDepth;      // y0 (m) - Added for hydraulic consistency
  final double bedWidth;          // b (m)
  final double slope;             // S
  final double roughness;         // n (Manning)
  final double totalLength;       // L (m)
  final int segments;             // Number of steps for simulation

  const FlowInput({
    required this.initialVelocity,
    required this.initialDepth,
    required this.bedWidth,
    required this.slope,
    required this.roughness,
    required this.totalLength,
    this.segments = 10,
  });
}
