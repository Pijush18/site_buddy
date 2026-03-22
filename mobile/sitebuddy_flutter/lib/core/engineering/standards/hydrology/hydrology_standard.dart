/// lib/core/engineering/standards/hydrology/hydrology_standard.dart
///
/// Abstract interface defining the standard requirements for Hydrology and Water engineering.
/// This is isolated from Structural (RCC) and Transport (Road) standards.
abstract class HydrologyStandard {
  /// Unique identifier for the design code or method.
  String get methodologyIdentifier;

  /// Calculates the rate of flow (discharge Q) in cubic metres per second (m³/s).
  double computeDischarge({required double area, required double velocity});

  /// Returns the Manning's roughness coefficient (n) for a given surface material.
  double manningCoefficient(String material);

  /// Returns the recommended slope limits (S) for a given canal type.
  Map<String, double> slopeLimits(String canalType);

  /// Provides textual guidance on slope selection based on material.
  String slopeGuidance(String material);
}
