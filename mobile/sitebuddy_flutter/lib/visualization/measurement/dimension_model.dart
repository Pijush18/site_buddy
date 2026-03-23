import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Represents the type of dimension measurement
enum DimensionType {
  /// Linear distance between two points
  linear,

  /// Aligned dimension along an entity
  aligned,

  /// Horizontal dimension
  horizontal,

  /// Vertical dimension
  vertical,

  /// Angular dimension between two lines or at a vertex
  angular,

  /// Radial dimension (radius)
  radial,

  /// Diameter dimension
  diameter,

  /// Ordinate dimension (X or Y from datum)
  ordinate,

  /// Chain dimension (series of aligned dimensions)
  chain,

  /// Baseline dimension (referenced from common baseline)
  baseline,
}

/// Extension for human-readable dimension type names
extension DimensionTypeExtension on DimensionType {
  String get displayName {
    switch (this) {
      case DimensionType.linear:
        return 'Linear';
      case DimensionType.aligned:
        return 'Aligned';
      case DimensionType.horizontal:
        return 'Horizontal';
      case DimensionType.vertical:
        return 'Vertical';
      case DimensionType.angular:
        return 'Angular';
      case DimensionType.radial:
        return 'Radius';
      case DimensionType.diameter:
        return 'Diameter';
      case DimensionType.ordinate:
        return 'Ordinate';
      case DimensionType.chain:
        return 'Chain';
      case DimensionType.baseline:
        return 'Baseline';
    }
  }

  String get symbol {
    switch (this) {
      case DimensionType.linear:
        return '';
      case DimensionType.aligned:
        return '';
      case DimensionType.horizontal:
        return 'H';
      case DimensionType.vertical:
        return 'V';
      case DimensionType.angular:
        return '\u00B0';
      case DimensionType.radial:
        return 'R';
      case DimensionType.diameter:
        return '\u00D8';
      case DimensionType.ordinate:
        return '';
      case DimensionType.chain:
        return '';
      case DimensionType.baseline:
        return '';
    }
  }
}

/// Precision level for dimension display
enum DimensionPrecision {
  /// No decimal places (integers only)
  integer(0),

  /// One decimal place
  oneDecimal(1),

  /// Two decimal places (standard engineering)
  twoDecimal(2),

  /// Three decimal places (high precision)
  threeDecimal(3),

  /// Four decimal places (ultra precision)
  fourDecimal(4);

  const DimensionPrecision(this.decimalPlaces);

  final int decimalPlaces;
}

/// Unit system for dimension values
enum DimensionUnit {
  /// Millimeters
  mm,

  /// Centimeters
  cm,

  /// Meters
  m,

  /// Kilometers
  km,

  /// Inches (imperial)
  inches,

  /// Feet (imperial)
  feet,

  /// Yards (imperial)
  yards;

  /// Conversion factor to base unit (meters for metric, feet for imperial)
  double get toMeters {
    switch (this) {
      case DimensionUnit.mm:
        return 0.001;
      case DimensionUnit.cm:
        return 0.01;
      case DimensionUnit.m:
        return 1.0;
      case DimensionUnit.km:
        return 1000.0;
      case DimensionUnit.inches:
        return 0.0254;
      case DimensionUnit.feet:
        return 0.3048;
      case DimensionUnit.yards:
        return 0.9144;
    }
  }

  String get symbol {
    switch (this) {
      case DimensionUnit.mm:
        return 'mm';
      case DimensionUnit.cm:
        return 'cm';
      case DimensionUnit.m:
        return 'm';
      case DimensionUnit.km:
        return 'km';
      case DimensionUnit.inches:
        return '"';
      case DimensionUnit.feet:
        return "'";
      case DimensionUnit.yards:
        return 'yd';
    }
  }

  String get displayName {
    switch (this) {
      case DimensionUnit.mm:
        return 'Millimeters';
      case DimensionUnit.cm:
        return 'Centimeters';
      case DimensionUnit.m:
        return 'Meters';
      case DimensionUnit.km:
        return 'Kilometers';
      case DimensionUnit.inches:
        return 'Inches';
      case DimensionUnit.feet:
        return 'Feet';
      case DimensionUnit.yards:
        return 'Yards';
    }
  }
}

