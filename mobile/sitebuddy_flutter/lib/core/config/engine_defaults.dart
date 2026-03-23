/// lib/core/config/engine_defaults.dart
///
/// Central export file for all engineering default configurations.
/// 
/// This module provides configurable defaults for Road, Canal, and Flow
/// simulation modules, replacing hardcoded values with provider-based
/// configuration.
///
/// USAGE:
/// ```dart
/// import 'package:site_buddy/core/config/engine_defaults.dart';
///
/// final defaults = ref.watch(engineDefaultsProvider);
/// ```
library;

export 'road_defaults.dart';
export 'canal_defaults.dart';
export 'flow_defaults.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/config/road_defaults.dart';
import 'package:site_buddy/core/config/canal_defaults.dart';
import 'package:site_buddy/core/config/flow_defaults.dart';

/// Provider for Road module defaults.
/// 
/// Override this in ProviderScope.overrides for testing or
/// to switch between country-specific defaults.
final roadDefaultsProvider = Provider<RoadDefaults>((ref) {
  // TODO: In future, read from RegionConfigProvider
  // final region = ref.watch(regionConfigProvider);
  // return region.roadDefaults;
  
  // Default to IRC India for now
  return RoadDefaults.indiaIRC37;
});

/// Provider for Canal module defaults.
/// 
/// Override this in ProviderScope.overrides for testing or
/// to switch between material-specific defaults.
final canalDefaultsProvider = Provider<CanalDefaults>((ref) {
  // TODO: In future, could be material-specific
  // final material = ref.watch(selectedMaterialProvider);
  // return CanalDefaults.byMaterial(material);
  
  // Default to concrete
  return CanalDefaults.concrete;
});

/// Provider for Flow Simulation module defaults.
/// 
/// Override this in ProviderScope.overrides for testing or
/// to switch between precision presets.
final flowSimulationDefaultsProvider = Provider<FlowSimulationDefaults>((ref) {
  // TODO: In future, could be user preference-based
  // final precision = ref.watch(simulationPrecisionProvider);
  // return FlowSimulationDefaults.byPrecision(precision);
  
  // Default configuration
  return const FlowSimulationDefaults();
});

/// Preset enum for simulation precision
enum SimulationPrecision {
  quick,    // 5 segments - fast
  standard, // 10 segments - balanced
  high,     // 50 segments - accurate
}

/// Provider for simulation precision settings
final simulationPrecisionProvider = Provider<SimulationPrecision>((ref) {
  return SimulationPrecision.standard;
});

/// Extension to get FlowSimulationDefaults by precision
extension FlowSimulationDefaultsByPrecision on FlowSimulationDefaults {
  static FlowSimulationDefaults forPrecision(SimulationPrecision precision) {
    switch (precision) {
      case SimulationPrecision.quick:
        return FlowSimulationDefaults.quickEstimate;
      case SimulationPrecision.standard:
        return const FlowSimulationDefaults();
      case SimulationPrecision.high:
        return FlowSimulationDefaults.highPrecision;
    }
  }
}

/// Material enum for canal defaults
enum CanalMaterial {
  concrete,
  earth,
  brick,
  gravel,
}

/// Extension to get CanalDefaults by material
extension CanalDefaultsByMaterial on CanalDefaults {
  static CanalDefaults forMaterial(CanalMaterial material) {
    switch (material) {
      case CanalMaterial.concrete:
        return CanalDefaults.concrete;
      case CanalMaterial.earth:
        return CanalDefaults.earth;
      case CanalMaterial.brick:
        return CanalDefaults.brick;
      case CanalMaterial.gravel:
        return CanalDefaults.gravel;
    }
  }
}

/// Country code enum for road defaults
enum CountryCode {
  india,
  usa,
  europe,
}

/// Extension to get RoadDefaults by country
extension RoadDefaultsByCountry on RoadDefaults {
  static RoadDefaults forCountry(CountryCode country) {
    switch (country) {
      case CountryCode.india:
        return RoadDefaults.indiaIRC37;
      case CountryCode.usa:
        return RoadDefaults.usaAASHTO;
      case CountryCode.europe:
        return RoadDefaults.europeEurocode;
    }
  }
}
