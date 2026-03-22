import 'package:site_buddy/features/unit_converter/domain/models/unit_converter_input.dart';
import 'package:site_buddy/features/unit_converter/domain/models/unit_converter_result.dart';

/// SERVICE: UnitConverterService
/// PURPOSE: Pure logic for engineering unit conversions.
class UnitConverterService {
  const UnitConverterService();

  /// Conversion factors to Base Units (Length: meter, Area: sqm, Volume: cum)
  static final Map<String, double> _factors = {
    // Length (to meters)
    'm': 1.0,
    'cm': 0.01,
    'mm': 0.001,
    'km': 1000.0,
    'in': 0.0254,
    'ft': 0.3048,
    'yd': 0.9144,
    'mi': 1609.34,
    
    // Area (to sqm)
    'sqm': 1.0,
    'sqft': 0.092903,
    'sqin': 0.00064516,
    'acre': 4046.86,
    'hectare': 10000.0,
    
    // Volume (to cum)
    'cum': 1.0,
    'cuft': 0.0283168,
    'liter': 0.001,
    'gallon': 0.00378541,
  };

  /// CONVERT: Standard SI/Imperial conversion for construction units.
  /// 
  /// CONSTANTS:
  /// - Length: 1 ft = 0.3048 m
  /// - Area: 1 sqft = 0.092903 sqm
  /// - Volume: 1 cuft = 0.0283168 cum
  /// 
  /// UNITS: m/ft, sqm/sqft, cum/cuft etc.
  UnitConverterResult convert(UnitConverterInput input) {
    _validate(input);

    final fromFactor = _factors[input.fromUnit];
    final toFactor = _factors[input.toUnit];

    if (fromFactor == null || toFactor == null) {
      throw ArgumentError('Unsupported unit: ${fromFactor == null ? input.fromUnit : input.toUnit}');
    }

    // Convert to base, then to target
    final baseValue = input.value * fromFactor;
    final convertedValue = baseValue / toFactor;

    return UnitConverterResult(
      value: double.parse(convertedValue.toStringAsFixed(4)),
      unit: input.toUnit,
    );
  }

  void _validate(UnitConverterInput input) {
    if (input.value < 0) {
      throw ArgumentError('Value to convert cannot be negative');
    }
  }
}
