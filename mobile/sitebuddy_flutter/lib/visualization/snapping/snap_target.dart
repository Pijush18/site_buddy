import 'package:flutter/painting.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/visualization/primitives/polyline_primitive.dart';
import 'package:site_buddy/visualization/snapping/snap_result.dart';

/// A snap target point extracted from a primitive
/// These are cached for performance
class SnapTarget {
  /// The position of this snap target in world coordinates
  final Offset position;

  /// The type of this snap target
  final SnapType type;

  /// ID of the primitive this target belongs to
  final String primitiveId;

  /// Unique identifier for this specific target within the primitive
  final String targetId;

  /// Priority of this target (lower = higher priority when distances equal)
  final int priority;

  const SnapTarget({
    required this.position,
    required this.type,
    required this.primitiveId,
    required this.targetId,
    required this.priority,
  });

  @override
  String toString() {
    return 'SnapTarget(pos: $position, type: $type, targetId: $targetId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SnapTarget &&
        other.position == position &&
        other.type == type &&
        other.primitiveId == primitiveId &&
        other.targetId == targetId;
  }

  @override
  int get hashCode => Object.hash(position, type, primitiveId, targetId);
}

/// Extracts snap targets from DiagramPrimitives
/// This class is used to build the snap layer from primitives
class SnapTargetExtractor {
  /// Extract all snap targets from a list of primitives
  static List<SnapTarget> extractAll(
    List<DiagramPrimitive> primitives, {
    bool includeVertices = true,
    bool includeMidpoints = true,
    bool includeCenters = true,
  }) {
    final targets = <SnapTarget>[];

    for (final primitive in primitives) {
      if (!primitive.visible) continue;
      targets.addAll(extractFrom(primitive, includeVertices: includeVertices,
          includeMidpoints: includeMidpoints, includeCenters: includeCenters));
    }

    return targets;
  }

  /// Extract snap targets from a single primitive
  static List<SnapTarget> extractFrom(
    DiagramPrimitive primitive, {
    bool includeVertices = true,
    bool includeMidpoints = true,
    bool includeCenters = true,
  }) {
    final targets = <SnapTarget>[];

    if (primitive is DiagramLine) {
      targets.addAll(_extractFromLine(primitive));
    } else if (primitive is DiagramRect) {
      targets.addAll(_extractFromRect(primitive));
    } else if (primitive is DiagramText) {
      targets.addAll(_extractFromText(primitive));
    } else if (primitive is DiagramGroup) {
      targets.addAll(_extractFromGroup(primitive));
    } else if (primitive is DiagramPolyline) {
      targets.addAll(_extractFromPolyline(primitive));
    }

    return targets;
  }

  static List<SnapTarget> _extractFromLine(DiagramLine line) {
    final targets = <SnapTarget>[];
    final id = line.id;

    // Vertices (endpoints)
    targets.add(SnapTarget(
      position: line.start,
      type: SnapType.vertex,
      primitiveId: id,
      targetId: '$id-start',
      priority: 0,
    ));
    targets.add(SnapTarget(
      position: line.end,
      type: SnapType.vertex,
      primitiveId: id,
      targetId: '$id-end',
      priority: 0,
    ));

    // Midpoint
    final midpoint = Offset(
      (line.start.dx + line.end.dx) / 2,
      (line.start.dy + line.end.dy) / 2,
    );
    targets.add(SnapTarget(
      position: midpoint,
      type: SnapType.midpoint,
      primitiveId: id,
      targetId: '$id-mid',
      priority: 1,
    ));

    // Center
    targets.add(SnapTarget(
      position: midpoint,
      type: SnapType.center,
      primitiveId: id,
      targetId: '$id-center',
      priority: 2,
    ));

    return targets;
  }

