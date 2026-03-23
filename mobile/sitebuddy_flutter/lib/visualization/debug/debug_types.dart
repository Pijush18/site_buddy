import 'dart:ui';
import '../primitives/primitives.dart';

/// Debug overlay types
enum DebugOverlay {
  boundingBox,
  wireframe,
  normals,
  grid,
  axes,
  hitRegions,
  layerBounds,
}

/// Debug log entry
class DebugLogEntry {
  final DateTime timestamp;
  final String message;
  final String? category;

  const DebugLogEntry({
    required this.timestamp,
    required this.message,
    this.category,
  });
}

/// Debug inspector interface
abstract class DebugInspector {
  /// Get primitive at canvas position
  DiagramPrimitive? getPrimitiveAt(Offset canvasPosition);

  /// Get all primitives within region
  List<DiagramPrimitive> getPrimitivesIn(Rect region);

  /// Get primitive bounding box
  Rect getBoundingBox(String primitiveId);

  /// Get primitive hierarchy (for groups)
  List<DiagramPrimitive> getHierarchy(String primitiveId);

  /// Highlight primitive
  void highlight(String primitiveId, Color color);

  /// Clear highlights
  void clearHighlights();
}

/// Debug overlay renderer
abstract class DebugOverlayRenderer {
  /// Render debug overlay
  void renderOverlay(Canvas canvas, CoordinateMapper mapper, DebugOverlay type);

  /// Set debug options
  void setOptions(Map<String, dynamic> options);

  /// Enable/disable specific overlay
  void setOverlayEnabled(DebugOverlay type, bool enabled);
}

/// Debug logger interface
abstract class DebugLogger {
  /// Log message
  void log(String message, {String? category});

  /// Log error
  void error(String message, Object error, [StackTrace? stackTrace]);

  /// Log warning
  void warn(String message);

  /// Get log entries
  List<DebugLogEntry> getEntries({String? category, int? limit});

  /// Clear log
  void clear();
}
