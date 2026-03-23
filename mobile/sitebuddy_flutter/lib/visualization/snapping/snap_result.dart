import 'package:flutter/painting.dart';

/// Result of a snap operation
/// Contains the snapped point, type of snap, and distance from original point
class SnapResult {
  /// The snapped point in world coordinates
  final Offset snappedPoint;

  /// The type of snap that was applied
  final SnapType type;

  /// Distance from the original point to the snapped point
  final double distance;

  /// Reference to the primitive that was snapped to (if applicable)
  final String? snappedToPrimitiveId;

  /// Reference to the specific snap point (vertex index, edge id, etc.)
  final String? snapTargetId;

  const SnapResult({
    required this.snappedPoint,
    required this.type,
    required this.distance,
    this.snappedToPrimitiveId,
    this.snapTargetId,
  });

  /// Creates a "no snap" result (point unchanged)
  factory SnapResult.none(Offset originalPoint) {
    return SnapResult(
      snappedPoint: originalPoint,
      type: SnapType.none,
      distance: 0.0,
    );
  }

  /// Check if this result represents no snap
  bool get hasSnapped => type != SnapType.none;

  @override
  String toString() {
    return 'SnapResult(point: $snappedPoint, type: $type, distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SnapResult &&
        other.snappedPoint == snappedPoint &&
        other.type == type &&
        other.distance == distance;
  }

  @override
  int get hashCode => Object.hash(snappedPoint, type, distance);
}

/// Types of snapping that can be applied
enum SnapType {
  /// No snap applied
  none,

  /// Snap to grid lines
  grid,

  /// Snap to vertex/endpoints of primitives
  vertex,

  /// Snap to edge of a primitive
  edge,

  /// Snap to midpoint of a line/edge
  midpoint,

  /// Snap to alignment with other primitives (horizontal/vertical)
  alignment,

  /// Snap to intersection of two primitives
  intersection,

  /// Snap to center of a primitive
  center,
}

/// Configuration for snap behavior
class SnapConfig {
  /// Whether snapping is enabled
  final bool enabled;

  /// Whether grid snapping is enabled
  final bool gridEnabled;

  /// Grid size in world units
  final double gridSize;

  /// Whether vertex snapping is enabled
  final bool vertexEnabled;

  /// Whether edge snapping is enabled
  final bool edgeEnabled;

  /// Whether midpoint snapping is enabled
  final bool midpointEnabled;

  /// Whether alignment snapping is enabled
  final bool alignmentEnabled;

  /// Snap radius in screen pixels (converted to world units based on zoom)
  final double snapRadius;

  /// Priority order for snap types (first match wins)
  final List<SnapType> priority;

  /// Maximum distance for a snap to be considered (world units)
  final double maxSnapDistance;

  const SnapConfig({
    this.enabled = true,
    this.gridEnabled = true,
    this.gridSize = 10.0,
    this.vertexEnabled = true,
    this.edgeEnabled = true,
    this.midpointEnabled = true,
    this.alignmentEnabled = true,
    this.snapRadius = 15.0,
    this.priority = const [
      SnapType.vertex,
      SnapType.midpoint,
      SnapType.grid,
      SnapType.alignment,
      SnapType.edge,
    ],
    this.maxSnapDistance = 20.0,
  });

  /// Default snap configuration for precision CAD work
  static const cad = SnapConfig(
    enabled: true,
    gridEnabled: true,
    gridSize: 5.0,
    vertexEnabled: true,
    edgeEnabled: true,
    midpointEnabled: true,
    alignmentEnabled: true,
    snapRadius: 10.0,
    maxSnapDistance: 15.0,
  );

  /// Snap configuration for loose/pixel-based work
  static const loose = SnapConfig(
    enabled: true,
    gridEnabled: true,
    gridSize: 20.0,
    vertexEnabled: true,
    edgeEnabled: false,
    midpointEnabled: false,
    alignmentEnabled: false,
    snapRadius: 20.0,
    maxSnapDistance: 25.0,
  );

  /// Snap configuration with all features disabled
  static const disabled = SnapConfig(
    enabled: false,
  );

  /// Check if a specific snap type is enabled
  bool isEnabled(SnapType type) {
    switch (type) {
      case SnapType.none:
        return false;
      case SnapType.grid:
        return gridEnabled;
      case SnapType.vertex:
        return vertexEnabled;
      case SnapType.edge:
        return edgeEnabled;
      case SnapType.midpoint:
        return midpointEnabled;
      case SnapType.alignment:
        return alignmentEnabled;
      case SnapType.intersection:
        return false;
      case SnapType.center:
        return false;
    }
  }

  /// Create a copy with modifications
  SnapConfig copyWith({
    bool? enabled,
    bool? gridEnabled,
    double? gridSize,
    bool? vertexEnabled,
    bool? edgeEnabled,
    bool? midpointEnabled,
    bool? alignmentEnabled,
    double? snapRadius,
    List<SnapType>? priority,
    double? maxSnapDistance,
  }) {
    return SnapConfig(
      enabled: enabled ?? this.enabled,
      gridEnabled: gridEnabled ?? this.gridEnabled,
      gridSize: gridSize ?? this.gridSize,
      vertexEnabled: vertexEnabled ?? this.vertexEnabled,
      edgeEnabled: edgeEnabled ?? this.edgeEnabled,
      midpointEnabled: midpointEnabled ?? this.midpointEnabled,
      alignmentEnabled: alignmentEnabled ?? this.alignmentEnabled,
      snapRadius: snapRadius ?? this.snapRadius,
      priority: priority ?? this.priority,
      maxSnapDistance: maxSnapDistance ?? this.maxSnapDistance,
    );
  }
}
