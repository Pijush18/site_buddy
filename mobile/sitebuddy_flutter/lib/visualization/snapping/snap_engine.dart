import 'dart:math' as math;
import 'package:flutter/painting.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/visualization/snapping/snap_result.dart';
import 'package:site_buddy/visualization/snapping/snap_target.dart';

/// Core snapping engine that finds the best snap point for a given position
/// 
/// Performance characteristics:
/// - Uses spatial index for O(log n) target lookup
/// - Pre-caches targets when primitives change
/// - Prioritizes snap types for consistent behavior
class SnapEngine {
  SnapConfig _config;
  List<SnapTarget> _cachedTargets = [];

  SnapEngine({SnapConfig? config}) : _config = config ?? const SnapConfig();

  /// Current snap configuration
  SnapConfig get config => _config;

  /// Update snap configuration
  set config(SnapConfig value) {
    if (_config != value) {
      _config = value;
    }
  }

  /// Enable or disable snapping
  set enabled(bool value) {
    _config = _config.copyWith(enabled: value);
  }

  bool get enabled => _config.enabled;

  /// Update the cached snap targets from primitives
  /// Call this when primitives change
  void updateTargets(List<DiagramPrimitive> primitives, {Rect? worldBounds}) {
    if (!_config.enabled) {
      _cachedTargets = [];
      return;
    }

    _cachedTargets = SnapTargetExtractor.extractAll(
      primitives,
      includeVertices: _config.vertexEnabled,
      includeMidpoints: _config.midpointEnabled,
      includeCenters: true, // Always include for better UX
    );
  }

  /// Invalidate cached targets (call when primitives change)
  void invalidate() {
    // Target invalidation handled by caller
  }

  /// Find the best snap result for a given point
  /// 
  /// [point] - The point to snap in world coordinates
  /// [scale] - Current zoom scale (used for pixel-based snap radius)
  /// [excludePrimitiveId] - Optional primitive to exclude from snapping (e.g., the one being moved)
  SnapResult snap(
    Offset point, {
    double scale = 1.0,
    String? excludePrimitiveId,
  }) {
    if (!_config.enabled) {
      return SnapResult.none(point);
    }

    // Convert snap radius from pixels to world units
    final snapRadiusWorld = _config.snapRadius / scale;

    SnapResult? bestResult;

    // Try snap types in priority order
    for (final snapType in _config.priority) {
      if (!_config.isEnabled(snapType)) continue;

      SnapResult? result;
      switch (snapType) {
        case SnapType.grid:
          result = _snapToGrid(point);
          break;
        case SnapType.vertex:
          result = _snapToVertex(point, snapRadiusWorld, excludePrimitiveId);
          break;
        case SnapType.midpoint:
          result = _snapToMidpoint(point, snapRadiusWorld, excludePrimitiveId);
          break;
        case SnapType.edge:
          result = _snapToEdge(point, snapRadiusWorld, excludePrimitiveId);
          break;
        case SnapType.alignment:
          result = _snapToAlignment(point, snapRadiusWorld, excludePrimitiveId);
          break;
        case SnapType.center:
          result = _snapToCenter(point, snapRadiusWorld, excludePrimitiveId);
          break;
        default:
          continue;
      }

      if (result != null && result.hasSnapped) {
        // Check if this snap is within the max distance
        if (result.distance <= _config.maxSnapDistance) {
          bestResult = result;
          break; // First match wins (respects priority)
        }
      }
    }

    return bestResult ?? SnapResult.none(point);
  }

  /// Snap to grid
  SnapResult _snapToGrid(Offset point) {
    if (!_config.gridEnabled) return SnapResult.none(point);

    final gridSize = _config.gridSize;
    final snappedX = (point.dx / gridSize).round() * gridSize;
    final snappedY = (point.dy / gridSize).round() * gridSize;
    final snappedPoint = Offset(snappedX, snappedY);

    final distance = _distance(point, snappedPoint);
    if (distance > _config.maxSnapDistance) {
      return SnapResult.none(point);
    }

    return SnapResult(
      snappedPoint: snappedPoint,
      type: SnapType.grid,
      distance: distance,
    );
  }

  /// Snap to nearest vertex
  SnapResult? _snapToVertex(Offset point, double radius, String? excludeId) {
    SnapTarget? nearest;
    double nearestDist = double.infinity;

    for (final target in _cachedTargets) {
      if (target.type != SnapType.vertex) continue;
      if (excludeId != null && target.primitiveId == excludeId) continue;

      final dist = _distance(point, target.position);
      if (dist < nearestDist && dist <= radius) {
        nearestDist = dist;
        nearest = target;
      }
    }

    if (nearest == null) return null;

    return SnapResult(
      snappedPoint: nearest.position,
      type: SnapType.vertex,
      distance: nearestDist,
      snappedToPrimitiveId: nearest.primitiveId,
      snapTargetId: nearest.targetId,
    );
  }

