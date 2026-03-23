import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import '../coordinate_system/diagram_space.dart';

/// Base class for all drawable primitives
@immutable
abstract class DiagramPrimitive {
  /// Unique identifier
  final String id;

  /// Layer order (higher = on top)
  final int zIndex;

  /// Visibility flag
  final bool visible;

  /// Semantic label for accessibility/selection
  final String? label;

  const DiagramPrimitive({
    required this.id,
    this.zIndex = 0,
    this.visible = true,
    this.label,
  });

  /// Clone with modifications
  DiagramPrimitive copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
  });

  /// Render this primitive to canvas
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper);
}

/// A line segment between two points
@immutable
class DiagramLine extends DiagramPrimitive {
  final Offset start;
  final Offset end;
  final double strokeWidth;
  final Color color;
  final bool dashed;

  const DiagramLine({
    required super.id,
    required this.start,
    required this.end,
    this.strokeWidth = 1.0,
    this.color = const Color(0xFF000000),
    this.dashed = false,
    super.zIndex,
    super.visible,
    super.label,
  });

  @override
  DiagramLine copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    Offset? start,
    Offset? end,
    double? strokeWidth,
    Color? color,
    bool? dashed,
  }) {
    return DiagramLine(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      start: start ?? this.start,
      end: end ?? this.end,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      dashed: dashed ?? this.dashed,
    );
  }

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasStart = mapper.worldToCanvas(start);
    final canvasEnd = mapper.worldToCanvas(end);

    paint
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (dashed) {
      _drawDashedLine(canvas, canvasStart, canvasEnd, paint);
    } else {
      canvas.drawLine(canvasStart, canvasEnd, paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dashLength = 5.0;
    const gapLength = 3.0;

    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final squaredDistance = dx * dx + dy * dy;
    
    // Guard against zero-length lines
    if (squaredDistance == 0) return;
    
    // Use actual Euclidean distance (not squared)
    final totalLength = math.sqrt(squaredDistance);

    // Unit vector along the line direction
    final unitX = dx / totalLength;
    final unitY = dy / totalLength;

    var currentX = a.dx;
    var currentY = a.dy;
    var drawn = 0.0;
    var isDash = true;

    while (drawn < totalLength) {
      final segmentLength = isDash ? dashLength : gapLength;
      
      // Don't draw beyond the line end
      final remainingLength = totalLength - drawn;
      final actualSegmentLength = isDash 
          ? math.min(segmentLength, remainingLength)
          : math.min(segmentLength, remainingLength);
      
      if (actualSegmentLength <= 0) break;

      final nextX = currentX + unitX * actualSegmentLength;
      final nextY = currentY + unitY * actualSegmentLength;

      if (isDash) {
        canvas.drawLine(Offset(currentX, currentY), Offset(nextX, nextY), paint);
      }

      currentX = nextX;
      currentY = nextY;
      drawn += actualSegmentLength;
      isDash = !isDash;
    }
  }
}

/// A rectangle defined by position and size
@immutable
class DiagramRect extends DiagramPrimitive {
  final Offset position; // Bottom-left in world coords
  final double width;
  final double height;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final double cornerRadius;

  const DiagramRect({
    required super.id,
    required this.position,
    required this.width,
    required this.height,
    this.fillColor = const Color(0xFFE0E0E0),
    this.strokeColor = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.cornerRadius = 0.0,
    super.zIndex,
    super.visible,
    super.label,
  });

  @override
  DiagramRect copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    Offset? position,
    double? width,
    double? height,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    double? cornerRadius,
  }) {
    return DiagramRect(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      cornerRadius: cornerRadius ?? this.cornerRadius,
    );
  }

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasPos = mapper.worldToCanvas(position);
    final canvasSize = mapper.worldToCanvasSize(Size(width, height));

    // Fill
    if (fillColor.alpha > 0) {
      paint
        ..color = fillColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(canvasPos.dx, canvasPos.dy - canvasSize.height, canvasSize.width, canvasSize.height),
          Radius.circular(cornerRadius * mapper.scale),
        ),
        paint,
      );
    }

    // Stroke
    if (strokeWidth > 0 && strokeColor.alpha > 0) {
      paint
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * mapper.scale;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(canvasPos.dx, canvasPos.dy - canvasSize.height, canvasSize.width, canvasSize.height),
          Radius.circular(cornerRadius * mapper.scale),
        ),
        paint,
      );
    }
  }
}

