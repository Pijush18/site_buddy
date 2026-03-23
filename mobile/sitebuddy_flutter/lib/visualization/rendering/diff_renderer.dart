// Copyright (c) 2024, Piotr Stelmaszczyk. All rights reserved.

import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import '../primitives/primitives.dart';

/// Cache entry for a rendered primitive picture
class CachedPrimitive {
  final String id;
  final int version;
  final ui.Picture picture;
  final Rect bounds;

  const CachedPrimitive({
    required this.id,
    required this.version,
    required this.picture,
    required this.bounds,
  });
}

/// Result of diff analysis
class DiffResult {
  /// Primitives that were added (need full rendering)
  final List<DiagramPrimitive> added;
  
  /// IDs of primitives that were removed
  final List<String> removed;
  
  /// Primitives that need re-rendering due to version change
  final List<DiagramPrimitive> modified;
  
  /// Primitives that can use cached rendering
  final List<DiagramPrimitive> unchanged;

  const DiffResult({
    required this.added,
    required this.removed,
    required this.modified,
    required this.unchanged,
  });

  bool get needsFullRepaint => added.isNotEmpty || removed.isNotEmpty;
  bool get needsPartialRepaint => modified.isNotEmpty;
  bool get isDirty => needsFullRepaint || needsPartialRepaint;

  int get totalRendersNeeded => added.length + removed.length + modified.length;
}

/// Diff renderer for optimized primitive rendering
/// 
/// Uses version tracking to avoid unnecessary re-rendering of primitives
/// that haven't changed since the last frame.
class DiffRenderer {
  /// Current cache of rendered primitives
  final Map<String, CachedPrimitive> _cache = {};
  
  /// Version map for quick lookups
  final Map<String, int> _versionMap = {};
  
  /// Paint object reused across render calls
  final Paint _paint = Paint();
  
  /// Whether to use cached rendering
  bool cacheEnabled = true;

  /// Get cache statistics
  CacheStats get stats => CacheStats(
    cacheSize: _cache.length,
    totalVersions: _versionMap.length,
  );

  /// Analyze primitives against current cache to determine what needs re-rendering
  DiffResult diff(List<DiagramPrimitive> primitives) {
    final added = <DiagramPrimitive>[];
    final removed = <String>[];
    final modified = <DiagramPrimitive>[];
    final unchanged = <DiagramPrimitive>[];

    // Find added and modified primitives
    for (final primitive in primitives) {
      final cached = _cache[primitive.id];
      
      if (cached == null) {
        // New primitive - needs rendering
        added.add(primitive);
      } else if (primitive.version > cached.version) {
        // Version increased - needs re-rendering
        modified.add(primitive);
      } else {
        // Unchanged - can use cached picture
        unchanged.add(primitive);
      }
    }

    // Find removed primitives
    final currentIds = primitives.map((p) => p.id).toSet();
    for (final cachedId in _cache.keys) {
      if (!currentIds.contains(cachedId)) {
        removed.add(cachedId);
      }
    }

    return DiffResult(
      added: added,
      removed: removed,
      modified: modified,
      unchanged: unchanged,
    );
  }

  /// Render primitives with diff-based optimization
  /// 
  /// Returns a [ui.Picture] containing all rendered primitives.
  /// Only primitives that have changed (added, modified) are re-rendered.
  ui.Picture? render(
    List<DiagramPrimitive> primitives,
    CoordinateMapper mapper, {
    Rect? viewport,
  }) {
    if (!cacheEnabled) {
      // Full re-render mode
      return _renderAll(primitives, mapper, viewport);
    }

    final diff = this.diff(primitives);
    
    if (!diff.isDirty) {
      // Nothing changed - return composite of all cached pictures
      return _renderFromCache(primitives);
    }

    // Update cache with changed primitives
    _invalidateRemoved(diff.removed);
    
    // Render added and modified primitives
    for (final primitive in [...diff.added, ...diff.modified]) {
      final picture = _renderPrimitive(primitive, mapper);
      if (picture != null) {
        _cache[primitive.id] = CachedPrimitive(
          id: primitive.id,
          version: primitive.version,
          picture: picture,
          bounds: primitive.bounds,
        );
        _versionMap[primitive.id] = primitive.version;
      }
    }

    // Return composite picture
    return _renderFromCache(primitives);
  }

