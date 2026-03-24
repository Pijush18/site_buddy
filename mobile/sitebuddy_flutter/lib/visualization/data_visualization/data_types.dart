import 'dart:ui';
import 'package:site_buddy/visualization/primitives/primitives.dart';

/// Data series for visualization
class DataSeries<T> {
  final String name;
  final List<T> values;
  final Color color;

  const DataSeries({
    required this.name,
    required this.values,
    required this.color,
  });
}

/// Data point
class DataPoint {
  final double x;
  final double y;
  final String? label;
  final dynamic metadata;

  const DataPoint({
    required this.x,
    required this.y,
    this.label,
    this.metadata,
  });
}

/// Data visualization type
enum DataVizType {
  bar,
  line,
  scatter,
  area,
  pie,
  histogram,
  heatmap,
}

/// Data to diagram primitives converter
abstract class DataVizConverter {
  /// Convert data series to primitives
  List<DiagramPrimitive> convert(List<DataSeries<dynamic>> data, DataVizType type);

  /// Apply styling based on data values
  void applyDataDrivenStyling(DiagramPrimitive primitive, dynamic value);

  /// Calculate axis bounds
  (Offset min, Offset max) calculateBounds(List<DataSeries<dynamic>> data);
}
