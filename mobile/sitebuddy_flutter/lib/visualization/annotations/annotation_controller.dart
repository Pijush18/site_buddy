import 'package:flutter/material.dart';
import 'annotation_model.dart';
import '../primitives/primitives.dart';
import '../spatial/spatial_index.dart';

/// Manages the state and operations for diagram annotations
class AnnotationController extends ChangeNotifier {
  final Map<String, Annotation> _annotations = {};
  String? _selectedId;
  AnnotationType? _activeTool;
  
  // Undo/redo stacks
  final List<_AnnotationChange> _undoStack = [];
  final List<_AnnotationChange> _redoStack = [];
  
  // Style presets
  AnnotationStyle _currentStyle = const AnnotationStyle();

  // Spatial index for O(log n) hit testing
  final SpatialIndex _spatialIndex = SpatialIndex();

  /// Get all annotations sorted by zIndex
  List<Annotation> get annotations {
    final list = _annotations.values.toList();
    list.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    return list;
  }

  /// Get all annotations as DiagramPrimitives for rendering through renderDiagram()
  /// This ensures annotations use the same rendering pipeline as all other primitives
  List<DiagramPrimitive> get primitives {
    return annotations
        .where((a) => a.isVisible)
        .map((a) => a.toPrimitive())
        .toList();
  }

  /// Get annotation by ID
  Annotation? getAnnotation(String id) => _annotations[id];

  /// Currently selected annotation ID
  String? get selectedId => _selectedId;

  /// Currently selected annotation
  Annotation? get selectedAnnotation => _selectedId != null ? _annotations[_selectedId] : null;

  /// Active annotation tool (for creation)
  AnnotationType? get activeTool => _activeTool;

  /// Current style for new annotations
  AnnotationStyle get currentStyle => _currentStyle;

  /// Check if undo is available
  bool get canUndo => _undoStack.isNotEmpty;

  /// Check if redo is available
  bool get canRedo => _redoStack.isNotEmpty;

  /// Get spatial index statistics for debugging
  SpatialIndexStats get spatialStats => _spatialIndex.getStats();

  /// Set the active tool for annotation creation
  void setActiveTool(AnnotationType? tool) {
    _activeTool = tool;
    if (tool != null) {
      _selectedId = null;
    }
    notifyListeners();
  }

  /// Set the current style for new annotations
  void setCurrentStyle(AnnotationStyle style) {
    _currentStyle = style;
    notifyListeners();
  }

  /// Add a new annotation
  void addAnnotation(Annotation annotation) {
    _saveChange(_AnnotationChange.added(annotation));
    _annotations[annotation.id] = annotation;
    _rebuildSpatialIndex();
    notifyListeners();
  }

  /// Add annotation at specific index (for undo operations)
  void addAnnotationAt(Annotation annotation, int index) {
    _annotations[annotation.id] = annotation;
    notifyListeners();
  }

  /// Remove an annotation by ID
  void removeAnnotation(String id) {
    final annotation = _annotations[id];
    if (annotation != null) {
      _saveChange(_AnnotationChange.removed(annotation));
      if (_selectedId == id) {
        _selectedId = null;
      }
      _annotations.remove(id);
      notifyListeners();
    }
  }

  /// Update an existing annotation
  void updateAnnotation(Annotation annotation) {
    final old = _annotations[annotation.id];
    if (old != null) {
      _saveChange(_AnnotationChange.updated(old, annotation));
      _annotations[annotation.id] = annotation;
      notifyListeners();
    }
  }

  /// Move an annotation to a new position
  void moveAnnotation(String id, Offset delta) {
    final annotation = _annotations[id];
    if (annotation == null || annotation.isLocked) return;

    Annotation updated;
    if (annotation is TextAnnotation) {
      updated = annotation.copyWith(position: annotation.position + delta);
    } else if (annotation is MarkerAnnotation) {
      updated = annotation.copyWith(position: annotation.position + delta);
    } else if (annotation is HighlightAnnotation) {
      updated = annotation.copyWith(position: annotation.position + delta);
    } else if (annotation is DimensionAnnotation) {
      updated = annotation.copyWith(
        position: annotation.position + delta,
        endPosition: annotation.endPosition + delta,
      );
    } else if (annotation is CalloutAnnotation) {
      updated = annotation.copyWith(
        position: annotation.position + delta,
        targetPosition: annotation.targetPosition + delta,
      );
    } else {
      return;
    }

    _annotations[id] = updated;
    notifyListeners();
  }

  /// Select an annotation
  void selectAnnotation(String? id) {
    if (_selectedId != id) {
      _selectedId = id;
      notifyListeners();
    }
  }

  /// Clear selection
  void clearSelection() {
    if (_selectedId != null) {
      _selectedId = null;
      notifyListeners();
    }
  }

  /// Toggle annotation visibility
  void toggleVisibility(String id) {
    final annotation = _annotations[id];
    if (annotation != null) {
      updateAnnotation(annotation.copyWith(isVisible: !annotation.isVisible) as Annotation);
    }
  }

