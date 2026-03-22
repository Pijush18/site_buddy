/// FILE:/// Engineering constants for UI and Painter usage.
library;
/// PURPOSE: Centralized source of truth for non-localized engineering symbols and units.
/// LAYER: Core / Engineering

class EngineeringSymbols {
  EngineeringSymbols._();

  static const String length = 'L';
  static const String width = 'B';
  static const String depth = 'D';
  static const String diameter = 'Ø';
  static const String load = 'P';
  static const String reinforcement = 'As';
  static const String spacing = 's';
}

class EngineeringUnits {
  EngineeringUnits._();

  static const String mm = 'mm';
  static const String m = 'm';
  static const String kN = 'kN';
  static const String mpa = 'MPa';
  static const String kgm3 = 'kg/m³';
}

class EngineeringFormatter {
  EngineeringFormatter._();

  /// Formats diameter notation: Ø12
  static String dia(int value) => '${EngineeringSymbols.diameter}$value';

  /// Formats value with unit: 500 mm
  static String withUnit(Object value, String unit) => '$value $unit';
}