/// Style for dimension text display
class DimensionStyle {
  const DimensionStyle({
    this.precision = DimensionPrecision.twoDecimal,
    this.unit = DimensionUnit.mm,
    this.showUnit = true,
    this.showTolerance = false,
    this.textHeight = 2.5,
    this.arrowSize = 1.5,
    this.extensionLineOffset = 0.5,
    this.extensionLineExtension = 1.5,
    this.textGap = 0.5,
    this.decimalSeparator = '.',
    this.thousandsSeparator = ',',
    this.angularUnit = AngularUnit.degrees,
  });

  final DimensionPrecision precision;
  final DimensionUnit unit;
  final bool showUnit;
  final bool showTolerance;
  final double textHeight;
  final double arrowSize;
  final double extensionLineOffset;
  final double extensionLineExtension;
  final double textGap;
  final String decimalSeparator;
  final String thousandsSeparator;
  final AngularUnit angularUnit;

  /// Create a copy with modified values
  DimensionStyle copyWith({
    DimensionPrecision? precision,
    DimensionUnit? unit,
    bool? showUnit,
    bool? showTolerance,
    double? textHeight,
    double? arrowSize,
    double? extensionLineOffset,
    double? extensionLineExtension,
    double? textGap,
    String? decimalSeparator,
    String? thousandsSeparator,
    AngularUnit? angularUnit,
  }) {
    return DimensionStyle(
      precision: precision ?? this.precision,
      unit: unit ?? this.unit,
      showUnit: showUnit ?? this.showUnit,
      showTolerance: showTolerance ?? this.showTolerance,
      textHeight: textHeight ?? this.textHeight,
      arrowSize: arrowSize ?? this.arrowSize,
      extensionLineOffset: extensionLineOffset ?? this.extensionLineOffset,
      extensionLineExtension:
          extensionLineExtension ?? this.extensionLineExtension,
      textGap: textGap ?? this.textGap,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      thousandsSeparator: thousandsSeparator ?? this.thousandsSeparator,
      angularUnit: angularUnit ?? this.angularUnit,
    );
  }

  /// Format a numeric value according to this style
  String formatValue(double value) {
    final precisionValue = value.toStringAsFixed(precision.decimalPlaces);
    final parts = precisionValue.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : '';

    // Apply thousands separator to integer part
    final formattedInt = intPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}$thousandsSeparator',
    );

    final formattedDecimal =
        decPart.isNotEmpty ? '$decimalSeparator$decPart' : '';

    String result = '$formattedInt$formattedDecimal';

    if (showUnit) {
      result = '$result ${unit.symbol}';
    }

    return result;
  }
}

/// Angular unit for angular dimensions
enum AngularUnit {
  degrees,
  degreesMinutesSeconds,
  radians,
  gradians;

  String get symbol {
    switch (this) {
      case AngularUnit.degrees:
        return '\u00B0';
      case AngularUnit.degreesMinutesSeconds:
        return '\u00B0\'"';
      case AngularUnit.radians:
        return 'rad';
      case AngularUnit.gradians:
        return 'g';
    }
  }
}

/// Tolerance specification for dimensions
class DimensionTolerance {
  const DimensionTolerance({
    required this.upper,
    required this.lower,
  });

  final double upper;
  final double lower;

  /// Create equal bilateral tolerance
  factory DimensionTolerance.bilateral(double value) {
    return DimensionTolerance(upper: value, lower: -value);
  }

  /// Create unilateral tolerance (upper only)
  factory DimensionTolerance.unilateralUpper(double value) {
    return DimensionTolerance(upper: value, lower: 0);
  }

  /// Create unilateral tolerance (lower only)
  factory DimensionTolerance.unilateralLower(double value) {
    return DimensionTolerance(upper: 0, lower: -value.abs());
  }

  bool get isBilateral => upper == -lower;
  bool get isUnilateral => upper == 0 || lower == 0;

