import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/visualization/annotations/annotation_primitives.dart';

/// Types of annotations available in the system
enum AnnotationType {
  text,
  marker,
  highlight,
  dimension,
  callout,
}

/// Style configuration for annotations
class AnnotationStyle {
  final Color color;
  final double strokeWidth;
  final double fontSize;
  final Color fillColor;
  final double opacity;

  const AnnotationStyle({
    this.color = const Color(0xFFFF0000),
    this.strokeWidth = 2.0,
    this.fontSize = 14.0,
    this.fillColor = const Color(0x00000000),
    this.opacity = 1.0,
  });

  AnnotationStyle copyWith({
    Color? color,
    double? strokeWidth,
    double? fontSize,
    Color? fillColor,
    double? opacity,
  }) {
    return AnnotationStyle(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      fontSize: fontSize ?? this.fontSize,
      fillColor: fillColor ?? this.fillColor,
      opacity: opacity ?? this.opacity,
    );
  }
}

/// Base class for all annotations
abstract class Annotation {
  final String id;
  final AnnotationType type;
  final Offset position;
  final int zIndex;
  final bool isLocked;
  final bool isVisible;
  final AnnotationStyle style;

  const Annotation({
    required this.id,
    required this.type,
    required this.position,
    this.zIndex = 1000,
    this.isLocked = false,
    this.isVisible = true,
    this.style = const AnnotationStyle(),
  });

  Annotation copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    AnnotationStyle? style,
  });

  Rect get bounds;
  bool containsPoint(Offset point);
  Map<String, dynamic> toJson();
  
  /// Convert this annotation to a DiagramPrimitive for rendering
  /// This ensures annotations use the same rendering pipeline as all other primitives
  DiagramPrimitive toPrimitive();
}

/// Text annotation
class TextAnnotation extends Annotation {
  final String text;
  final double maxWidth;

  const TextAnnotation({
    required super.id,
    required super.position,
    required this.text,
    this.maxWidth = 200.0,
    super.zIndex,
    super.isLocked,
    super.isVisible,
    super.style,
  }) : super(type: AnnotationType.text);

  @override
  TextAnnotation copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    AnnotationStyle? style,
    String? text,
    double? maxWidth,
  }) {
    return TextAnnotation(
      id: id ?? this.id,
      position: position ?? this.position,
      text: text ?? this.text,
      maxWidth: maxWidth ?? this.maxWidth,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      style: style ?? this.style,
    );
  }

  @override
  Rect get bounds {
    final width = text.length * style.fontSize * 0.6;
    return Rect.fromLTWH(position.dx, position.dy, width.clamp(0, maxWidth), style.fontSize * 1.2);
  }

  @override
  bool containsPoint(Offset point) => bounds.contains(point);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'text',
    'id': id,
    'position': {'dx': position.dx, 'dy': position.dy},
    'text': text,
    'maxWidth': maxWidth,
    'zIndex': zIndex,
    'isLocked': isLocked,
    'isVisible': isVisible,
    'style': {
      'color': style.color.toARGB32(),
      'fontSize': style.fontSize,
    },
  };

  @override
  DiagramPrimitive toPrimitive() => TextAnnotationPrimitive(
    id: id,
    position: position,
    text: text,
    fontSize: style.fontSize,
    color: style.color,
    zIndex: zIndex,
    visible: isVisible,
  );
}

/// Marker annotation
class MarkerAnnotation extends Annotation {
  final MarkerShape shape;
  final double size;

  const MarkerAnnotation({
    required super.id,
    required super.position,
    this.shape = MarkerShape.circle,
    this.size = 20.0,
    super.zIndex,
    super.isLocked,
    super.isVisible,
    super.style,
  }) : super(type: AnnotationType.marker);

  @override
  MarkerAnnotation copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    AnnotationStyle? style,
    MarkerShape? shape,
    double? size,
  }) {
    return MarkerAnnotation(
      id: id ?? this.id,
      position: position ?? this.position,
      shape: shape ?? this.shape,
      size: size ?? this.size,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      style: style ?? this.style,
    );
  }

  @override
  Rect get bounds => Rect.fromCenter(center: position, width: size * 2, height: size * 2);

  @override
  bool containsPoint(Offset point) => bounds.contains(point);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'marker',
    'id': id,
    'position': {'dx': position.dx, 'dy': position.dy},
    'shape': shape.name,
    'size': size,
    'zIndex': zIndex,
    'isLocked': isLocked,
    'isVisible': isVisible,
    'style': {'color': style.color.toARGB32(), 'strokeWidth': style.strokeWidth},
  };

  @override
  DiagramPrimitive toPrimitive() => MarkerAnnotationPrimitive(
    id: id,
    position: position,
    markerText: shape.name,
    fontSize: style.fontSize,
    color: style.color,
    zIndex: zIndex,
    visible: isVisible,
  );
}