  static List<SnapTarget> _extractFromRect(DiagramRect rect) {
    final targets = <SnapTarget>[];
    final id = rect.id;

    // Four corners (vertices)
    final corners = [
      rect.position, // bottom-left
      Offset(rect.position.dx + rect.width, rect.position.dy), // bottom-right
      Offset(rect.position.dx, rect.position.dy + rect.height), // top-left
      Offset(rect.position.dx + rect.width, rect.position.dy + rect.height), // top-right
    ];

    for (var i = 0; i < corners.length; i++) {
      targets.add(SnapTarget(
        position: corners[i],
        type: SnapType.vertex,
        primitiveId: id,
        targetId: '$id-corner-$i',
        priority: 0,
      ));
    }

    // Edge midpoints
    final midpoints = [
      Offset(rect.position.dx + rect.width / 2, rect.position.dy), // bottom
      Offset(rect.position.dx + rect.width / 2, rect.position.dy + rect.height), // top
      Offset(rect.position.dx, rect.position.dy + rect.height / 2), // left
      Offset(rect.position.dx + rect.width, rect.position.dy + rect.height / 2), // right
    ];

    for (var i = 0; i < midpoints.length; i++) {
      targets.add(SnapTarget(
        position: midpoints[i],
        type: SnapType.midpoint,
        primitiveId: id,
        targetId: '$id-edge-$i',
        priority: 1,
      ));
    }

    // Center
    targets.add(SnapTarget(
      position: Offset(
        rect.position.dx + rect.width / 2,
        rect.position.dy + rect.height / 2,
      ),
      type: SnapType.center,
      primitiveId: id,
      targetId: '$id-center',
      priority: 2,
    ));

    return targets;
  }

  static List<SnapTarget> _extractFromText(DiagramText text) {
    final targets = <SnapTarget>[];

    // Snap to text position (center of text)
    targets.add(SnapTarget(
      position: text.position,
      type: SnapType.vertex,
      primitiveId: text.id,
      targetId: '${text.id}-pos',
      priority: 0,
    ));

    return targets;
  }

  static List<SnapTarget> _extractFromGroup(DiagramGroup group) {
    // Extract from all children with transformed positions
    final targets = <SnapTarget>[];

    for (final child in group.children) {
      final childTargets = extractFrom(child);
      for (final target in childTargets) {
        // Apply group transform to position
        final transformedPos = _applyTransform(
          target.position,
          group.translation,
          group.rotation,
          group.scale,
        );
        targets.add(SnapTarget(
          position: transformedPos,
          type: target.type,
          primitiveId: group.id,
          targetId: target.targetId,
          priority: target.priority,
        ));
      }
    }

    return targets;
  }

  static List<SnapTarget> _extractFromPolyline(DiagramPolyline polyline) {
    final targets = <SnapTarget>[];
    final id = polyline.id;
    final points = polyline.points;

    if (points.isEmpty) return targets;

    // Vertices (all points)
    for (var i = 0; i < points.length; i++) {
      targets.add(SnapTarget(
        position: points[i],
        type: SnapType.vertex,
        primitiveId: id,
        targetId: '$id-vertex-$i',
        priority: 0,
      ));
    }

    // Midpoints between consecutive points
    for (var i = 0; i < points.length - 1; i++) {
      final midpoint = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        (points[i].dy + points[i + 1].dy) / 2,
      );
      targets.add(SnapTarget(
        position: midpoint,
        type: SnapType.midpoint,
        primitiveId: id,
        targetId: '$id-mid-$i',
        priority: 1,
      ));
    }

    return targets;
  }

  static Offset _applyTransform(
    Offset point,
    Offset translation,
    double rotation,
    double scale,
  ) {
    // Apply scale
    var result = Offset(point.dx * scale, point.dy * scale);

    // Apply rotation
    if (rotation != 0.0) {
      final cos = _cos(rotation);
      final sin = _sin(rotation);
      result = Offset(
        result.dx * cos - result.dy * sin,
        result.dx * sin + result.dy * cos,
      );
    }

    // Apply translation
    result = result + translation;

    return result;
  }

  static double _cos(double radians) {
    return _cosTable(radians);
  }

  static double _sin(double radians) {
    return _sinTable(radians);
  }

  // Precomputed trig tables for performance (optional micro-optimization)
  static double _cosTable(double radians) {
    // Simple implementation - in production could use lookup table
    return _taylorCos(radians);
  }

  static double _sinTable(double radians) {
    return _taylorSin(radians);
  }

  static double _taylorCos(double x) {
    // Normalize to -pi to pi
    while (x > 3.14159265359) {
      x -= 6.28318530718;
    }
    while (x < -3.14159265359) {
      x += 6.28318530718;
    }
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _taylorSin(double x) {
    // Normalize to -pi to pi
    while (x > 3.14159265359) {
      x -= 6.28318530718;
    }
    while (x < -3.14159265359) {
      x += 6.28318530718;
    }
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}
