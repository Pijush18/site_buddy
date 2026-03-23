import 'dart:ui';
import '../config/diagram_config.dart';
import '../primitives/primitives.dart' show CoordinateMapper;
import 'diagram_space.dart';

/// Default coordinate mapper implementation
/// Handles world-to-canvas and canvas-to-world transformations
/// 
/// This class provides backward compatibility with the existing
/// CoordinateMapper interface while also supporting the new
/// [DiagramSpace] coordinate system.
class DefaultCoordinateMapper implements CoordinateMapper {
  final DiagramConfig config;
  
  /// Optional DiagramSpace for engineering unit support
  /// When provided, coordinates are treated as engineering units (meters)
  final DiagramSpace? space;

  DefaultCoordinateMapper(this.config, {this.space});

  /// Factory constructor with DiagramSpace
  factory DefaultCoordinateMapper.withSpace(DiagramSpace diagramSpace) {
    return DefaultCoordinateMapper(
      DiagramConfig(
        worldWidth: 1000.0,
        worldHeight: 800.0,
        canvasWidth: 800.0,
        canvasHeight: 600.0,
      ),
      space: diagramSpace,
    );
  }

  /// Scale factor: pixels per world unit
  @override
  double get scale {
    // If using DiagramSpace, use its scale directly
    if (space != null) {
      return space!.scale;
    }
    
    // Otherwise, calculate from config
    final scaleX = config.canvasWidth / config.worldWidth;
    final scaleY = config.canvasHeight / config.worldHeight;
    return scaleX < scaleY ? scaleX : scaleY;
  }

  /// World origin in canvas coordinates (top-left corner of world space)
  Offset get _worldOrigin {
    // If using DiagramSpace, use its origin directly
    if (space != null) {
      return space!.origin;
    }
    
    // Otherwise, calculate from config
    final centerX = config.canvasWidth / 2;
    final centerY = config.canvasHeight / 2;

    final worldCenterX = config.worldWidth / 2 + config.panOffset.dx;
    final worldCenterY = config.worldHeight / 2 + config.panOffset.dy;

    return Offset(
      centerX - worldCenterX * scale,
      centerY + worldCenterY * scale, // Flip Y axis
    );
  }

  @override
  Offset worldToCanvas(Offset worldPoint) {
    // If using DiagramSpace, use its transformation
    if (space != null) {
      return space!.toCanvasOffset(worldPoint);
    }
    
    // Otherwise, use legacy transformation
    final origin = _worldOrigin;
    return Offset(
      origin.dx + worldPoint.dx * scale,
      origin.dy - worldPoint.dy * scale, // Y is flipped
    );
  }

  @override
  Offset canvasToWorld(Offset canvasPoint) {
    // If using DiagramSpace, use its transformation
    if (space != null) {
      return space!.toEngineering(canvasPoint);
    }
    
    // Otherwise, use legacy transformation
    final origin = _worldOrigin;
    return Offset(
      (canvasPoint.dx - origin.dx) / scale,
      (origin.dy - canvasPoint.dy) / scale, // Y is flipped
    );
  }

  @override
  Size worldToCanvasSize(Size worldSize) {
    return Size(worldSize.width * scale, worldSize.height * scale);
  }

  /// Create a new mapper with updated config
  DefaultCoordinateMapper withConfig(DiagramConfig newConfig) {
    return DefaultCoordinateMapper(newConfig, space: space);
  }

  /// Create a new mapper with zoom applied
  DefaultCoordinateMapper withZoom(double newZoom) {
    if (space != null) {
      return DefaultCoordinateMapper(
        config.copyWith(zoom: newZoom),
        space: space!.withScale(space!.scale * newZoom),
      );
    }
    return DefaultCoordinateMapper(config.copyWith(zoom: newZoom));
  }

  /// Create a new mapper with pan applied
  DefaultCoordinateMapper withPan(Offset panDelta) {
    if (space != null) {
      return DefaultCoordinateMapper(
        config,
        space: space!.pan(panDelta),
      );
    }
    return DefaultCoordinateMapper(
      config.copyWith(
        panOffset: Offset(
          config.panOffset.dx + panDelta.dx / scale,
          config.panOffset.dy - panDelta.dy / scale, // Y is flipped
        ),
      ),
    );
  }

  /// Create a new mapper with a new DiagramSpace
  DefaultCoordinateMapper withSpace(DiagramSpace newSpace) {
    return DefaultCoordinateMapper(config, space: newSpace);
  }

  /// Get the current DiagramSpace (if any)
  DiagramSpace? get diagramSpace => space;

  /// Convert using engineering units (meters) - requires DiagramSpace
  /// Throws if space is not set
  Offset engineeringToCanvas(double x, double y) {
    if (space == null) {
      throw StateError('DiagramSpace not set - cannot use engineering units');
    }
    return space!.toCanvas(x, y);
  }

  /// Convert to engineering units (meters) - requires DiagramSpace
  Offset canvasToEngineering(Offset canvasPoint) {
    if (space == null) {
      throw StateError('DiagramSpace not set - cannot convert to engineering units');
    }
    return space!.toEngineering(canvasPoint);
  }
}
