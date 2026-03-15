/// Pure Dart utility to extract numeric dimensions and units from natural language queries.
/// Supports patterns like "10m x 8m", "10 by 8", "150mm", "thickness 0.15".
/// ----------------------------------------------
library;

class QueryParameters {
  final List<double> values;
  final Map<String, double> namedParameters;

  const QueryParameters({
    this.values = const [],
    this.namedParameters = const {},
  });

  @override
  String toString() => 'QueryParameters(values: $values, named: $namedParameters)';
}

class QueryParameterParser {
  /// Regular expression to find numbers followed by optional units.
  /// Matches: 10, 10.5, 10m, 10 mm, 10.5mm etc.
  static final RegExp _valueRegex = RegExp(
    r'(\d+\.?\d*)\s*(m|mm|cm|ft|inch|")',
    caseSensitive: false,
  );

  static final RegExp _plainNumberRegex = RegExp(
    r'(\d+\.?\d*)',
  );

  /// Main extraction logic
  QueryParameters parse(String query) {
    final lower = query.toLowerCase();
    final values = <double>[];
    
    // 1. Try to find values with units first
    final unitMatches = _valueRegex.allMatches(lower);
    final processedIndices = <int>{};

    for (final match in unitMatches) {
      final numStr = match.group(1);
      final unit = match.group(2);
      if (numStr != null) {
        final val = double.tryParse(numStr);
        if (val != null) {
          values.add(_normalizeToMeters(val, unit));
          processedIndices.add(match.start);
        }
      }
    }

    // 2. If no unit matches, try plain numbers
    if (values.isEmpty) {
      final plainMatches = _plainNumberRegex.allMatches(lower);
      for (final match in plainMatches) {
        final numStr = match.group(1);
        if (numStr != null) {
          final val = double.tryParse(numStr);
          if (val != null) {
            values.add(val);
          }
        }
      }
    }

    return QueryParameters(values: values);
  }

  double _normalizeToMeters(double value, String? unit) {
    if (unit == null) return value;
    switch (unit.toLowerCase()) {
      case 'mm':
        return value / 1000.0;
      case 'cm':
        return value / 100.0;
      case 'inch':
      case '"':
        return value * 0.0254;
      case 'ft':
        return value * 0.3048;
      case 'm':
      default:
        return value;
    }
  }
}
