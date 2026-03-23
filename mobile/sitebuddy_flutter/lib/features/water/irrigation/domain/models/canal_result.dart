
/// MODEL: CanalResult
/// PURPOSE: Calculation results for canal design using Manning's formula.
/// 
/// DOMAIN PURITY: This model contains ONLY computed engineering results.
/// No user plan or subscription information.
/// Policy decisions are handled in the Application layer.
class CanalResult {
  final double discharge;       // Q (m³/s)
  final double velocity;        // V (m/s)
  final double crossArea;      // A (m²)
  final double wettedPerimeter; // P (m)
  final double hydraulicRadius; // R (m)
  final double efficiency;      // Section efficiency (%)
  final String safetyNote;
  final double? optimizationSuggestion; // Computed but shown conditionally

  const CanalResult({
    required this.discharge,
    required this.velocity,
    required this.crossArea,
    required this.wettedPerimeter,
    required this.hydraulicRadius,
    required this.efficiency,
    required this.safetyNote,
    this.optimizationSuggestion,
  });

  Map<String, dynamic> toMap() => {
    'discharge': discharge,
    'velocity': velocity,
    'crossArea': crossArea,
    'wettedPerimeter': wettedPerimeter,
    'hydraulicRadius': hydraulicRadius,
    'efficiency': efficiency,
    'safetyNote': safetyNote,
    'optimizationSuggestion': optimizationSuggestion,
  };
}
