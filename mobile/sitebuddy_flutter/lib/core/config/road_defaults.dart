/// lib/core/config/road_defaults.dart
///
/// Provider-based configuration for Road module defaults.
/// 
/// PURPOSE:
/// - Extract hardcoded engineering defaults from calculators
/// - Enable multi-country support via configurable providers
/// - Allow runtime switching of standards based on region
library;

/// Road module default values.
/// These are IRC-India specific by default, but can be overridden.
class RoadDefaults {
  /// Default initial traffic (CVPD - Commercial Vehicles Per Day)
  /// IRC typical urban: 1500, rural: 300-500
  final double defaultInitialTraffic;

  /// Default annual traffic growth rate (%)
  /// IRC India: 5-7%, realistic max: 12%
  final double defaultGrowthRate;

  /// Default design life (years)
  /// IRC standard: 15-20 years for flexible pavements
  final int defaultDesignLife;

  /// Default Vehicle Damage Factor
  /// IRC 37 for mixed traffic on NH/SH: 3.5
  final double defaultVDF;

  /// Default Lane Distribution Factor
  /// Single lane: 1.0, Two lane: 0.75, Four lane: 0.45
  final double defaultLDF;

  /// Default number of lanes
  final int defaultLanes;

  /// Standard code identifier (e.g., "IRC:37-2018")
  final String standardCode;

  const RoadDefaults({
    this.defaultInitialTraffic = 1500.0,
    this.defaultGrowthRate = 5.0,
    this.defaultDesignLife = 15,
    this.defaultVDF = 3.5,
    this.defaultLDF = 0.75,
    this.defaultLanes = 2,
    this.standardCode = 'IRC:37-2018',
  });

  /// India-specific defaults (IRC 37-2018)
  static const RoadDefaults indiaIRC37 = RoadDefaults(
    defaultInitialTraffic: 1500.0,
    defaultGrowthRate: 5.0,
    defaultDesignLife: 15,
    defaultVDF: 3.5,
    defaultLDF: 0.75,
    defaultLanes: 2,
    standardCode: 'IRC:37-2018',
  );

  /// USA defaults (AASHTO) - placeholder for future
  static const RoadDefaults usaAASHTO = RoadDefaults(
    defaultInitialTraffic: 2000.0,
    defaultGrowthRate: 4.0,
    defaultDesignLife: 20,
    defaultVDF: 2.5,
    defaultLDF: 0.80,
    defaultLanes: 2,
    standardCode: 'AASHTO',
  );

  /// European defaults (Eurocode) - placeholder for future
  static const RoadDefaults europeEurocode = RoadDefaults(
    defaultInitialTraffic: 1800.0,
    defaultGrowthRate: 3.5,
    defaultDesignLife: 20,
    defaultVDF: 3.0,
    defaultLDF: 0.85,
    defaultLanes: 2,
    standardCode: 'EN',
  );

  RoadDefaults copyWith({
    double? defaultInitialTraffic,
    double? defaultGrowthRate,
    int? defaultDesignLife,
    double? defaultVDF,
    double? defaultLDF,
    int? defaultLanes,
    String? standardCode,
  }) {
    return RoadDefaults(
      defaultInitialTraffic: defaultInitialTraffic ?? this.defaultInitialTraffic,
      defaultGrowthRate: defaultGrowthRate ?? this.defaultGrowthRate,
      defaultDesignLife: defaultDesignLife ?? this.defaultDesignLife,
      defaultVDF: defaultVDF ?? this.defaultVDF,
      defaultLDF: defaultLDF ?? this.defaultLDF,
      defaultLanes: defaultLanes ?? this.defaultLanes,
      standardCode: standardCode ?? this.standardCode,
    );
  }
}