enum MarkerShape { circle, square, crosshair }

/// Highlight annotation
class HighlightAnnotation extends Annotation {
  final double width;
  final double height;

  const HighlightAnnotation({
    required super.id,
    required super.position,
    required this.width,
    required this.height,
    super.zIndex,
    super.isLocked,
    super.isVisible,
    super.style,
  }) : super(type: AnnotationType.highlight);

  @override
  HighlightAnnotation copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    AnnotationStyle? style,
    double? width,
    double? height,
  }) {
    return HighlightAnnotation(
      id: id ?? this.id,
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      style: style ?? this.style,
    );
  }

  @override
  Rect get bounds => Rect.fromLTWH(position.dx, position.dy, width, height);

  @override
  bool containsPoint(Offset point) => bounds.inflate(5).contains(point);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'highlight',
    'id': id,
    'position': {'dx': position.dx, 'dy': position.dy},
    'width': width,
    'height': height,
    'zIndex': zIndex,
    'isLocked': isLocked,
    'isVisible': isVisible,
    'style': {'color': style.color.toARGB32(), 'fillColor': style.fillColor.toARGB32(), 'opacity': style.opacity},
  };

  @override
  DiagramPrimitive toPrimitive() => HighlightAnnotationPrimitive(
    id: id,
    start: position,
    end: position + Offset(width, height),
    color: style.fillColor.withValues(alpha: style.opacity),
    zIndex: zIndex,
    visible: isVisible,
  );
}

/// Dimension annotation
class DimensionAnnotation extends Annotation {
  final Offset endPosition;
  final String value;

  const DimensionAnnotation({
    required super.id,
    required super.position,
    required this.endPosition,
    required this.value,
    super.zIndex,
    super.isLocked,
    super.isVisible,
    super.style,
  }) : super(type: AnnotationType.dimension);

  @override
  DimensionAnnotation copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    AnnotationStyle? style,
    Offset? endPosition,
    String? value,
  }) {
    return DimensionAnnotation(
      id: id ?? this.id,
      position: position ?? this.position,
      endPosition: endPosition ?? this.endPosition,
      value: value ?? this.value,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      style: style ?? this.style,
    );
  }

  @override
  Rect get bounds {
    final minX = position.dx < endPosition.dx ? position.dx : endPosition.dx;
    final minY = position.dy < endPosition.dy ? position.dy : endPosition.dy;
    final maxX = position.dx > endPosition.dx ? position.dx : endPosition.dx;
    final maxY = position.dy > endPosition.dy ? position.dy : endPosition.dy;
    return Rect.fromLTRB(minX, minY, maxX, maxY).inflate(15);
  }

  @override
  bool containsPoint(Offset point) => bounds.contains(point);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'dimension',
    'id': id,
    'position': {'dx': position.dx, 'dy': position.dy},
    'endPosition': {'dx': endPosition.dx, 'dy': endPosition.dy},
    'value': value,
    'zIndex': zIndex,
    'isLocked': isLocked,
    'isVisible': isVisible,
    'style': {'color': style.color.toARGB32(), 'strokeWidth': style.strokeWidth},
  };

  @override
  DiagramPrimitive toPrimitive() => DimensionAnnotationPrimitive(
    id: id,
    start: position,
    end: endPosition,
    fontSize: style.fontSize,
    color: style.color,
    zIndex: zIndex,
    visible: isVisible,
    label: value,
  );
}

/// Callout annotation
class CalloutAnnotation extends Annotation {
  final Offset targetPosition;
  final String text;

  const CalloutAnnotation({
    required super.id,
    required super.position,
    required this.targetPosition,
    required this.text,
    super.zIndex,
    super.isLocked,
    super.isVisible,
    super.style,
  }) : super(type: AnnotationType.callout);

