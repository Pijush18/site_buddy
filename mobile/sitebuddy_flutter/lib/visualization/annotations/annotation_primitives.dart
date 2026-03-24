import 'dart:math' as math;
import 'package:flutter/painting.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart';

/// Annotation types matching the original model
enum AnnotationType {
  text,
  marker,
  highlight,
  dimension,
  callout,
}

/// Annotation data (kept for state management and serialization)
class AnnotationData {
  final String id;
  final AnnotationType type;
  final Offset position;
  final Offset? end;
  final String? label;
  final String? text;
  final double? fontSize;
  final Color? color;
  final int? zIndex;
  final bool? visible;
  final Map<String, dynamic>? metadata;

  const AnnotationData({
    required this.id,
    required this.type,
    required this.position,
    this.end,
    this.label,
    this.text,
    this.fontSize,
    this.color,
    this.zIndex,
    this.visible,
    this.metadata,
  });

  AnnotationData copyWith({
    String? id,
    AnnotationType? type,
    Offset? position,
    Offset? end,
    String? label,
    String? text,
    double? fontSize,
    Color? color,
    int? zIndex,
    bool? visible,
    Map<String, dynamic>? metadata,
  }) {
    return AnnotationData(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      end: end ?? this.end,
      label: label ?? this.label,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'position': {'x': position.dx, 'y': position.dy},
      if (end != null) 'end': {'x': end!.dx, 'y': end!.dy},
      if (label != null) 'label': label,
      if (text != null) 'text': text,
      if (fontSize != null) 'fontSize': fontSize,
      if (color != null) 'color': color!.toARGB32(),
      if (zIndex != null) 'zIndex': zIndex,
      if (visible != null) 'visible': visible,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AnnotationData.fromJson(Map<String, dynamic> json) {
    return AnnotationData(
      id: json['id'] as String,
      type: AnnotationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnnotationType.text,
      ),
      position: Offset(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      end: json['end'] != null
          ? Offset(
              (json['end']['x'] as num).toDouble(),
              (json['end']['y'] as num).toDouble(),
            )
          : null,
      label: json['label'] as String?,
      text: json['text'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      color: json['color'] != null ? Color(json['color'] as int) : null,
      zIndex: json['zIndex'] as int?,
      visible: json['visible'] as bool?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Text annotation primitive
class TextAnnotationPrimitive extends DiagramPrimitive {
  final Offset position;
  final String text;
  final double fontSize;
  final Color color;
  final TextStyle? textStyle;

  const TextAnnotationPrimitive({
    required super.id,
    required this.position,
    required this.text,
    this.fontSize = 14.0,
    this.color = const Color(0xFF2196F3),
    this.textStyle,
    super.zIndex = 1000,
    super.visible = true,
    super.label,
    super.version,
  });

  /// Estimated text width based on character count
  double get _estimatedWidth => text.length * fontSize * 0.6;

  @override
  Rect get bounds => Rect.fromLTWH(
    position.dx,
    position.dy,
    _estimatedWidth.clamp(20, 200),
    fontSize * 1.5,
  );

  @override
  bool hitTest(Offset point) => bounds.contains(point);

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasPos = mapper.worldToCanvas(position);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle ?? TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Draw background
    final bgRect = Rect.fromLTWH(
      canvasPos.dx - 4,
      canvasPos.dy - 2,
      textPainter.width + 8,
      textPainter.height + 4,
    );
    
    paint
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      paint,
    );
    
    textPainter.paint(canvas, canvasPos);
  }

  @override
  TextAnnotationPrimitive copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    Offset? position,
    String? text,
    double? fontSize,
    Color? color,
    TextStyle? textStyle,
  }) {
    return TextAnnotationPrimitive(
      id: id ?? this.id,
      position: position ?? this.position,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      textStyle: textStyle ?? this.textStyle,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }
}

/// Marker annotation primitive (pin with label)
class MarkerAnnotationPrimitive extends DiagramPrimitive {
  final Offset position;
  final String markerText;
  final double fontSize;
  final Color color;

  const MarkerAnnotationPrimitive({
    required super.id,
    required this.position,
    required this.markerText,
    this.fontSize = 12.0,
    this.color = const Color(0xFFE91E63),
    super.zIndex = 1000,
    super.visible = true,
    super.label,
    super.version,
  });

  /// Marker pin size
  static const double pinSize = 16.0;

  @override
  Rect get bounds => Rect.fromCenter(
    center: position,
    width: pinSize * 2,
    height: pinSize + 20, // Extra height for label below
  );

  @override
  bool hitTest(Offset point) => bounds.contains(point);

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasPos = mapper.worldToCanvas(position);
    
    // Draw pin shape
    paint
      ..color = color
      ..style = PaintingStyle.fill;
    
    final pinPath = Path();
    pinPath.moveTo(canvasPos.dx, canvasPos.dy + 16);
    pinPath.quadraticBezierTo(
      canvasPos.dx - 10, canvasPos.dy + 4,
      canvasPos.dx, canvasPos.dy - 8,
    );
    pinPath.quadraticBezierTo(
      canvasPos.dx + 10, canvasPos.dy + 4,
      canvasPos.dx, canvasPos.dy + 16,
    );
    canvas.drawPath(pinPath, paint);
    
    // Draw circle
    canvas.drawCircle(canvasPos, 6, paint);
    
    // Draw label below
    final textPainter = TextPainter(
      text: TextSpan(
        text: markerText,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(canvasPos.dx - textPainter.width / 2, canvasPos.dy + 20),
    );
  }

  @override
  MarkerAnnotationPrimitive copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    Offset? position,
    String? markerText,
    double? fontSize,
    Color? color,
  }) {
    return MarkerAnnotationPrimitive(
      id: id ?? this.id,
      position: position ?? this.position,
      markerText: markerText ?? this.markerText,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }
}

/// Highlight annotation primitive (rectangle overlay)
class HighlightAnnotationPrimitive extends DiagramPrimitive {
  final Offset start;
  final Offset end;
  final Color color;

  const HighlightAnnotationPrimitive({
    required super.id,
    required this.start,
    required this.end,
    this.color = const Color(0x80FFEB3B),
    super.zIndex = 1000,
    super.visible = true,
    super.label,
    super.version,
  });

  @override
  Rect get bounds => Rect.fromPoints(start, end);

  @override
  bool hitTest(Offset point) => bounds.inflate(5).contains(point);

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasStart = mapper.worldToCanvas(start);
    final canvasEnd = mapper.worldToCanvas(end);
    
    final rect = Rect.fromPoints(canvasStart, canvasEnd);
    
    paint
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(rect, paint);
  }

  @override
  HighlightAnnotationPrimitive copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    Offset? start,
    Offset? end,
    Color? color,
  }) {
    return HighlightAnnotationPrimitive(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }
}

