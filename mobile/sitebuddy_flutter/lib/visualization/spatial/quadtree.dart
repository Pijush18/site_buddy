/// QuadTree Implementation for Spatial Indexing
/// 
/// Provides O(log n) hit testing for large numbers of primitives
/// by dividing space into quadrants recursively.

import 'dart:math' as math;
import 'dart:ui';

/// An item that can be stored in the quadtree
abstract class QuadTreeItem {
  String get id;
  Rect get bounds;
  bool hitTest(Offset point);
}

/// Node in the quadtree
class QuadTreeNode {
  /// Bounding box of this node
  final Rect bounds;
  
  /// Maximum items before subdivision
  final int maxItems;
  
  /// Maximum depth of the tree
  final int maxDepth;
  
  /// Current depth of this node
  final int depth;
  
  /// Child nodes (NW, NE, SW, SE)
  QuadTreeNode? _nw;
  QuadTreeNode? _ne;
  QuadTreeNode? _sw;
  QuadTreeNode? _se;
  
  /// Items in this node (only leaf nodes store items)
  final List<QuadTreeItem> _items = [];
  
  /// Whether this node is a leaf (has no children)
  bool get isLeaf => _nw == null;
  
  QuadTreeNode({
    required this.bounds,
    this.maxItems = 4,
    this.maxDepth = 8,
    this.depth = 0,
  });
  
  /// Insert an item into this node
  bool insert(QuadTreeItem item) {
    // Ignore items that don't intersect this node
    if (!bounds.overlaps(item.bounds)) {
      return false;
    }
    
    // If we're at a leaf and have room, add the item
    if (isLeaf) {
      _items.add(item);
      
      // Subdivide if we have too many items and haven't reached max depth
      if (_items.length > maxItems && depth < maxDepth) {
        _subdivide();
      }
      return true;
    }
    
    // Otherwise, insert into children
    _insertIntoChildren(item);
    return true;
  }
  
  /// Insert item into child nodes
  void _insertIntoChildren(QuadTreeItem item) {
    // Try each quadrant that intersects the item
    if (_nw != null && _nw!.bounds.overlaps(item.bounds)) {
      _nw!.insert(item);
    }
    if (_ne != null && _ne!.bounds.overlaps(item.bounds)) {
      _ne!.insert(item);
    }
    if (_sw != null && _sw!.bounds.overlaps(item.bounds)) {
      _sw!.insert(item);
    }
    if (_se != null && _se!.bounds.overlaps(item.bounds)) {
      _se!.insert(item);
    }
  }
  
  /// Subdivide this node into 4 quadrants
  void _subdivide() {
    final midX = bounds.left + bounds.width / 2;
    final midY = bounds.top + bounds.height / 2;
    
    _nw = QuadTreeNode(
      bounds: Rect.fromLTRB(bounds.left, bounds.top, midX, midY),
      maxItems: maxItems,
      maxDepth: maxDepth,
      depth: depth + 1,
    );
    
    _ne = QuadTreeNode(
      bounds: Rect.fromLTRB(midX, bounds.top, bounds.right, midY),
      maxItems: maxItems,
      maxDepth: maxDepth,
      depth: depth + 1,
    );
    
    _sw = QuadTreeNode(
      bounds: Rect.fromLTRB(bounds.left, midY, midX, bounds.bottom),
      maxItems: maxItems,
      maxDepth: maxDepth,
      depth: depth + 1,
    );
    
    _se = QuadTreeNode(
      bounds: Rect.fromLTRB(midX, midY, bounds.right, bounds.bottom),
      maxItems: maxItems,
      maxDepth: maxDepth,
      depth: depth + 1,
    );
    
    // Re-insert all items into children
    for (final item in _items) {
      _insertIntoChildren(item);
    }
    _items.clear();
  }
  