  @override
  CalloutAnnotation copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    AnnotationStyle? style,
    Offset? targetPosition,
    String? text,
  }) {
    return CalloutAnnotation(
      id: id ?? this.id,
      position: position ?? this.position,
      targetPosition: targetPosition ?? this.targetPosition,
      text: text ?? this.text,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      style: style ?? this.style,
    );
  }

  @override
  Rect get bounds {
    final bubbleWidth = text.length * style.fontSize * 0.6 + 20;
    final bubbleHeight = style.fontSize * 2 + 10;
    return Rect.fromLTWH(position.dx, position.dy, bubbleWidth, bubbleHeight).inflate(10);
  }

  @override
  bool containsPoint(Offset point) => bounds.contains(point);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'callout',
    'id': id,
    'position': {'dx': position.dx, 'dy': position.dy},
    'targetPosition': {'dx': targetPosition.dx, 'dy': targetPosition.dy},
    'text': text,
    'zIndex': zIndex,
    'isLocked': isLocked,
    'isVisible': isVisible,
    'style': {'color': style.color.toARGB32(), 'fillColor': style.fillColor.toARGB32()},
  };

  @override
  DiagramPrimitive toPrimitive() => CalloutAnnotationPrimitive(
    id: id,
    start: position,
    end: targetPosition,
    text: text,
    fontSize: style.fontSize,
    color: style.color,
    zIndex: zIndex,
    visible: isVisible,
  );
}

/// Serialization helpers
Annotation annotationFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String;
  switch (type) {
    case 'text':
      return TextAnnotation(
        id: json['id'],
        position: Offset(json['position']['dx'], json['position']['dy']),
        text: json['text'],
        maxWidth: json['maxWidth'] ?? 200.0,
        zIndex: json['zIndex'] ?? 1000,
        isLocked: json['isLocked'] ?? false,
        isVisible: json['isVisible'] ?? true,
        style: AnnotationStyle(
          color: Color(json['style']?['color'] ?? 0xFFFF0000),
          fontSize: json['style']?['fontSize'] ?? 14.0,
        ),
      );
    case 'marker':
      return MarkerAnnotation(
        id: json['id'],
        position: Offset(json['position']['dx'], json['position']['dy']),
        shape: MarkerShape.values.firstWhere((e) => e.name == json['shape'], orElse: () => MarkerShape.circle),
        size: json['size'] ?? 20.0,
        zIndex: json['zIndex'] ?? 1000,
        isLocked: json['isLocked'] ?? false,
        isVisible: json['isVisible'] ?? true,
        style: AnnotationStyle(
          color: Color(json['style']?['color'] ?? 0xFFFF0000),
          strokeWidth: json['style']?['strokeWidth'] ?? 2.0,
        ),
      );
    case 'highlight':
      return HighlightAnnotation(
        id: json['id'],
        position: Offset(json['position']['dx'], json['position']['dy']),
        width: json['width'] ?? 100.0,
        height: json['height'] ?? 50.0,
        zIndex: json['zIndex'] ?? 1000,
        isLocked: json['isLocked'] ?? false,
        isVisible: json['isVisible'] ?? true,
        style: AnnotationStyle(
          color: Color(json['style']?['color'] ?? 0xFFFF0000),
          fillColor: Color(json['style']?['fillColor'] ?? 0x40FF0000),
          opacity: json['style']?['opacity'] ?? 0.3,
        ),
      );
    case 'dimension':
      return DimensionAnnotation(
        id: json['id'],
        position: Offset(json['position']['dx'], json['position']['dy']),
        endPosition: Offset(json['endPosition']['dx'], json['endPosition']['dy']),
        value: json['value'] ?? '',
        zIndex: json['zIndex'] ?? 1000,
        isLocked: json['isLocked'] ?? false,
        isVisible: json['isVisible'] ?? true,
        style: AnnotationStyle(
          color: Color(json['style']?['color'] ?? 0xFF000000),
          strokeWidth: json['style']?['strokeWidth'] ?? 1.0,
        ),
      );
    case 'callout':
      return CalloutAnnotation(
        id: json['id'],
        position: Offset(json['position']['dx'], json['position']['dy']),
        targetPosition: Offset(json['targetPosition']['dx'], json['targetPosition']['dy']),
        text: json['text'] ?? '',
        zIndex: json['zIndex'] ?? 1000,
        isLocked: json['isLocked'] ?? false,
        isVisible: json['isVisible'] ?? true,
        style: AnnotationStyle(
          color: Color(json['style']?['color'] ?? 0xFFFF0000),
          fillColor: Color(json['style']?['fillColor'] ?? 0xFFFFFFFF),
        ),
      );
    default:
      throw ArgumentError('Unknown annotation type: $type');
  }
}
