import 'dart:ui';
import 'package:flutter/painting.dart';
import '../primitives/primitives.dart' show DiagramPrimitive, DiagramText, DiagramLine;
import '../primitives/path_primitives.dart' show HatchType;

/// Dimension style for engineering drawings
enum DimensionStyle {
  standard,
  architectural,
  mechanical,
}

/// Dimension annotation helper - reduces boilerplate for creating dimension annotations
class DimensionAnnotation {
  final Offset start;
  final Offset end;
  final String label;
  final double offset;
  final DimensionStyle style;
  final Color color;
  final double extensionLength;
  final double tickLength;

  const DimensionAnnotation({
    required this.start,
    required this.end,
    required this.label,
    this.offset = 15.0,
    this.style = DimensionStyle.standard,
    this.color = const Color(0xFF616161),
    this.extensionLength = 5.0,
    this.tickLength = 3.0,
  });

  /// Create a horizontal dimension with label above
  static DimensionAnnotation horizontal({
    required Offset start,
    required Offset end,
    required String label,
    double offset = 15.0,
  }) {
    return DimensionAnnotation(
      start: start,
      end: end,
      label: label,
      offset: offset,
    );
  }

  /// Create a vertical dimension with label to the right
  static DimensionAnnotation vertical({
    required Offset start,
    required Offset end,
    required String label,
    double offset = 20.0,
  }) {
    return DimensionAnnotation(
      start: start,
      end: end,
      label: label,
      offset: offset,
    );
  }

  /// Create a diagonal/aligned dimension
  static DimensionAnnotation aligned({
    required Offset start,
    required Offset end,
    required String label,
    double offset = 15.0,
  }) {
    return DimensionAnnotation(
      start: start,
      end: end,
      label: label,
      offset: offset,
    );
  }

  /// Convert to group of primitives
  List<DiagramPrimitive> toPrimitives(String prefix, {int startZIndex = 0}) {
    final primitives = <DiagramPrimitive>[];
    int zIndex = startZIndex;

    // Calculate dimension line direction
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = (dx * dx + dy * dy);
    final isHorizontal = dx.abs() > dy.abs();

    // Normalized perpendicular direction (for offset)
    Offset perp;
    if (length <= 0) {
      perp = const Offset(0, 1);
    } else {
      final sqrtLen = length <= 0 ? 1.0 : (length * 0.5);
      perp = Offset(-dy / sqrtLen, dx / sqrtLen);
    }

    // Offset start and end points
    final offsetVec = Offset(perp.dx * offset, perp.dy * offset);
    final lineStart = start + offsetVec;
    final lineEnd = end + offsetVec;

    // Main dimension line
    primitives.add(DiagramLine(
      id: '${prefix}_line',
      start: lineStart,
      end: lineEnd,
      strokeWidth: 0.5,
      color: color,
      zIndex: zIndex++,
    ));

    // Extension lines (perpendicular to dimension line)
    final extDir = Offset(-perp.dx, -perp.dy);
    primitives.add(DiagramLine(
      id: '${prefix}_ext_start',
      start: start,
      end: start + extDir * extensionLength,
      strokeWidth: 0.5,
      color: color,
      zIndex: zIndex++,
    ));
    primitives.add(DiagramLine(
      id: '${prefix}_ext_end',
      start: end,
      end: end + extDir * extensionLength,
      strokeWidth: 0.5,
      color: color,
      zIndex: zIndex++,
    ));

    // Tick marks at ends
    if (style == DimensionStyle.architectural) {
      // Architectural style - ticks at 45°
      final tickAngle = 0.785; // 45 degrees
      final cosA = tickLength * 0.707;
      final sinA = tickLength * 0.707;

      // Start tick
      final tickStart1 = lineStart + Offset(cosA, sinA);
      final tickStart2 = lineStart + Offset(-cosA, -sinA);
      primitives.add(DiagramLine(
        id: '${prefix}_tick_start',
        start: tickStart1,
        end: tickStart2,
        strokeWidth: 0.5,
        color: color,
        zIndex: zIndex++,
      ));

      // End tick
      final tickEnd1 = lineEnd + Offset(cosA, -sinA);
      final tickEnd2 = lineEnd + Offset(-cosA, sinA);
      primitives.add(DiagramLine(
        id: '${prefix}_tick_end',
        start: tickEnd1,
        end: tickEnd2,
        strokeWidth: 0.5,
        color: color,
        zIndex: zIndex++,
      ));
    } else {
      // Standard/mechanical style - short perpendicular ticks
      primitives.add(DiagramLine(
        id: '${prefix}_tick_start',
        start: lineStart + Offset(perp.dx * tickLength, perp.dy * tickLength),
        end: lineStart - Offset(perp.dx * tickLength, perp.dy * tickLength),
        strokeWidth: 0.5,
        color: color,
        zIndex: zIndex++,
      ));
      primitives.add(DiagramLine(
        id: '${prefix}_tick_end',
        start: lineEnd + Offset(perp.dx * tickLength, perp.dy * tickLength),
        end: lineEnd - Offset(perp.dx * tickLength, perp.dy * tickLength),
        strokeWidth: 0.5,
        color: color,
        zIndex: zIndex++,
      ));
    }

    // Dimension text at center
    final midPoint = Offset(
      (lineStart.dx + lineEnd.dx) / 2,
      (lineStart.dy + lineEnd.dy) / 2,
    );

    // Adjust text position based on orientation
    Offset textOffset;
    if (isHorizontal) {
      textOffset = Offset(midPoint.dx, midPoint.dy - 8);
    } else {
      textOffset = Offset(midPoint.dx + 10, midPoint.dy);
    }

    primitives.add(DiagramText(
      id: '${prefix}_label',
      position: textOffset,
      text: label,
      fontSize: 10,
      color: color,
      textAlign: TextAlign.center,
      zIndex: zIndex++,
    ));

    return primitives;
  }

  /// Calculate the actual distance value
  double get distance {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    return (dx * dx + dy * dy) <= 0 ? 0 : (dx * dx + dy * dy).sqrt();
  }
}

/// Extension for double to add sqrt
extension DoubleSqrt on double {
  double sqrt() {
    if (this <= 0) return 0;
    return _sqrt(this);
  }

  static double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (var i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}
