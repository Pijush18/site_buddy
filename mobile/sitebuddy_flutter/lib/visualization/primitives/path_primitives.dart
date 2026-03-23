import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'primitives.dart' show DiagramPrimitive, CoordinateMapper;

/// Hatch pattern types for material representation
enum HatchType {
  none,
  solid,
  diagonal,
  reverseDiagonal,
  cross,
  vertical,
  horizontal,
  dots,
}

/// Hatch pattern configuration
class HatchPattern {
  final HatchType type;
  final double spacing;
  final double lineWidth;
  final Color color;

  const HatchPattern({
    this.type = HatchType.solid,
    this.spacing = 8.0,
    this.lineWidth = 1.0,
    this.color = const Color(0xFF000000),
  });

  /// Default engineering hatch patterns
  static const concrete = HatchPattern(
    type: HatchType.diagonal,
    spacing: 6.0,
    lineWidth: 1.0,
  );

  static const soil = HatchPattern(
    type: HatchType.dots,
    spacing: 8.0,
    lineWidth: 1.5,
  );

  static const sand = HatchPattern(
    type: HatchType.dots,
    spacing: 4.0,
    lineWidth: 1.0,
  );

  static const rock = HatchPattern(
    type: HatchType.cross,
    spacing: 10.0,
    lineWidth: 1.5,
  );

  static const water = HatchPattern(
    type: HatchType.horizontal,
    spacing: 4.0,
    lineWidth: 0.5,
  );

  /// Shorthand named constructors for hatch types
  static const diagonal = HatchPattern(type: HatchType.diagonal, spacing: 8.0);
  static const cross = HatchPattern(type: HatchType.cross, spacing: 10.0);
  static const dots = HatchPattern(type: HatchType.dots, spacing: 6.0);
  static const vertical = HatchPattern(type: HatchType.vertical, spacing: 8.0);
  static const horizontal = HatchPattern(type: HatchType.horizontal, spacing: 6.0);
}

/// Path-based primitive - foundation for all shape primitives
@immutable
class DiagramPath extends DiagramPrimitive {
  final Path path;
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final HatchPattern? hatch;
  final bool closed;

  const DiagramPath({
    required String id,
    required this.path,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.hatch,
    this.closed = true,
    int zIndex = 0,
    bool visible = true,
    String? label,
    int version = 0,
  }) : super(id: id, zIndex: zIndex, visible: visible, label: label, version: version);

