import 'package:flutter/painting.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart';

/// Spatial index wrapper for fast hit testing using QuadTree
/// 
/// Usage:
/// ```dart
/// final index = SpatialIndex();
/// index.build(primitives);
/// 
/// // Fast O(log n) hit test
/// final hit = index.hitTest(point);
/// 
/// // Query primitives in a region
/// final inRegion = index.queryRegion(Rect.fromLTWH(0, 0, 100, 100));
/// ```
class SpatialIndex {
  QuadTree? _tree;
  Rect? _worldBounds;
  List<DiagramPrimitive>? _primitives;
  bool _needsRebuild = false;

  /// Build the spatial index from a list of primitives
  void build(List<DiagramPrimitive> primitives, {Rect? worldBounds}) {
    if (primitives.isEmpty) {
      _tree = null;
      _worldBounds = null;
      _primitives = null;
      return;
    }

    _primitives = primitives;

    // Calculate world bounds from primitives if not provided
    if (worldBounds != null) {
      _worldBounds = worldBounds;
    } else {
      _worldBounds = _calculateBounds(primitives);
    }

    // Expand bounds slightly to account for primitives near edges
    _worldBounds = _worldBounds!.inflate(100);

    _tree = QuadTree(bounds: _worldBounds!, maxObjects: 10, maxDepth: 8);

    for (final primitive in primitives) {
      if (primitive.visible) {
        _tree!.insert(primitive);
      }
    }

    _needsRebuild = false;
  }

  /// Update a single primitive in the index
  void update(DiagramPrimitive primitive) {
    // For simplicity, mark for rebuild
    // In production, could implement in-place updates
    _needsRebuild = true;
  }

  /// Remove a primitive from the index
  void remove(String id) {
    // For simplicity, mark for rebuild
    // In production, could implement in-place removal
    _needsRebuild = true;
  }

  /// Ensure index is up to date
  void ensureBuilt() {
    if (_needsRebuild && _primitives != null) {
      build(_primitives!, worldBounds: _worldBounds);
    }
  }

  /// Hit test at a point - returns all primitives that contain the point
  /// Uses QuadTree for O(log n) performance
  List<DiagramPrimitive> hitTest(Offset point) {
    ensureBuilt();

    if (_tree == null) return [];

    // First, get candidates from QuadTree
    final candidates = _tree!.queryPoint(point);

    // Then do precise hit testing
    final hits = <DiagramPrimitive>[];
    for (final candidate in candidates) {
      if (candidate.hitTest(point)) {
        hits.add(candidate);
      }
    }

    // Sort by zIndex (higher = on top)
    hits.sort((a, b) => b.zIndex.compareTo(a.zIndex));

    return hits;
  }

  /// Find the topmost primitive at a point
  DiagramPrimitive? findTopmost(Offset point) {
    final hits = hitTest(point);
    return hits.isNotEmpty ? hits.first : null;
  }

  /// Query all primitives that intersect with a region
  List<DiagramPrimitive> queryRegion(Rect region) {
    ensureBuilt();

    if (_tree == null) return [];

    final candidates = _tree!.queryRect(region);

    // Filter by precise intersection
    final results = <DiagramPrimitive>[];
    for (final candidate in candidates) {
      if (candidate.bounds.overlaps(region)) {
        results.add(candidate);
      }
    }

    return results;
  }

  /// Get statistics about the spatial index
  SpatialIndexStats getStats() {
    ensureBuilt();

    if (_tree == null) {
      return const SpatialIndexStats(
        primitiveCount: 0,
        treeDepth: 0,
        nodeCount: 0,
        averageObjectsPerNode: 0,
      );
    }

    final stats = _tree!.getStats();
    return SpatialIndexStats(
      primitiveCount: _primitives?.length ?? 0,
      treeDepth: stats.depth,
      nodeCount: stats.nodeCount,
      averageObjectsPerNode: stats.averageObjects,
    );
  }

  /// Clear the spatial index
  void clear() {
    _tree = null;
    _worldBounds = null;
    _primitives = null;
    _needsRebuild = false;
  }

  Rect _calculateBounds(List<DiagramPrimitive> primitives) {
    if (primitives.isEmpty) {
      return Rect.zero;
    }

    Rect result = primitives.first.bounds;
    for (final primitive in primitives.skip(1)) {
      result = result.expandToInclude(primitive.bounds);
    }

    return result;
  }
}

/// Statistics about the spatial index
class SpatialIndexStats {
  final int primitiveCount;
  final int treeDepth;
  final int nodeCount;
  final double averageObjectsPerNode;