  /// Render a single primitive to a picture
  ui.Picture? _renderPrimitive(DiagramPrimitive primitive, CoordinateMapper mapper) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    try {
      primitive.render(canvas, _paint, mapper);
      return recorder.endRecording();
    } catch (e) {
      debugPrint('Error rendering primitive ${primitive.id}: $e');
      return null;
    }
  }

  /// Full re-render of all primitives
  ui.Picture? _renderAll(
    List<DiagramPrimitive> primitives,
    CoordinateMapper mapper,
    Rect? viewport,
  ) {
    if (primitives.isEmpty) return null;

    // Calculate bounds
    Rect? bounds;
    for (final p in primitives) {
      bounds = bounds?.expandToInclude(p.bounds) ?? p.bounds;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Offset to origin
    if (bounds != null) {
      canvas.translate(-bounds.left, -bounds.top);
    }

    try {
      for (final primitive in primitives) {
        if (viewport == null || primitive.bounds.overlaps(viewport)) {
          primitive.render(canvas, _paint, mapper);
        }
      }
      
      final picture = recorder.endRecording();
      
      // Update cache
      _cache.clear();
      _versionMap.clear();
      for (final primitive in primitives) {
        final primitivePicture = _renderPrimitive(primitive, mapper);
        if (primitivePicture != null) {
          _cache[primitive.id] = CachedPrimitive(
            id: primitive.id,
            version: primitive.version,
            picture: primitivePicture,
            bounds: primitive.bounds,
          );
          _versionMap[primitive.id] = primitive.version;
        }
      }
      
      return picture;
    } catch (e) {
      debugPrint('Error in full render: $e');
      return null;
    }
  }

  /// Composite all cached pictures into a single picture
  ui.Picture? _renderFromCache(List<DiagramPrimitive> primitives) {
    if (_cache.isEmpty) return null;

    // Calculate combined bounds
    Rect? bounds;
    for (final primitive in primitives) {
      final cached = _cache[primitive.id];
      if (cached != null) {
        bounds = bounds?.expandToInclude(cached.bounds) ?? cached.bounds;
      }
    }

    if (bounds == null || bounds.isEmpty) return null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Offset to origin
    canvas.translate(-bounds.left, -bounds.top);

    try {
      // Draw all cached primitives in order
      for (final primitive in primitives) {
        final cached = _cache[primitive.id];
        if (cached != null) {
          canvas.save();
          canvas.translate(cached.bounds.left - bounds.left, cached.bounds.top - bounds.top);
          canvas.drawPicture(cached.picture);
          canvas.restore();
        }
      }
      
      return recorder.endRecording();
    } catch (e) {
      debugPrint('Error composing cached pictures: $e');
      return null;
    }
  }

  /// Invalidate removed primitives from cache
  void _invalidateRemoved(List<String> removed) {
    for (final id in removed) {
      _cache.remove(id);
      _versionMap.remove(id);
    }
  }

  /// Invalidate a specific primitive by ID
  void invalidate(String id) {
    _cache.remove(id);
    _versionMap.remove(id);
  }

  /// Invalidate all primitives matching a predicate
  void invalidateWhere(bool Function(DiagramPrimitive) predicate, List<DiagramPrimitive> primitives) {
    for (final primitive in primitives) {
      if (predicate(primitive)) {
        _cache.remove(primitive.id);
        _versionMap.remove(primitive.id);
      }
    }
  }

  /// Clear the entire cache
  void clear() {
    _cache.clear();
    _versionMap.clear();
  }

  /// Check if a primitive is in cache and up-to-date
  bool isCacheValid(String id, int version) {
    final cached = _cache[id];
    return cached != null && cached.version == version;
  }

  /// Dispose resources
  void dispose() {
    clear();
  }
}

/// Cache statistics for debugging
class CacheStats {
  final int cacheSize;
  final int totalVersions;

  const CacheStats({
    required this.cacheSize,
    required this.totalVersions,
  });

  @override
  String toString() => 'CacheStats(cache: $cacheSize, versions: $totalVersions)';
}