  /// Format tolerance value
  String format(double baseValue, DimensionStyle style) {
    final upperStr = style.formatValue(baseValue + upper);
    final lowerStr = style.formatValue(baseValue + lower);

    if (isBilateral && upper == 0) {
      return '±${style.formatValue(upper.abs())}';
    }

    return '$upperStr / $lowerStr';
  }
}

/// Base abstract class for all dimension types
///
/// This class defines the common interface for all dimension measurements
/// in the engineering visualization system. Subclasses implement specific
/// dimension types like linear, angular, radial, etc.
@immutable
abstract class Dimension {
  /// Creates a new dimension with the given parameters
  const Dimension({
    required this.id,
    required this.type,
    this.label,
    this.style,
    this.isVisible = true,
    this.isLocked = false,
    this.zIndex = 0,
    this.properties = const {},
  });

  /// Unique identifier for this dimension
  final String id;

  /// The type of dimension
  final DimensionType type;

  /// Optional label for the dimension (e.g., "Width", "Height")
  final String? label;

  /// Style configuration for dimension display
  final DimensionStyle? style;

  /// Whether the dimension is visible
  final bool isVisible;

  /// Whether the dimension is locked (cannot be edited)
  final bool isLocked;

  /// Z-index for layering (higher values render on top)
  final int zIndex;

  /// Additional custom properties
  final Map<String, dynamic> properties;

  /// Creates a copy of this dimension with the given fields replaced
  Dimension copyWith({
    String? id,
    DimensionType? type,
    String? label,
    DimensionStyle? style,
    bool? isVisible,
    bool? isLocked,
    int? zIndex,
    Map<String, dynamic>? properties,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dimension &&
        other.id == id &&
        other.type == type &&
        other.label == label &&
        other.isVisible == isVisible &&
        other.isLocked == isLocked &&
        other.zIndex == zIndex;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      type,
      label,
      isVisible,
      isLocked,
      zIndex,
    );
  }

  @override
  String toString() {
    return 'Dimension(id: $id, type: $type, label: $label, visible: $isVisible)';
  }
}

/// Represents a 2D point with optional snap information
@immutable
class DimensionPoint {
  const DimensionPoint({
    required this.x,
    required this.y,
    this.snapTargetId,
    this.snapType,
  });

  final double x;
  final double y;
  final String? snapTargetId;
  final String? snapType;

  Offset toOffset() => Offset(x, y);

  factory DimensionPoint.fromOffset(Offset offset) {
    return DimensionPoint(x: offset.dx, y: offset.dy);
  }

  /// Calculate distance to another point
  double distanceTo(DimensionPoint other) {
    final dx = other.x - x;
    final dy = other.y - y;
    return (dx * dx + dy * dy).sqrt();
  }

  /// Calculate angle to another point in radians
  double angleTo(DimensionPoint other) {
    return (Offset(other.x, other.y) - toOffset()).direction;
  }

  /// Calculate angle to another point in degrees
  double angleToDegrees(DimensionPoint other) {
    return angleTo(other) * 180 / 3.141592653589793;
  }

  DimensionPoint operator +(DimensionPoint other) {
    return DimensionPoint(x: x + other.x, y: y + other.y);
  }

  DimensionPoint operator -(DimensionPoint other) {
    return DimensionPoint(x: x - other.x, y: y - other.y);
  }

  DimensionPoint operator *(double scalar) {
    return DimensionPoint(x: x * scalar, y: y * scalar);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DimensionPoint &&
        other.x == x &&
        other.y == y &&
        other.snapTargetId == snapTargetId;
  }

  @override
  int get hashCode => Object.hash(x, y, snapTargetId);

  @override
  String toString() => 'DimensionPoint($x, $y)';
}

/// Extension to add sqrt function to num
extension NumExtension on num {
  double sqrt() => this < 0 ? 0 : toDouble().sqrt();

  double get sqrtValue {
    if (this < 0) return 0;
    return _sqrt(toDouble());
  }

  static double _sqrt(double value) {
    if (value == 0) return 0;
    double guess = value / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + value / guess) / 2;
    }
    return guess;
  }
}