  const SpatialIndexStats({
    required this.primitiveCount,
    required this.treeDepth,
    required this.nodeCount,
    required this.averageObjectsPerNode,
  });

  @override
  String toString() {
    return 'SpatialIndexStats(primitives: $primitiveCount, depth: $treeDepth, nodes: $nodeCount, avg/node: ${averageObjectsPerNode.toStringAsFixed(2)})';
  }
}

/// Simplified QuadTree for spatial indexing
class QuadTree {
  final Rect bounds;
  final int maxObjects;
  final int maxDepth;
  final int depth;

  final List<DiagramPrimitive> _objects = [];
  final List<QuadTree> _children = [];
  bool _divided = false;

  QuadTree({
    required this.bounds,
    this.maxObjects = 10,
    this.maxDepth = 8,
    this.depth = 0,
  });

  /// Insert a primitive into the QuadTree
  void insert(DiagramPrimitive primitive) {
    // If we have children, insert into appropriate child
    if (_divided) {
      _insertIntoChildren(primitive);
      return;
    }

    // Add to this node
    _objects.add(primitive);

    // Check if we need to subdivide
    if (_objects.length > maxObjects && depth < maxDepth) {
      _subdivide();
    }
  }

  void _insertIntoChildren(DiagramPrimitive primitive) {
    for (final child in _children) {
      if (child.bounds.contains(primitive.bounds.topLeft) ||
          child.bounds.contains(primitive.bounds.bottomRight)) {
        child.insert(primitive);
        return;
      }
    }
    // If doesn't fit in any child, keep in parent
    _objects.add(primitive);
  }

  void _subdivide() {
    final x = bounds.left;
    final y = bounds.top;
    final w = bounds.width / 2;
    final h = bounds.height / 2;

    _children.addAll([
      QuadTree(
        bounds: Rect.fromLTWH(x, y, w, h),
        maxObjects: maxObjects,
        maxDepth: maxDepth,
        depth: depth + 1,
      ),
      QuadTree(
        bounds: Rect.fromLTWH(x + w, y, w, h),
        maxObjects: maxObjects,
        maxDepth: maxDepth,
        depth: depth + 1,
      ),
      QuadTree(
        bounds: Rect.fromLTWH(x, y + h, w, h),
        maxObjects: maxObjects,
        maxDepth: maxDepth,
        depth: depth + 1,
      ),
      QuadTree(
        bounds: Rect.fromLTWH(x + w, y + h, w, h),
        maxObjects: maxObjects,
        maxDepth: maxDepth,
        depth: depth + 1,
      ),
    ]);

    _divided = true;

    // Re-insert existing objects into children
    for (final obj in _objects) {
      _insertIntoChildren(obj);
    }
    _objects.clear();
  }

  /// Query all objects that might intersect with a point
  List<DiagramPrimitive> queryPoint(Offset point) {
    final result = <DiagramPrimitive>[];

    // Add objects from this node
    result.addAll(_objects);

    // Query children if divided
    if (_divided) {
      for (final child in _children) {
        if (child.bounds.contains(point)) {
          result.addAll(child.queryPoint(point));
        }
      }
    }

    return result;
  }

  /// Query all objects that might intersect with a rectangle
  List<DiagramPrimitive> queryRect(Rect region) {
    final result = <DiagramPrimitive>[];

    // Check if region intersects this node
    if (!bounds.overlaps(region)) {
      return result;
    }

    // Add objects from this node
    result.addAll(_objects);

    // Query children if divided
    if (_divided) {
      for (final child in _children) {
        result.addAll(child.queryRect(region));
      }
    }

    return result;
  }

  /// Get statistics about this QuadTree
  QuadTreeStats getStats() {
    int totalNodes = 1;
    int maxDepthSeen = depth;

    if (_divided) {
      for (final child in _children) {
        final childStats = child.getStats();
        totalNodes += childStats.nodeCount;
        if (childStats.depth > maxDepthSeen) {
          maxDepthSeen = childStats.depth;
        }
      }
    }

    final avgObjects = _objects.length + (_divided ? 0 : _calculateLeafObjectCount());

    return QuadTreeStats(
      nodeCount: totalNodes,
      depth: maxDepthSeen - depth,
      averageObjects: avgObjects.toDouble(),
    );
  }

  int _calculateLeafObjectCount() {
    if (!_divided) return _objects.length;
    int count = 0;
    for (final child in _children) {
      count += child._calculateLeafObjectCount();
    }
    return count;
  }
}

/// Statistics about a QuadTree
class QuadTreeStats {
  final int nodeCount;
  final int depth;
  final double averageObjects;

  const QuadTreeStats({
    required this.nodeCount,
    required this.depth,
    required this.averageObjects,
  });
}
