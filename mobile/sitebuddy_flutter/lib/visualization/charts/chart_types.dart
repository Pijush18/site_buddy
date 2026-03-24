import 'dart:ui';
import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/visualization/data_visualization/data_types.dart';

/// Chart types
enum ChartType {
  line,
  bar,
  scatter,
  pie,
  area,
  candlestick,
  gauge,
}

/// Chart axis configuration
class ChartAxis {
  final String label;
  final bool showGrid;
  final bool showLabel;
  final double? min;
  final double? max;
  final int tickCount;

  const ChartAxis({
    required this.label,
    this.showGrid = true,
    this.showLabel = true,
    this.min,
    this.max,
    this.tickCount = 5,
  });
}

/// Chart legend configuration
class ChartLegend {
  final bool show;
  final LegendPosition position;

  const ChartLegend({
    this.show = true,
    this.position = LegendPosition.right,
  });
}

enum LegendPosition {
  top,
  bottom,
  left,
  right,
}

/// Chart tooltip
class ChartTooltip {
  final Offset position;
  final String text;
  final Color backgroundColor;

  const ChartTooltip({
    required this.position,
    required this.text,
    this.backgroundColor = const Color(0xFFFFFFFF),
  });
}

/// Chart renderer
abstract class ChartRenderer {
  /// Render chart to primitives
  List<DiagramPrimitive> render(
    List<DataSeries<dynamic>> data,
    ChartType type,
    Rect bounds,
  );

  /// Handle tooltip at position
  ChartTooltip? getTooltip(Offset position, List<DataSeries<dynamic>> data);

  /// Get highlighted data point
  DataPoint? getHighlightedPoint(Offset position, List<DataSeries<dynamic>> data);
}
