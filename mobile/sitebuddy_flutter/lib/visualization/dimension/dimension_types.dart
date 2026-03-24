import 'dart:ui';
import 'package:site_buddy/visualization/primitives/primitives.dart';

/// Dimension type
enum DimensionType {
  linear,
  angular,
  radial,
  arc,
  elevation,
}

/// Dimension line style
enum DimensionStyle {
  standard,
  architectural,
  engineering,
  mechanical,
}

/// Dimension entity
class Dimension {
  final String id;
  final DimensionType type;
  final DimensionStyle style;
  final Offset start;
  final Offset end;
  final Offset? midPoint; // For curved dimensions
  final double value; // Calculated or user-specified
  final String? unit;
  final int decimalPlaces;
  final double offset; // Distance from measured element
  final bool visible;

  const Dimension({
    required this.id,
    required this.type,
    this.style = DimensionStyle.standard,
    required this.start,
    required this.end,
    this.midPoint,
    required this.value,
    this.unit,
    this.decimalPlaces = 2,
    this.offset = 10.0,
    this.visible = true,
  });
}

/// Dimension renderer interface
abstract class DimensionRenderer {
  /// Render dimension to canvas
  void renderDimension(Canvas canvas, Paint paint, Dimension dim, CoordinateMapper mapper);

  /// Calculate dimension value from points
  double calculateValue(DimensionType type, Offset start, Offset end, Offset? midPoint);

  /// Format dimension text
  String formatValue(double value, String? unit, int decimalPlaces);
}
