
/// MODEL: CanalResult
/// PURPOSE: Calculation results for canal design using Manning's formula.
class CanalResult {
  final double discharge;       // Q (m³/s)
  final double velocity;        // V (m/s)
  final double crossArea;      // A (m²)
  final double wettedPerimeter; // P (m)
  final double hydraulicRadius; // R (m)
  final double efficiency;      // Section efficiency (%)
  final bool isOptimized;       // Pro feature flag
  final String safetyNote;

  const CanalResult({
    required this.discharge,
    required this.velocity,
    required this.crossArea,
    required this.wettedPerimeter,
    required this.hydraulicRadius,
    required this.efficiency,
    this.isOptimized = false,
    required this.safetyNote,
  });

  Map<String, dynamic> toMap() => {
    'discharge': discharge,
    'velocity': velocity,
    'crossArea': crossArea,
    'wettedPerimeter': wettedPerimeter,
    'hydraulicRadius': hydraulicRadius,
    'efficiency': efficiency,
    'isOptimized': isOptimized,
    'safetyNote': safetyNote,
  };
}
