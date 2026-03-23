/// lib/features/water/irrigation/domain/models/scenario_models.dart
///
/// Irrigation design scenario types.
///
/// PURPOSE:
/// - Define design scenario categories
/// - Pure type definition (values/extensions moved to FAO56Standard)
library;

/// Irrigation design scenarios
/// 
/// This enum defines scenario categories only. All scenario factor values
/// (display names, descriptions, water application factors) are defined
/// in the [FAO56Standard] class for centralized engineering rule management.
enum IrrigationScenario {
  /// Conservative: Higher water application, safer margins
  conservative,
  
  /// Standard: Balanced per FAO guidelines
  standard,
  
  /// Optimized: Water-saving design with efficiency focus
  optimized,
}

// =========================================================================
// EXTENSIONS - Backward compatibility layer (delegates to FAO56Standard)
// =========================================================================

/// Extension for scenario display names and factors
/// 
/// NOTE: The authoritative values are defined in FAO56Standard.
/// This extension provides backward compatibility for existing code.
extension IrrigationScenarioExtension on IrrigationScenario {
  String get displayName {
    switch (this) {
      case IrrigationScenario.conservative:
        return 'Conservative (Safe)';
      case IrrigationScenario.standard:
        return 'Standard (Balanced)';
      case IrrigationScenario.optimized:
        return 'Optimized (Water-Saving)';
    }
  }

  String get description {
    switch (this) {
      case IrrigationScenario.conservative:
        return 'Higher water application with safety margins. Recommended for water-abundant areas.';
      case IrrigationScenario.standard:
        return 'Per FAO-56 guidelines. Balanced approach between water use and crop needs.';
      case IrrigationScenario.optimized:
        return 'Water-efficient design for water-scarce areas. Best with drip/sprinkler systems.';
    }
  }

  /// Water application factor for this scenario
  double get waterApplicationFactor {
    switch (this) {
      case IrrigationScenario.conservative:
        return 1.15; // +15% water
      case IrrigationScenario.standard:
        return 1.0; // Standard
      case IrrigationScenario.optimized:
        return 0.85; // -15% water (efficiency gain)
    }
  }
}