  /// Toggle annotation lock
  void toggleLock(String id) {
    final annotation = _annotations[id];
    if (annotation != null) {
      updateAnnotation(annotation.copyWith(isLocked: !annotation.isLocked) as Annotation);
    }
  }

  /// Bring annotation to front
  void bringToFront(String id) {
    final annotation = _annotations[id];
    if (annotation != null) {
      final maxZ = _annotations.values.fold<int>(0, (max, a) => a.zIndex > max ? a.zIndex : max);
      updateAnnotation(annotation.copyWith(zIndex: maxZ + 1) as Annotation);
    }
  }

  /// Send annotation to back
  void sendToBack(String id) {
    final annotation = _annotations[id];
    if (annotation != null) {
      final minZ = _annotations.values.fold<int>(0, (min, a) => a.zIndex < min ? a.zIndex : min);
      updateAnnotation(annotation.copyWith(zIndex: minZ - 1) as Annotation);
    }
  }

  /// Undo last change
  void undo() {
    if (_undoStack.isEmpty) return;

    final change = _undoStack.removeLast();
    _redoStack.add(change);

    switch (change.type) {
      case _ChangeType.added:
        _annotations.remove(change.annotation.id);
        break;
      case _ChangeType.removed:
        _annotations[change.annotation.id] = change.annotation;
        break;
      case _ChangeType.updated:
        _annotations[change.oldAnnotation!.id] = change.oldAnnotation!;
        break;
    }

    notifyListeners();
  }

  /// Redo last undone change
  void redo() {
    if (_redoStack.isEmpty) return;

    final change = _redoStack.removeLast();
    _undoStack.add(change);

    switch (change.type) {
      case _ChangeType.added:
        _annotations[change.annotation.id] = change.annotation;
        break;
      case _ChangeType.removed:
        _annotations.remove(change.annotation.id);
        break;
      case _ChangeType.updated:
        _annotations[change.annotation.id] = change.annotation;
        break;
    }

    notifyListeners();
  }

  void _saveChange(_AnnotationChange change) {
    _undoStack.add(change);
    _redoStack.clear();
    // Limit undo stack size
    while (_undoStack.length > 50) {
      _undoStack.removeAt(0);
    }
  }

  /// Serialize all annotations to JSON
  List<Map<String, dynamic>> toJson() {
    return annotations.map((a) => a.toJson()).toList();
  }

  /// Load annotations from JSON
  void loadFromJson(List<dynamic> json) {
    _annotations.clear();
    for (final item in json) {
      final annotation = annotationFromJson(item);
      _annotations[annotation.id] = annotation;
    }
    _undoStack.clear();
    _redoStack.clear();
    _selectedId = null;
    notifyListeners();
  }

  /// Clear all annotations
  void clear() {
    _annotations.clear();
    _undoStack.clear();
    _redoStack.clear();
    _selectedId = null;
    _activeTool = null;
    notifyListeners();
  }

  /// Generate a unique annotation ID
  String generateId() {
    return 'ann_${DateTime.now().millisecondsSinceEpoch}_${_annotations.length}';
  }

  /// Rebuild the spatial index for fast hit testing
  void _rebuildSpatialIndex() {
    _spatialIndex.build(primitives);
  }

  /// Find annotation at a given position using spatial index (world coordinates)
  /// Uses O(log n) QuadTree lookup instead of O(n) linear search
  String? findAnnotationAt(Offset position) {
    // Ensure spatial index is built
    _rebuildSpatialIndex();

    // Use spatial index for fast lookup
    final hits = _spatialIndex.hitTest(position);
    
    if (hits.isEmpty) return null;

    // Return the topmost (highest zIndex) annotation
    final topmost = hits.first;
    
    // Find the annotation ID that corresponds to this primitive
    for (final entry in _annotations.entries) {
      if (entry.value.toPrimitive() == topmost) {
        return entry.key;
      }
    }

    // Fallback: search all annotations
    return findAnnotationAtFallback(position);
  }

  /// Fallback linear search - used when spatial index fails
  String? findAnnotationAtFallback(Offset position) {
    final sorted = annotations.reversed.toList();
    for (final annotation in sorted) {
      if (annotation.isVisible && annotation.containsPoint(position)) {
        return annotation.id;
      }
    }
    return null;
  }
}

enum _ChangeType { added, removed, updated }

class _AnnotationChange {
  final _ChangeType type;
  final Annotation annotation;
  final Annotation? oldAnnotation;

  _AnnotationChange._(this.type, this.annotation, [this.oldAnnotation]);

  factory _AnnotationChange.added(Annotation annotation) =>
      _AnnotationChange._(_ChangeType.added, annotation);

  factory _AnnotationChange.removed(Annotation annotation) =>
      _AnnotationChange._(_ChangeType.removed, annotation);

  factory _AnnotationChange.updated(Annotation oldAnnotation, Annotation newAnnotation) =>
      _AnnotationChange._(_ChangeType.updated, newAnnotation, oldAnnotation);
}