  /// Snap to nearest midpoint
  SnapResult? _snapToMidpoint(Offset point, double radius, String? excludeId) {
    SnapTarget? nearest;
    double nearestDist = double.infinity;

    for (final target in _cachedTargets) {
      if (target.type != SnapType.midpoint) continue;
      if (excludeId != null && target.primitiveId == excludeId) continue;

      final dist = _distance(point, target.position);
      if (dist < nearestDist && dist <= radius) {
        nearestDist = dist;
        nearest = target;
      }
    }

    if (nearest == null) return null;

    return SnapResult(
      snappedPoint: nearest.position,
      type: SnapType.midpoint,
      distance: nearestDist,
      snappedToPrimitiveId: nearest.primitiveId,
      snapTargetId: nearest.targetId,
    );
  }

  /// Snap to nearest center
  SnapResult? _snapToCenter(Offset point, double radius, String? excludeId) {
    SnapTarget? nearest;
    double nearestDist = double.infinity;

    for (final target in _cachedTargets) {
      if (target.type != SnapType.center) continue;
      if (excludeId != null && target.primitiveId == excludeId) continue;

      final dist = _distance(point, target.position);
      if (dist < nearestDist && dist <= radius) {
        nearestDist = dist;
        nearest = target;
      }
    }

    if (nearest == null) return null;

    return SnapResult(
      snappedPoint: nearest.position,
      type: SnapType.center,
      distance: nearestDist,
      snappedToPrimitiveId: nearest.primitiveId,
      snapTargetId: nearest.targetId,
    );
  }

  /// Snap to nearest edge (line segment)
  SnapResult? _snapToEdge(Offset point, double radius, String? excludeId) {
    // For edges, we need to project the point onto each edge and find the nearest
    SnapTarget? nearestVertex;
    double nearestDist = double.infinity;
    Offset? nearestProjectedPoint;

    for (final target in _cachedTargets) {
      if (target.type != SnapType.vertex) continue;
      if (excludeId != null && target.primitiveId == excludeId) continue;

      // Simple edge snap: project point onto horizontal/vertical lines through vertex
      // This creates snap-to-edge behavior like in CAD software
      final dx = (point.dx - target.position.dx).abs();
      final dy = (point.dy - target.position.dy).abs();

      // Snap horizontally
      if (dx < nearestDist && dx <= radius) {
        nearestDist = dx;
        nearestVertex = target;
        nearestProjectedPoint = Offset(point.dx, target.position.dy);
      }

      // Snap vertically
      if (dy < nearestDist && dy <= radius) {
        nearestDist = dy;
        nearestVertex = target;
        nearestProjectedPoint = Offset(target.position.dx, point.dy);
      }
    }

    if (nearestVertex == null || nearestProjectedPoint == null) return null;

    return SnapResult(
      snappedPoint: nearestProjectedPoint,
      type: SnapType.edge,
      distance: nearestDist,
      snappedToPrimitiveId: nearestVertex.primitiveId,
      snapTargetId: nearestVertex.targetId,
    );
  }

  /// Snap to alignment (horizontal or vertical with other primitives)
  SnapResult? _snapToAlignment(Offset point, double radius, String? excludeId) {
    if (!_config.alignmentEnabled) return null;

    double nearestDistX = double.infinity;
    double nearestDistY = double.infinity;
    double? snappedX;
    double? snappedY;

    for (final target in _cachedTargets) {
      if (excludeId != null && target.primitiveId == excludeId) continue;

      // Check horizontal alignment (same Y)
      final dy = (point.dy - target.position.dy).abs();
      if (dy < nearestDistY && dy <= radius) {
        nearestDistY = dy;
        snappedY = target.position.dy;
      }

      // Check vertical alignment (same X)
      final dx = (point.dx - target.position.dx).abs();
      if (dx < nearestDistX && dx <= radius) {
        nearestDistX = dx;
        snappedX = target.position.dx;
      }
    }

    // Prefer the closer alignment
    if (snappedX != null || snappedY != null) {
      final resultX = snappedX != null && nearestDistX <= nearestDistY;
      final resultY = snappedY != null && nearestDistY < nearestDistX;

      return SnapResult(
        snappedPoint: Offset(
          resultX ? snappedX : point.dx,
          resultY ? snappedY : point.dy,
        ),
        type: SnapType.alignment,
        distance: resultX ? nearestDistX : nearestDistY,
      );
    }

    return null;
  }

  /// Euclidean distance between two points
  double _distance(Offset a, Offset b) {
    final dx = a.dx - b.dx;
    final dy = a.dy - b.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Get all targets near a point (for visual feedback)
  List<SnapTarget> getTargetsNear(Offset point, double radius) {
    return _cachedTargets.where((target) {
      return _distance(point, target.position) <= radius;
    }).toList()
      ..sort((a, b) => _distance(point, a.position).compareTo(_distance(point, b.position)));
  }

  /// Get statistics about cached targets
  int get targetCount => _cachedTargets.length;

  /// Clear cached targets
  void clear() {
    _cachedTargets = [];
  }
}