/// Dimension annotation primitive (measurement line with text)
class DimensionAnnotationPrimitive extends DiagramPrimitive {
  final Offset start;
  final Offset end;
  final double fontSize;
  final Color color;

  const DimensionAnnotationPrimitive({
    required super.id,
    required this.start,
    required this.end,
    this.fontSize = 11.0,
    this.color = const Color(0xFF4CAF50),
    super.zIndex = 1000,
    super.visible = true,
    super.label,
    super.version,
  });

  @override
  Rect get bounds {
    final minX = start.dx < end.dx ? start.dx : end.dx;
    final minY = start.dy < end.dy ? start.dy : end.dy;
    final maxX = start.dx > end.dx ? start.dx : end.dx;
    final maxY = start.dy > end.dy ? start.dy : end.dy;
    return Rect.fromLTRB(minX, minY, maxX, maxY).inflate(15);
  }

  @override
  bool hitTest(Offset point) => bounds.contains(point);

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasStart = mapper.worldToCanvas(start);
    final canvasEnd = mapper.worldToCanvas(end);
    
    paint
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    // Draw main line
    canvas.drawLine(canvasStart, canvasEnd, paint);
    
    // Draw end ticks
    const tickLength = 8.0;
    final delta = canvasEnd - canvasStart;
    final angle = delta.direction;
    
    // Calculate tick endpoints
    final perpAngle = angle + math.pi / 2;
    final tickDx = tickLength * math.cos(perpAngle);
    final tickDy = tickLength * math.sin(perpAngle);
    
    canvas.drawLine(
      canvasStart,
      Offset(canvasStart.dx + tickDx, canvasStart.dy + tickDy),
      paint,
    );
    canvas.drawLine(
      canvasEnd,
      Offset(canvasEnd.dx - tickDx, canvasEnd.dy - tickDy),
      paint,
    );
    
    // Draw distance text
    final distance = (end - start).distance;
    final textPainter = TextPainter(
      text: TextSpan(
        text: distance.toStringAsFixed(1),
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          backgroundColor: const Color(0xFFFFFFFF),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final midPoint = Offset(
      (canvasStart.dx + canvasEnd.dx) / 2 - textPainter.width / 2,
      (canvasStart.dy + canvasEnd.dy) / 2 - textPainter.height / 2,
    );
    
    // Draw background for text
    final textBg = Rect.fromLTWH(
      midPoint.dx - 2,
      midPoint.dy - 1,
      textPainter.width + 4,
      textPainter.height + 2,
    );
    
    paint
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawRect(textBg, paint);
    
    textPainter.paint(canvas, midPoint);
  }

  @override
  DimensionAnnotationPrimitive copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    Offset? start,
    Offset? end,
    double? fontSize,
    Color? color,
  }) {
    return DimensionAnnotationPrimitive(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }
}

