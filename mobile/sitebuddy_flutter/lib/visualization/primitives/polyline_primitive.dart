import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'primitives.dart' show DiagramPrimitive, CoordinateMapper;

/// Polyline primitive - for open shapes without forced closure
/// 
/// Unlike [DiagramPolygon] which automatically closes the path,
/// [DiagramPolyline] draws connected line segments without closing.
/// 
/// Use cases:
/// - Ground profiles and terrain lines
/// - Water surfaces
/// - Slope edges
/// - Road alignment
/// - Structural section lines
/// - Cross-hatching guides
/// 
/// Example:
/// ```dart
/// // Create a terrain profile
/// final polyline = DiagramPolyline(
///   id: 'terrain_profile',
///   points: [
///     Offset(0, 0),
///     Offset(10, 2),
///     Offset(20, 1.5),
///     Offset(30, 3),
///     Offset(40, 2),
///   ],
///   strokeColor: const Color(0xFF4CAF50),
///   strokeWidth: 2.0,
///   zIndex: DiagramLayers.structure,
/// );
/// ```
@immutable
class DiagramPolyline extends DiagramPrimitive {
  /// List of points forming the polyline
  /// Points are connected in order without forced closure
  final List<Offset> points;

  /// Stroke color (not fill - polylines are open shapes)
  final Color strokeColor;

  /// Stroke width in world units (scaled to canvas)
  final double strokeWidth;

  /// Whether to draw as dashed line
  final bool dashed;

  /// Line cap style
  final StrokeCap strokeCap;

  /// Line join style
  final StrokeJoin strokeJoin;

  const DiagramPolyline({
    required String id,
    required this.points,
    this.strokeColor = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.dashed = false,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    int zIndex = 0,
    bool visible = true,
    String? label,
    int version = 0,
  }) : super(id: id, zIndex: zIndex, visible: visible, label: label, version: version);

  @override
  DiagramPolyline copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    List<Offset>? points,
    Color? strokeColor,
    double? strokeWidth,
    bool? dashed,
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
  }) {
    return DiagramPolyline(
      id: id ?? this.id,
      points: points ?? this.points,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashed: dashed ?? this.dashed,
      strokeCap: strokeCap ?? this.strokeCap,
      strokeJoin: strokeJoin ?? this.strokeJoin,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }

  @override
  Rect get bounds {
    if (points.isEmpty) {
      return Rect.zero;
    }

    double minX = points.first.dx;
    double minY = points.first.dy;
    double maxX = minX;
    double maxY = minY;

    for (final point in points) {
      if (point.dx < minX) minX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy > maxY) maxY = point.dy;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY).inflate(strokeWidth);
  }

  @override
  bool hitTest(Offset point) => bounds.contains(point);

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible || points.length < 2) return;

    // Transform points to canvas coordinates
    final canvasPoints = points.map((p) => mapper.worldToCanvas(p)).toList();

    // Build path from points
    final path = Path();
    path.moveTo(canvasPoints.first.dx, canvasPoints.first.dy);
    
    for (var i = 1; i < canvasPoints.length; i++) {
      path.lineTo(canvasPoints[i].dx, canvasPoints[i].dy);
    }

    paint
      ..color = strokeColor
      ..strokeWidth = strokeWidth * mapper.scale
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..strokeJoin = strokeJoin;

    if (dashed) {
      _drawDashedPath(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashLength = 8.0;
    const gapLength = 4.0;

    final metrics = path.computeMetrics();
    
    for (final metric in metrics) {
      var distance = 0.0;
      var isDash = true;
      
      while (distance < metric.length) {
        final segmentLength = isDash ? dashLength : gapLength;
        final endDistance = (distance + segmentLength).clamp(0.0, metric.length);
        
        if (isDash) {
          final extractedPath = metric.extractPath(distance, endDistance);
          canvas.drawPath(extractedPath, paint);
        }
        
        distance = endDistance;
        isDash = !isDash;
      }
    }
  }

  /// Get the bounding box of this polyline in world coordinates
  Rect get boundingBox {
    if (points.isEmpty) return Rect.zero;
    
    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;

    for (final point in points) {
      if (point.dx < minX) minX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy > maxY) maxY = point.dy;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Get the total length of the polyline
  double get totalLength {
    if (points.length < 2) return 0.0;
    
    var length = 0.0;
    for (var i = 1; i < points.length; i++) {
      final dx = points[i].dx - points[i - 1].dx;
      final dy = points[i].dy - points[i - 1].dy;
      length += _sqrt(dx * dx + dy * dy);
    }
    return length;
  }

  /// Get the direction vector at a given point index
  /// Returns null if index is invalid or at the last point
  Offset? getDirectionAt(int index) {
    if (index < 0 || index >= points.length - 1) return null;
    return points[index + 1] - points[index];
  }

  /// Get the normalized direction vector at a given point index
  Offset? getNormalizedDirectionAt(int index) {
    final direction = getDirectionAt(index);
    if (direction == null) return null;
    
    final length = _sqrt(direction.dx * direction.dx + direction.dy * direction.dy);
    if (length == 0) return null;
    
    return Offset(direction.dx / length, direction.dy / length);
  }

  /// Check if this polyline is closed (first and last points are the same)
  bool get isClosed {
    if (points.length < 3) return false;
    return points.first == points.last;
  }

  /// Create a polyline from a function (for smooth curves)
  /// 
  /// [startX] - starting X coordinate
  /// [endX] - ending X coordinate  
  /// [numPoints] - number of points to generate
  /// [yFunction] - function that calculates Y for a given X
  factory DiagramPolyline.fromFunction({
    required String id,
    required double startX,
    required double endX,
    required int numPoints,
    required double Function(double x) yFunction,
    Color strokeColor = const Color(0xFF000000),
    double strokeWidth = 1.0,
    bool dashed = false,
    int zIndex = 0,
    String? label,
  }) {
    if (numPoints < 2) {
      return DiagramPolyline(
        id: id,
        points: [Offset(startX, yFunction(startX))],
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        dashed: dashed,
        zIndex: zIndex,
        label: label,
      );
    }

    final points = <Offset>[];
    final step = (endX - startX) / (numPoints - 1);
    
    for (var i = 0; i < numPoints; i++) {
      final x = startX + i * step;
      final y = yFunction(x);
      points.add(Offset(x, y));
    }

    return DiagramPolyline(
      id: id,
      points: points,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      dashed: dashed,
      zIndex: zIndex,
      label: label,
    );
  }

  /// Create a horizontal polyline
  factory DiagramPolyline.horizontal({
    required String id,
    required double startX,
    required double endX,
    required double y,
    Color strokeColor = const Color(0xFF000000),
    double strokeWidth = 1.0,
    bool dashed = false,
    int zIndex = 0,
    String? label,
  }) {
    return DiagramPolyline(
      id: id,
      points: [Offset(startX, y), Offset(endX, y)],
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      dashed: dashed,
      zIndex: zIndex,
      label: label,
    );
  }

  /// Create a vertical polyline
  factory DiagramPolyline.vertical({
    required String id,
    required double startY,
    required double endY,
    required double x,
    Color strokeColor = const Color(0xFF000000),
    double strokeWidth = 1.0,
    bool dashed = false,
    int zIndex = 0,
    String? label,
  }) {
    return DiagramPolyline(
      id: id,
      points: [Offset(x, startY), Offset(x, endY)],
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      dashed: dashed,
      zIndex: zIndex,
      label: label,
    );
  }
  
  /// Internal sqrt implementation to avoid duplicate extension conflicts
  static double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (var i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}