/// Text alignment mode for diagram labels
/// 
/// Provides relative positioning options for text labels
/// beyond basic Flutter TextAlign:
/// 
/// - [center] - Centered on the position point
/// - [above] - Positioned above the reference point
/// - [below] - Positioned below the reference point
enum TextAlignMode {
  /// Centered on the position point
  center,

  /// Positioned above the reference point (default for vertical dimensions)
  above,

  /// Positioned below the reference point (default for section titles)
  below,
}

/// Text label with enhanced positioning support
@immutable
class DiagramText extends DiagramPrimitive {
  /// Position anchor point in world coordinates
  final Offset position;

  /// Text content
  final String text;

  /// Base font size (will be scaled by mapper.scale)
  final double fontSize;

  /// Text color
  final Color color;

  /// Font family
  final String fontFamily;

  /// Font weight
  final FontWeight fontWeight;

  /// Flutter TextAlign for horizontal alignment
  final TextAlign textAlign;

  /// TextAlignMode for relative vertical positioning
  final TextAlignMode alignMode;

  /// Maximum text width in world units
  final double maxWidth;

  /// Optional offset in world units for fine-tuning position
  final Offset offset;

  /// Optional rotation angle in radians
  final double rotation;

  const DiagramText({
    required super.id,
    required this.position,
    required this.text,
    this.fontSize = 12.0,
    this.color = const Color(0xFF000000),
    this.fontFamily = 'Roboto',
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.alignMode = TextAlignMode.center,
    this.maxWidth = double.infinity,
    this.offset = Offset.zero,
    this.rotation = 0.0,
    super.zIndex,
    super.visible = true,
    super.label,
  });

  @override
  DiagramText copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    Offset? position,
    String? text,
    double? fontSize,
    Color? color,
    String? fontFamily,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextAlignMode? alignMode,
    double? maxWidth,
    Offset? offset,
    double? rotation,
  }) {
    return DiagramText(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      position: position ?? this.position,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      fontFamily: fontFamily ?? this.fontFamily,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
      alignMode: alignMode ?? this.alignMode,
      maxWidth: maxWidth ?? this.maxWidth,
      offset: offset ?? this.offset,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    final canvasPos = mapper.worldToCanvas(position);
    final scaledFontSize = fontSize * mapper.scale;
    final scaledOffset = Offset(offset.dx * mapper.scale, offset.dy * mapper.scale);

    // Apply alignment offset
    final alignedPos = _applyAlignmentOffset(canvasPos, scaledFontSize, scaledOffset, mapper);

    // Save canvas state if rotation is needed
    if (rotation != 0.0) {
      canvas.save();
      canvas.translate(alignedPos.dx, alignedPos.dy);
      canvas.rotate(rotation);
      canvas.translate(-alignedPos.dx, -alignedPos.dy);
    }

    final textStyle = TextStyle(
      color: color,
      fontSize: scaledFontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );

    textPainter.layout(maxWidth: maxWidth * mapper.scale);
    textPainter.paint(canvas, alignedPos);

    if (rotation != 0.0) {
      canvas.restore();
    }
  }

  Offset _applyAlignmentOffset(
    Offset basePos,
    double scaledFontSize,
    Offset scaledOffset,
    CoordinateMapper mapper,
  ) {
    switch (alignMode) {
      case TextAlignMode.center:
        // No offset needed for center
        return basePos + scaledOffset;
      case TextAlignMode.above:
        // Move up by font height + small gap
        return Offset(
          basePos.dx + scaledOffset.dx,
          basePos.dy - scaledFontSize - (4 * mapper.scale) + scaledOffset.dy,
        );
      case TextAlignMode.below:
        // Move down by small gap
        return Offset(
          basePos.dx + scaledOffset.dx,
          basePos.dy + (4 * mapper.scale) + scaledOffset.dy,
        );
    }
  }

  /// Get the bounding box of this text in world coordinates
  /// Note: This is an approximation as font metrics vary
  Rect get boundingBox {
    // Approximate width based on character count (very rough)
    final approxWidth = text.length * fontSize * 0.6;
    final height = fontSize;

    switch (alignMode) {
      case TextAlignMode.center:
        return Rect.fromCenter(
          center: position,
          width: approxWidth,
          height: height,
        );
      case TextAlignMode.above:
        return Rect.fromLTWH(
          position.dx - approxWidth / 2,
          position.dy - height * 2,
          approxWidth,
          height,
        );
      case TextAlignMode.below:
        return Rect.fromLTWH(
          position.dx - approxWidth / 2,
          position.dy,
          approxWidth,
          height,
        );
    }
  }

  /// Factory constructor for centered text
  factory DiagramText.centered({
    required String id,
    required Offset position,
    required String text,
    double fontSize = 12.0,
    Color color = const Color(0xFF000000),
    String fontFamily = 'Roboto',
    FontWeight fontWeight = FontWeight.normal,
    double maxWidth = double.infinity,
    int zIndex = DiagramLayers.label,
    String? label,
  }) {
    return DiagramText(
      id: id,
      position: position,
      text: text,
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      textAlign: TextAlign.center,
      alignMode: TextAlignMode.center,
      maxWidth: maxWidth,
      zIndex: zIndex,
      label: label,
    );
  }

  /// Factory constructor for text above a reference point
  factory DiagramText.above({
    required String id,
    required Offset referencePoint,
    required String text,
    double fontSize = 12.0,
    Color color = const Color(0xFF000000),
    String fontFamily = 'Roboto',
    FontWeight fontWeight = FontWeight.normal,
    double gap = 4.0,
    int zIndex = DiagramLayers.label,
    String? label,
  }) {
    return DiagramText(
      id: id,
      position: referencePoint,
      text: text,
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      textAlign: TextAlign.center,
      alignMode: TextAlignMode.above,
      offset: Offset(0, -gap),
      zIndex: zIndex,
      label: label,
    );
  }

  /// Factory constructor for text below a reference point
  factory DiagramText.below({
    required String id,
    required Offset referencePoint,
    required String text,
    double fontSize = 12.0,
    Color color = const Color(0xFF000000),
    String fontFamily = 'Roboto',
    FontWeight fontWeight = FontWeight.normal,
    double gap = 4.0,
    int zIndex = DiagramLayers.label,
    String? label,
  }) {
    return DiagramText(
      id: id,
      position: referencePoint,
      text: text,
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      textAlign: TextAlign.center,
      alignMode: TextAlignMode.below,
      offset: Offset(0, gap),
      zIndex: zIndex,
      label: label,
    );
  }

  /// Factory constructor for rotated text
  factory DiagramText.rotated({
    required String id,
    required Offset position,
    required String text,
    required double rotation,
    double fontSize = 12.0,
    Color color = const Color(0xFF000000),
    String fontFamily = 'Roboto',
    FontWeight fontWeight = FontWeight.normal,
    int zIndex = DiagramLayers.label,
    String? label,
  }) {
    return DiagramText(
      id: id,
      position: position,
      text: text,
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      rotation: rotation,
      zIndex: zIndex,
      label: label,
    );
  }
}

