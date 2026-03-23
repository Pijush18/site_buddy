/// lib/core/config/canal_defaults.dart
///
/// Provider-based configuration for Canal/Irrigation module defaults.
/// 
/// PURPOSE:
/// - Extract hardcoded engineering defaults from calculators
/// - Enable configurable velocity thresholds per soil/crop type
/// - Allow runtime switching based on project requirements
library;

/// Canal module default values.
class CanalDefaults {
  /// Default side slope for trapezoidal canals (z:1)
  /// Typical: 1.5:1 for stable soil, 2:1 for erodible soil
  final double defaultSideSlope;

  /// Default longitudinal slope
  /// Typical: 0.0001 to 0.001 depending on terrain
  final double defaultSlope;

  /// Default canal lining material
  final String defaultMaterial;

  /// Minimum velocity to prevent silting (m/s)
  /// Below this, sediment deposits occur
  final double minVelocity;

  /// Maximum velocity to prevent scouring (m/s)
  /// Above this, channel erosion occurs
  final double maxVelocity;

  /// Efficiency threshold for optimization suggestion (%)
  /// Below this, optimization tip is shown
  final double efficiencyThreshold;

  /// Default bed width (m)
  final double defaultBedWidth;

  /// Default flow depth (m)
  final double defaultFlowDepth;

  const CanalDefaults({
    this.defaultSideSlope = 1.5,
    this.defaultSlope = 0.001,
    this.defaultMaterial = 'Concrete',
    this.minVelocity = 0.6,
    this.maxVelocity = 2.5,
    this.efficiencyThreshold = 90.0,
    this.defaultBedWidth = 3.0,
    this.defaultFlowDepth = 1.5,
  });

  /// Concrete-lined canal defaults
  static const CanalDefaults concrete = CanalDefaults(
    defaultSideSlope: 1.5,
    defaultSlope: 0.001,
    defaultMaterial: 'Concrete',
    minVelocity: 0.6,
    maxVelocity: 2.5,
    efficiencyThreshold: 90.0,
  );

  /// Earth canal defaults (unlined)
  static const CanalDefaults earth = CanalDefaults(
    defaultSideSlope: 2.0,
    defaultSlope: 0.0005,
    defaultMaterial: 'Earth',
    minVelocity: 0.3,
    maxVelocity: 1.5,
    efficiencyThreshold: 85.0,
  );

  /// Brick-lined canal defaults
  static const CanalDefaults brick = CanalDefaults(
    defaultSideSlope: 1.5,
    defaultSlope: 0.001,
    defaultMaterial: 'Brick',
    minVelocity: 0.5,
    maxVelocity: 2.0,
    efficiencyThreshold: 88.0,
  );

  /// Gravel-lined canal defaults
  static const CanalDefaults gravel = CanalDefaults(
    defaultSideSlope: 2.0,
    defaultSlope: 0.002,
    defaultMaterial: 'Gravel',
    minVelocity: 0.4,
    maxVelocity: 1.8,
    efficiencyThreshold: 85.0,
  );

  CanalDefaults copyWith({
    double? defaultSideSlope,
    double? defaultSlope,
    String? defaultMaterial,
    double? minVelocity,
    double? maxVelocity,
    double? efficiencyThreshold,
    double? defaultBedWidth,
    double? defaultFlowDepth,
  }) {
    return CanalDefaults(
      defaultSideSlope: defaultSideSlope ?? this.defaultSideSlope,
      defaultSlope: defaultSlope ?? this.defaultSlope,
      defaultMaterial: defaultMaterial ?? this.defaultMaterial,
      minVelocity: minVelocity ?? this.minVelocity,
      maxVelocity: maxVelocity ?? this.maxVelocity,
      efficiencyThreshold: efficiencyThreshold ?? this.efficiencyThreshold,
      defaultBedWidth: defaultBedWidth ?? this.defaultBedWidth,
      defaultFlowDepth: defaultFlowDepth ?? this.defaultFlowDepth,
    );
  }

  /// Returns velocity safety message based on calculated velocity
  String evaluateVelocitySafety(double velocity) {
    if (velocity < minVelocity) {
      return "SILTING RISK: v < ${minVelocity.toStringAsFixed(1)} m/s";
    }
    if (velocity > maxVelocity) {
      return "SCOURING RISK: v > ${maxVelocity.toStringAsFixed(1)} m/s";
    }
    return "SAFE VELOCITY: Non-silting/scouring";
  }
}
