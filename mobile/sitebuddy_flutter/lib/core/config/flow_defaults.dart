/// lib/core/config/flow_defaults.dart
///
/// Provider-based configuration for Flow Simulation module defaults.
/// 
/// PURPOSE:
/// - Extract hardcoded simulation parameters from calculators
/// - Enable configurable defaults per project type
/// - Allow runtime adjustment based on user preferences
library;

/// Flow simulation default values.
class FlowSimulationDefaults {
  /// Default initial velocity (m/s)
  /// Typical design velocity for canals: 0.5-2.0 m/s
  final double defaultVelocity;

  /// Default initial depth (m)
  /// Typical flow depth: 1.0-2.0 m
  final double defaultDepth;

  /// Default bed width (m)
  /// Typical canal width: 2.0-5.0 m
  final double defaultWidth;

  /// Default longitudinal slope
  /// Typical: 0.0001 to 0.001
  final double defaultSlope;

  /// Default Manning's roughness coefficient
  /// Concrete: 0.013, Earth: 0.025, Brick: 0.015
  final double defaultRoughness;

  /// Default channel length for simulation (m)
  /// Typical: 100-500 m per reach
  final double defaultLength;

  /// Default number of segments for numerical simulation
  /// More segments = higher precision but slower
  final int defaultSegments;

  const FlowSimulationDefaults({
    this.defaultVelocity = 1.0,
    this.defaultDepth = 1.5,
    this.defaultWidth = 3.0,
    this.defaultSlope = 0.001,
    this.defaultRoughness = 0.013,
    this.defaultLength = 100.0,
    this.defaultSegments = 10,
  });

  /// High precision simulation defaults (more segments)
  static const FlowSimulationDefaults highPrecision = FlowSimulationDefaults(
    defaultVelocity: 1.0,
    defaultDepth: 1.5,
    defaultWidth: 3.0,
    defaultSlope: 0.001,
    defaultRoughness: 0.013,
    defaultLength: 100.0,
    defaultSegments: 50,
  );

  /// Quick estimate defaults (fewer segments)
  static const FlowSimulationDefaults quickEstimate = FlowSimulationDefaults(
    defaultVelocity: 1.0,
    defaultDepth: 1.5,
    defaultWidth: 3.0,
    defaultSlope: 0.001,
    defaultRoughness: 0.013,
    defaultLength: 100.0,
    defaultSegments: 5,
  );

  /// Earth channel defaults
  static const FlowSimulationDefaults earthChannel = FlowSimulationDefaults(
    defaultVelocity: 0.8,
    defaultDepth: 2.0,
    defaultWidth: 4.0,
    defaultSlope: 0.0005,
    defaultRoughness: 0.025,
    defaultLength: 200.0,
    defaultSegments: 10,
  );

  /// Concrete channel defaults
  static const FlowSimulationDefaults concreteChannel = FlowSimulationDefaults(
    defaultVelocity: 1.5,
    defaultDepth: 1.5,
    defaultWidth: 3.0,
    defaultSlope: 0.001,
    defaultRoughness: 0.013,
    defaultLength: 100.0,
    defaultSegments: 10,
  );

  FlowSimulationDefaults copyWith({
    double? defaultVelocity,
    double? defaultDepth,
    double? defaultWidth,
    double? defaultSlope,
    double? defaultRoughness,
    double? defaultLength,
    int? defaultSegments,
  }) {
    return FlowSimulationDefaults(
      defaultVelocity: defaultVelocity ?? this.defaultVelocity,
      defaultDepth: defaultDepth ?? this.defaultDepth,
      defaultWidth: defaultWidth ?? this.defaultWidth,
      defaultSlope: defaultSlope ?? this.defaultSlope,
      defaultRoughness: defaultRoughness ?? this.defaultRoughness,
      defaultLength: defaultLength ?? this.defaultLength,
      defaultSegments: defaultSegments ?? this.defaultSegments,
    );
  }
}