  @override
  DiagramPath copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    Path? path,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    HatchPattern? hatch,
    bool? closed,
  }) {
    return DiagramPath(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
      path: path ?? this.path,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      hatch: hatch ?? this.hatch,
      closed: closed ?? this.closed,
    );
  }

  @override
  Rect get bounds {
    final rect = path.getBounds();
    return rect.inflate(strokeWidth);
  }

  @override
  bool hitTest(Offset point) => bounds.contains(point);

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    // Transform path to canvas coordinates
    final transformedPath = _transformPath(mapper);

    // Fill with color or hatch pattern
    if (fillColor != null && fillColor!.alpha > 0) {
      if (hatch != null && hatch!.type != HatchType.solid) {
        _renderWithHatch(canvas, paint, transformedPath, mapper);
      } else {
        paint
          ..color = fillColor!
          ..style = PaintingStyle.fill;
        canvas.drawPath(transformedPath, paint);
      }
    }

    // Stroke
    if (strokeColor != null && strokeWidth > 0) {
      paint
        ..color = strokeColor!
        ..strokeWidth = strokeWidth * mapper.scale
        ..style = PaintingStyle.stroke;
      canvas.drawPath(transformedPath, paint);
    }
  }

  Path _transformPath(CoordinateMapper mapper) {
    final newPath = Path();
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      final extractedPath = metric.extractPath(0, metric.length);
      final points = <Offset>[];

      // Sample points along the path
      const samples = 100;
      for (var i = 0; i <= samples; i++) {
        final distance = i * metric.length / samples;
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          points.add(mapper.worldToCanvas(tangent.position));
        }
      }

      if (points.isNotEmpty) {
        newPath.moveTo(points.first.dx, points.first.dy);
        for (var i = 1; i < points.length; i++) {
          newPath.lineTo(points[i].dx, points[i].dy);
        }
      }
    }

    return newPath;
  }

  void _renderWithHatch(Canvas canvas, Paint paint, Path pathToClip, CoordinateMapper mapper) {
    canvas.save();
    canvas.clipPath(pathToClip);

    final bounds = pathToClip.getBounds();
    final hatchPaint = Paint()
      ..color = hatch!.color
      ..strokeWidth = hatch!.lineWidth
      ..style = PaintingStyle.stroke;

    final scaledSpacing = hatch!.spacing * mapper.scale;

    switch (hatch!.type) {
      case HatchType.diagonal:
        _drawDiagonalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.reverseDiagonal:
        _drawReverseDiagonalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.cross:
        _drawDiagonalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        _drawReverseDiagonalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.vertical:
        _drawVerticalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.horizontal:
        _drawHorizontalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.dots:
        _drawDotsHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.solid:
      case HatchType.none:
        break;
    }

    canvas.restore();
  }

  void _drawDiagonalHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    final maxDim = bounds.width + bounds.height;

    for (var d = -maxDim; d < maxDim * 2; d += spacing) {
      canvas.drawLine(
        Offset(bounds.left + d, bounds.top),
        Offset(bounds.left + d - bounds.height, bounds.bottom),
        paint,
      );
    }
  }

  void _drawReverseDiagonalHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    final maxDim = bounds.width + bounds.height;

    for (var d = -maxDim; d < maxDim * 2; d += spacing) {
      canvas.drawLine(
        Offset(bounds.left + d, bounds.top),
        Offset(bounds.left + d + bounds.height, bounds.bottom),
        paint,
      );
    }
  }

  void _drawVerticalHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    for (var x = bounds.left; x < bounds.right; x += spacing) {
      canvas.drawLine(Offset(x, bounds.top), Offset(x, bounds.bottom), paint);
    }
  }

  void _drawHorizontalHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    for (var y = bounds.top; y < bounds.bottom; y += spacing) {
      canvas.drawLine(Offset(bounds.left, y), Offset(bounds.right, y), paint);
    }
  }

  void _drawDotsHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    paint.style = PaintingStyle.fill;
    for (var x = bounds.left; x < bounds.right; x += spacing) {
      for (var y = bounds.top; y < bounds.bottom; y += spacing) {
        canvas.drawCircle(Offset(x, y), paint.strokeWidth * 0.5, paint);
      }
    }
  }
}

/// Polygon primitive - for irregular polygon shapes
@immutable
class DiagramPolygon extends DiagramPrimitive {
  final List<Offset> points;
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final HatchPattern? hatch;

  const DiagramPolygon({
    required String id,
    required this.points,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.hatch,
    int zIndex = 0,
    bool visible = true,
    String? label,
    int version = 0,
  }) : super(id: id, zIndex: zIndex, visible: visible, label: label, version: version);

