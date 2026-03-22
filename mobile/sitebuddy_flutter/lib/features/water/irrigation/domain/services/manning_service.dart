
import 'dart:math' as math;

/// SERVICE: ManningService
/// PURPOSE: Pure mathematical implementation of Manning's formula.
class ManningService {
  
  /// Calculates discharge (Q) using Q = (1/n) * A * R^(2/3) * S^(1/2)
  double calculateDischarge({
    required double n,
    required double area,
    required double hydraulicRadius,
    required double slope,
  }) {
    if (n <= 0 || slope <= 0) return 0.0;
    return (1.0 / n) * area * math.pow(hydraulicRadius, 2.0 / 3.0) * math.sqrt(slope);
  }

  /// Calculates velocity (V) using V = (1/n) * R^(2/3) * S^(1/2)
  double calculateVelocity({
    required double n,
    required double hydraulicRadius,
    required double slope,
  }) {
    if (n <= 0 || slope <= 0) return 0.0;
    return (1.0 / n) * math.pow(hydraulicRadius, 2.0 / 3.0) * math.sqrt(slope);
  }
}