/// Group of primitives with transform
@immutable
class DiagramGroup extends DiagramPrimitive {
  final List<DiagramPrimitive> children;
  final Offset translation;
  final double rotation; // Radians
  final double scale;

  const DiagramGroup({
    required super.id,
    required this.children,
    this.translation = Offset.zero,
    this.rotation = 0.0,
    this.scale = 1.0,
    super.zIndex,
    super.visible,
    super.label,
  });

  @override
  DiagramGroup copyWith({
    String? id,
    int? zIndex,
    bool? visible,
    String? label,
    List<DiagramPrimitive>? children,
    Offset? translation,
    double? rotation,
    double? scale,
  }) {
    return DiagramGroup(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      visible: visible ?? this.visible,
      label: label ?? this.label,
      children: children ?? this.children,
      translation: translation ?? this.translation,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
    );
  }

  @override
  void render(Canvas canvas, Paint paint, CoordinateMapper mapper) {
    if (!visible) return;

    canvas.save();

    final canvasTranslation = mapper.worldToCanvas(translation);
    canvas.translate(canvasTranslation.dx, canvasTranslation.dy);
    canvas.rotate(rotation);
    canvas.scale(scale);

    for (final child in children) {
      child.render(canvas, paint, mapper);
    }

    canvas.restore();
  }
}

/// Coordinate mapper interface
abstract class CoordinateMapper {
  /// Convert world coordinates to canvas (screen) coordinates
  Offset worldToCanvas(Offset worldPoint);

  /// Convert canvas coordinates to world coordinates
  Offset canvasToWorld(Offset canvasPoint);

  /// Convert world size to canvas size
  Size worldToCanvasSize(Size worldSize);

  /// Get current scale factor
  double get scale;
}