/// Callout annotation primitive (arrow with text box)
class CalloutAnnotationPrimitive extends DiagramPrimitive {
  final Offset start;
  final Offset end;
  final String text;
  final double fontSize;
  final Color color;

  const CalloutAnnotationPrimitive({
    required super.id,
    required this.start,
    required this.end,
    required this.text,
    this.fontSize = 12.0,
    this.color = const Color(0xFFFF9800),
    super.zIndex = 1000,
    super.visible = true,
    super.label,
    super.version,
  });

  @override
  Rect get bounds {
    // Include both the text box and the arrow
    final bubbleWidth = text.length * fontSize * 0.6 + 20;
    final bubbleHeight = fontSize * 2 + 10;
    final bubbleRect = Rect.fromLTWH(start.dx, start.dy - bubbleHeight / 2, bubbleWidth, bubbleHeight);
    final arrowRect = Rect.fromPoints(start, end);
    return bubbleRect.inflate(10).expandToInclude(arrowRect.inflate(5));
  }

  @override
  bool hitTest(Offset point) => bounds.contains(point);

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasStart = mapper.worldToCanvas(start);
    final canvasEnd = mapper.worldToCanvas(end);
    
    // Draw arrow line
    paint
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(canvasStart, canvasEnd, paint);
    
    // Draw arrowhead
    final delta = canvasEnd - canvasStart;
    final angle = delta.direction;
    const arrowLength = 12.0;
    const arrowAngle = 0.5;
    
    final arrowPoint1 = Offset(
      canvasEnd.dx - arrowLength * math.cos(angle - arrowAngle),
      canvasEnd.dy - arrowLength * math.sin(angle - arrowAngle),
    );
    final arrowPoint2 = Offset(
      canvasEnd.dx - arrowLength * math.cos(angle + arrowAngle),
      canvasEnd.dy - arrowLength * math.sin(angle + arrowAngle),
    );
    
    canvas.drawLine(canvasEnd, arrowPoint1, paint);
    canvas.drawLine(canvasEnd, arrowPoint2, paint);
    
    // Draw text box
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color(0xFF333333),
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout(maxWidth: 150);
    
    // Position text box near start point
    final textOffset = Offset(
      canvasStart.dx + 10,
      canvasStart.dy - textPainter.height / 2,
    );
    
    // Draw text background
    final textBg = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        textOffset.dx - 4,
        textOffset.dy - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      ),
      const Radius.circular(4),
    );
    
    paint
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(textBg, paint);
    
    paint
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(textBg, paint);
    
    textPainter.paint(canvas, textOffset);
  }

  @override
  CalloutAnnotationPrimitive copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    int? version,
    Offset? start,
    Offset? end,
    String? text,
    double? fontSize,
    Color? color,
  }) {
    return CalloutAnnotationPrimitive(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      version: version ?? this.version + 1,
    );
  }
}

/// Extension to convert AnnotationData to DiagramPrimitive
extension AnnotationDataToPrimitive on AnnotationData {
  /// Convert to a DiagramPrimitive for rendering through renderDiagram()
  DiagramPrimitive toPrimitive() {
    switch (type) {
      case AnnotationType.text:
        return TextAnnotationPrimitive(
          id: id,
          position: position,
          text: text ?? '',
          fontSize: fontSize ?? 14.0,
          color: color ?? const Color(0xFF2196F3),
          zIndex: zIndex ?? 1000,
          visible: visible ?? true,
          label: label,
        );
      case AnnotationType.marker:
        return MarkerAnnotationPrimitive(
          id: id,
          position: position,
          markerText: label ?? 'M',
          fontSize: fontSize ?? 12.0,
          color: color ?? const Color(0xFFE91E63),
          zIndex: zIndex ?? 1000,
          visible: visible ?? true,
          label: label,
        );
      case AnnotationType.highlight:
        return HighlightAnnotationPrimitive(
          id: id,
          start: position,
          end: end ?? position + const Offset(100, 50),
          color: color ?? const Color(0x80FFEB3B),
          zIndex: zIndex ?? 1000,
          visible: visible ?? true,
          label: label,
        );
      case AnnotationType.dimension:
        return DimensionAnnotationPrimitive(
          id: id,
          start: position,
          end: end ?? position + const Offset(100, 0),
          fontSize: fontSize ?? 11.0,
          color: color ?? const Color(0xFF4CAF50),
          zIndex: zIndex ?? 1000,
          visible: visible ?? true,
          label: label,
        );
      case AnnotationType.callout:
        return CalloutAnnotationPrimitive(
          id: id,
          start: position,
          end: end ?? position + const Offset(80, 40),
          text: label ?? '',
          fontSize: fontSize ?? 12.0,
          color: color ?? const Color(0xFFFF9800),
          zIndex: zIndex ?? 1000,
          visible: visible ?? true,
          label: label,
        );
    }
  }
}