  @override
  DiagramPolygon copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    List<Offset>? points,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    HatchPattern? hatch,
  }) {
    return DiagramPolygon(
      id: id ?? this.id,
      points: points ?? this.points,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      hatch: hatch ?? this.hatch,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }

  @override
  Rect get bounds {
    if (points.isEmpty) return Rect.zero;
    
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
    if (!visible || points.length < 3) return;

    final canvasPoints = points.map((p) => mapper.worldToCanvas(p)).toList();
    final path = Path()..addPolygon(canvasPoints, true);

    // Fill
    if (fillColor != null && fillColor!.alpha > 0) {
      if (hatch != null && hatch!.type != HatchType.solid) {
        _renderWithHatch(canvas, paint, path, mapper);
      } else {
        paint
          ..color = fillColor!
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, paint);
      }
    }

    // Stroke
    if (strokeColor != null && strokeWidth > 0) {
      paint
        ..color = strokeColor!
        ..strokeWidth = strokeWidth * mapper.scale
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    }
  }

  void _renderWithHatch(Canvas canvas, Paint paint, Path pathToClip, CoordinateMapper mapper) {
    canvas.save();
    canvas.clipPath(pathToClip);

    final bounds = pathToClip.getBounds();
    final hatchPaint = Paint()
      ..color = hatch!.color
      ..strokeWidth = hatch!.lineWidth
      ..style = PaintingStyle.stroke;

    final scaledSpacing = hatch!.spacing * mapper.scale;

    switch (hatch!.type) {
      case HatchType.diagonal:
        _drawDiagonalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.cross:
        _drawDiagonalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        _drawReverseDiagonalHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      case HatchType.dots:
        _drawDotsHatch(canvas, bounds, hatchPaint, scaledSpacing);
        break;
      default:
        break;
    }

    canvas.restore();
  }

  void _drawDiagonalHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    final maxDim = bounds.width + bounds.height;
    for (var d = -maxDim; d < maxDim * 2; d += spacing) {
      canvas.drawLine(
        Offset(bounds.left + d, bounds.top),
        Offset(bounds.left + d - bounds.height, bounds.bottom),
        paint,
      );
    }
  }

  void _drawReverseDiagonalHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    final maxDim = bounds.width + bounds.height;
    for (var d = -maxDim; d < maxDim * 2; d += spacing) {
      canvas.drawLine(
        Offset(bounds.left + d, bounds.top),
        Offset(bounds.left + d + bounds.height, bounds.bottom),
        paint,
      );
    }
  }

  void _drawDotsHatch(Canvas canvas, Rect bounds, Paint paint, double spacing) {
    paint.style = PaintingStyle.fill;
    for (var x = bounds.left; x < bounds.right; x += spacing) {
      for (var y = bounds.top; y < bounds.bottom; y += spacing) {
        canvas.drawCircle(Offset(x, y), paint.strokeWidth * 0.5, paint);
      }
    }
  }
}

/// Trapezoid primitive - specialized quadrilateral for canal sections, ramps
@immutable
class DiagramTrapezoid extends DiagramPrimitive {
  final Offset bottomLeft;
  final Offset bottomRight;
  final Offset topLeft;
  final Offset topRight;
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final HatchPattern? hatch;

  const DiagramTrapezoid({
    required String id,
    required this.bottomLeft,
    required this.bottomRight,
    required this.topLeft,
    required this.topRight,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.hatch,
    int zIndex = 0,
    bool visible = true,
    String? label,
    int version = 0,
  }) : super(id: id, zIndex: zIndex, visible: visible, label: label, version: version);

  @override
  DiagramTrapezoid copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    Offset? bottomLeft,
    Offset? bottomRight,
    Offset? topLeft,
    Offset? topRight,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    HatchPattern? hatch,
  }) {
    return DiagramTrapezoid(
      id: id ?? this.id,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      hatch: hatch ?? this.hatch,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }

  @override
  Rect get bounds {
    double minX = bottomLeft.dx;
    double minY = bottomLeft.dy;
    double maxX = minX;
    double maxY = minY;

    for (final point in [bottomRight, topLeft, topRight]) {
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
    if (!visible) return;

    final bl = mapper.worldToCanvas(bottomLeft);
    final br = mapper.worldToCanvas(bottomRight);
    final tl = mapper.worldToCanvas(topLeft);
    final tr = mapper.worldToCanvas(topRight);

    final path = Path()
      ..moveTo(bl.dx, bl.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(tr.dx, tr.dy)
      ..lineTo(tl.dx, tl.dy)
      ..close();

    // Fill
    if (fillColor != null && fillColor!.alpha > 0) {
      paint
        ..color = fillColor!
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    }

    // Stroke
    if (strokeColor != null && strokeWidth > 0) {
      paint
        ..color = strokeColor!
        ..strokeWidth = strokeWidth * mapper.scale
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    }
  }
}