  /// Query all items that intersect with a given rect
  List<QuadTreeItem> queryRect(Rect rect) {
    final results = <QuadTreeItem>[];
    
    // If query rect doesn't intersect this node, return empty
    if (!bounds.overlaps(rect)) {
      return results;
    }
    
    // If we're at a leaf, add all intersecting items
    if (isLeaf) {
      for (final item in _items) {
        if (rect.overlaps(item.bounds)) {
          results.add(item);
        }
      }
      return results;
    }
    
    // Otherwise, query children
    results.addAll(_nw!.queryRect(rect));
    results.addAll(_ne!.queryRect(rect));
    results.addAll(_sw!.queryRect(rect));
    results.addAll(_se!.queryRect(rect));
    
    return results;
  }
  
  /// Query all items at a specific point (hit test)
  List<QuadTreeItem> queryPoint(Offset point) {
    final results = <QuadTreeItem>[];
    
    // If point is outside this node, return empty
    if (!bounds.contains(point)) {
      return results;
    }
    
    // If we're at a leaf, check all items
    if (isLeaf) {
      for (final item in _items) {
        if (item.bounds.contains(point) && item.hitTest(point)) {
          results.add(item);
        }
      }
      return results;
    }
    
    // Otherwise, query children
    results.addAll(_nw!.queryPoint(point));
    results.addAll(_ne!.queryPoint(point));
    results.addAll(_sw!.queryPoint(point));
    results.addAll(_se!.queryPoint(point));
    
    return results;
  }
  
  /// Clear all items from this node
  void clear() {
    _items.clear();
    _nw = null;
    _ne = null;
    _sw = null;
    _se = null;
  }
  
  /// Get total number of items in this node and all children
  int get totalItems {
    if (isLeaf) {
      return _items.length;
    }
    return (_nw?.totalItems ?? 0) +
           (_ne?.totalItems ?? 0) +
           (_sw?.totalItems ?? 0) +
           (_se?.totalItems ?? 0);
  }
  
  /// Get maximum depth of this tree
  int get actualDepth {
    if (isLeaf) return depth;
    return math.max(
      math.max(_nw?.actualDepth ?? 0, _ne?.actualDepth ?? 0),
      math.max(_sw?.actualDepth ?? 0, _se?.actualDepth ?? 0),
    );
  }
}

/// QuadTree for spatial indexing of primitives
class QuadTree {
  final QuadTreeNode _root;
  
  /// Create a quadtree with the given world bounds
  QuadTree({
    required Rect worldBounds,
    int maxItems = 4,
    int maxDepth = 8,
  }) : _root = QuadTreeNode(
    bounds: worldBounds,
    maxItems: maxItems,
    maxDepth: maxDepth,
  );
  
  /// Insert an item into the quadtree
  bool insert(QuadTreeItem item) {
    return _root.insert(item);
  }
  
  /// Remove an item from the quadtree (O(n) - should rebuild if frequent removals)
  bool remove(String itemId) {
    // For simplicity, we rebuild the tree
    // A more efficient implementation would track items
    return false;
  }
  
  /// Query items that intersect with a rect
  List<QuadTreeItem> queryRect(Rect rect) {
    return _root.queryRect(rect);
  }
  
  /// Hit test at a point
  List<QuadTreeItem> queryPoint(Offset point) {
    return _root.queryPoint(point);
  }
  
  /// Clear the quadtree
  void clear() {
    _root.clear();
  }
  
  /// Rebuild the quadtree with new items
  void rebuild(List<QuadTreeItem> items) {
    clear();
    for (final item in items) {
      insert(item);
    }
  }
  
  /// Statistics for debugging
  QuadTreeStats get stats => QuadTreeStats(
    totalItems: _root.totalItems,
    maxDepth: _root.actualDepth,
  );
}

/// Statistics about the quadtree
class QuadTreeStats {
  final int totalItems;
  final int maxDepth;
  
  const QuadTreeStats({
    required this.totalItems,
    required this.maxDepth,
  });
}
