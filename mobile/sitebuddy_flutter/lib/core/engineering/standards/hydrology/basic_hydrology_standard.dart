import 'package:site_buddy/core/engineering/standards/hydrology/hydrology_standard.dart';

/// lib/core/engineering/standards/hydrology/basic_hydrology_standard.dart
///
/// Basic Implementation of HydrologyStandard using the Area-Velocity method (Q = A × V).
class BasicHydrologyStandard implements HydrologyStandard {
  @override
  String get methodologyIdentifier => 'Area-Velocity Method';

  @override
  double computeDischarge({required double area, required double velocity}) {
    // Discharge Q = Cross-sectional Area (A) × Mean Velocity (V)
    return area * velocity;
  }

  @override
  double manningCoefficient(String material) {
    switch (material.toLowerCase()) {
      case 'concrete': return 0.013;
      case 'earth': return 0.025;
      case 'brick': return 0.015;
      case 'gravel': return 0.020;
      default: return 0.013;
    }
  }

  @override
  Map<String, double> slopeLimits(String canalType) {
    return {
      'min': 0.0001,
      'max': 0.0050,
      'recommended': 0.0010,
    };
  }

  @override
  String slopeGuidance(String material) {
    if (material == 'Concrete') return 'Permissible: 1:500 to 1:2000';
    if (material == 'Earth') return 'Permissible: 1:2000 to 1:5000 (Avoid scouring)';
    return 'Permissible: 1:1000 to 1:3000';
  }
}
