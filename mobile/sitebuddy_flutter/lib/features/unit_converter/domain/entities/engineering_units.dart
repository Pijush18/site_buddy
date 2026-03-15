/// FILE HEADER
/// ----------------------------------------------
/// File: engineering_units.dart
/// Feature: unit_converter
/// Layer: domain/entities
///
/// PURPOSE:
/// Single source of truth for all strictly supported site engineering units.
///
/// RESPONSIBILITIES:
/// - Instantiates all `UnitDefinition` standards mapped by `UnitType`.
/// - Defines standard anchors (Meter, SqM, CuM, Kg, Pascal).
///
/// DEPENDENCIES:
/// - UnitType
/// - UnitDefinition
///
/// FUTURE IMPROVEMENTS:
/// - Extend to surveying-specific units if requested.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/unit_converter/domain/enums/unit_type.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/unit_definition.dart';

/// CLASS: EngineeringUnits
/// PURPOSE: Exposes predefined immutable lists of accepted calculations.
class EngineeringUnits {
  const EngineeringUnits._();

  // ==========================================
  // LENGTH (Base: meter)
  // ==========================================
  static const lengthUnits = <UnitDefinition>[
    UnitDefinition(name: 'Meter', symbol: 'm', toBaseFactor: 1.0),
    UnitDefinition(name: 'Millimeter', symbol: 'mm', toBaseFactor: 0.001),
    UnitDefinition(name: 'Centimeter', symbol: 'cm', toBaseFactor: 0.01),
    UnitDefinition(name: 'Kilometer', symbol: 'km', toBaseFactor: 1000.0),
    UnitDefinition(name: 'Feet', symbol: 'ft', toBaseFactor: 0.3048),
    UnitDefinition(name: 'Inch', symbol: 'in', toBaseFactor: 0.0254),
  ];

  // ==========================================
  // AREA (Base: square meter)
  // ==========================================
  static const areaUnits = <UnitDefinition>[
    UnitDefinition(name: 'Square Meter', symbol: 'sqm', toBaseFactor: 1.0),
    UnitDefinition(name: 'Square Feet', symbol: 'sqft', toBaseFactor: 0.092903),
    UnitDefinition(name: 'Hectare', symbol: 'ha', toBaseFactor: 10000.0),
  ];

  // ==========================================
  // VOLUME (Base: cubic meter)
  // ==========================================
  static const volumeUnits = <UnitDefinition>[
    UnitDefinition(name: 'Cubic Meter', symbol: 'cum', toBaseFactor: 1.0),
    UnitDefinition(name: 'Cubic Feet', symbol: 'cuft', toBaseFactor: 0.0283168),
    UnitDefinition(name: 'Cubic Yard', symbol: 'yd³', toBaseFactor: 0.764555),
    UnitDefinition(name: 'Liter', symbol: 'L', toBaseFactor: 0.001),
  ];

  // ==========================================
  // WEIGHT (Base: kilogram)
  // ==========================================
  static const weightUnits = <UnitDefinition>[
    UnitDefinition(name: 'Kilogram', symbol: 'kg', toBaseFactor: 1.0),
    UnitDefinition(name: 'Ton', symbol: 'ton', toBaseFactor: 1000.0),
    UnitDefinition(name: 'Pound', symbol: 'lbs', toBaseFactor: 0.453592),
  ];

  // ==========================================
  // PRESSURE (Base: pascal)
  // ==========================================
  static const pressureUnits = <UnitDefinition>[
    UnitDefinition(name: 'Pascal', symbol: 'Pa', toBaseFactor: 1.0),
    UnitDefinition(name: 'Bar', symbol: 'bar', toBaseFactor: 100000.0),
    UnitDefinition(name: 'PSI', symbol: 'psi', toBaseFactor: 6894.76),
  ];

  /// Helper to fetch all units by type for dropdowns
  static List<UnitDefinition> getUnitsForType(UnitType type) {
    switch (type) {
      case UnitType.length:
        return lengthUnits;
      case UnitType.area:
        return areaUnits;
      case UnitType.volume:
        return volumeUnits;
      case UnitType.weight:
        return weightUnits;
      case UnitType.pressure:
        return pressureUnits;
    }
  }

  /// Helper to get a unit directly by its string representation for NLP parse mapping.
  static UnitDefinition? parseUnit(String lookup) {
    final clean = lookup.toLowerCase().trim();

    // Flatten all units.
    final all = [
      ...lengthUnits,
      ...areaUnits,
      ...volumeUnits,
      ...weightUnits,
      ...pressureUnits,
    ];

    // Try finding by symbol directly first
    for (var u in all) {
      if (u.symbol.toLowerCase() == clean) return u;
    }

    // Common synonyms mapped to standard symbols
    String standardSymbol = clean;
    if (['meter', 'meters'].contains(clean)) standardSymbol = 'm';
    if (['feet', 'foot', "'"].contains(clean)) standardSymbol = 'ft';
    if (['inch', 'inches', '"'].contains(clean)) standardSymbol = 'in';
    if (['millimeter'].contains(clean)) standardSymbol = 'mm';
    if (['centimeter'].contains(clean)) standardSymbol = 'cm';
    if (['kilometer'].contains(clean)) standardSymbol = 'km';
    if (['m2', 'sq meter', 'square meter', 'm²'].contains(clean)) {
      standardSymbol = 'sqm';
    }
    if (['ft2', 'sq feet', 'square feet', 'ft²'].contains(clean)) {
      standardSymbol = 'sqft';
    }
    if (['m3', 'm³', 'cubic meter', 'cum'].contains(clean)) {
      standardSymbol = 'cum';
    }
    if (['ft3', 'ft³', 'cubic feet', 'cuft'].contains(clean)) {
      standardSymbol = 'cuft';
    }
    if (['yd3', 'yd³', 'cubic yard', 'yard'].contains(clean)) {
      standardSymbol = 'yd³';
    }
    if (['kilogram', 'kgs'].contains(clean)) standardSymbol = 'kg';
    if (['tons', 't'].contains(clean)) standardSymbol = 'ton';
    if (['pound', 'lb'].contains(clean)) standardSymbol = 'lbs';

    for (var u in all) {
      if (u.symbol.toLowerCase() == standardSymbol) return u;
    }

    return null;
  }
}
