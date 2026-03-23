import 'dart:ui';
import 'package:flutter/painting.dart';
import '../core/viewport_controller.dart';

/// DiagramSpace - Engineering coordinate system abstraction layer
/// 
/// Provides coordinate transformation between engineering units (meters) 
/// and canvas pixels with proper Y-axis inversion for engineering drawings.
/// 
/// Engineering coordinate system:
/// - X: increases to the right
/// - Y: increases upward (opposite of screen coordinates)
/// - Units: meters (world units)
/// 
/// Canvas coordinate system:
/// - X: increases to the right
/// - Y: increases downward
/// - Units: pixels
/// 
/// Usage:
/// ```dart
/// final space = DiagramSpace(scale: 50.0, origin: Offset(100, 400));
/// 
/// // Convert engineering coordinates to canvas position
/// final canvasPos = space.toCanvas(5.0, 2.0); // 5m right, 2m up
/// 
/// // Convert canvas position to engineering coordinates
/// final engPos = space.toEngineering(canvasPos);
/// ```
class DiagramSpace {
  /// Scale factor: pixels per engineering unit (e.g., 50px = 1m)
  final double baseScale;

  /// Origin point on canvas where (0, 0) in engineering space maps to
  final Offset origin;

  /// Optional viewport for zoom/pan transformations
  final DiagramViewport? viewport;

  /// Default constructor
  /// 
  /// [baseScale] - pixels per engineering unit (default: 50.0)
  /// [origin] - canvas position of engineering origin (default: Offset.zero)
  /// [viewport] - optional viewport for interactive zoom/pan
  const DiagramSpace({
    required this.baseScale,
    required this.origin,
    this.viewport,
  });

  /// Factory for creating a DiagramSpace with common presets
  factory DiagramSpace.presets({
    required DiagramSpacePreset preset,
    required Size canvasSize,
    Offset? origin,
    DiagramViewport? viewport,
  }) {
    double scale;
    Offset effectiveOrigin;
    
    switch (preset) {
      case DiagramSpacePreset.engineering:
        // Engineering drawing: 1m = 50px, origin at bottom-left
        scale = 50.0;
        effectiveOrigin = origin ?? Offset(canvasSize.width * 0.1, canvasSize.height * 0.9);
      case DiagramSpacePreset.architectural:
        // Architectural: 1m = 20px, origin at bottom-left
        scale = 20.0;
        effectiveOrigin = origin ?? Offset(canvasSize.width * 0.1, canvasSize.height * 0.9);
      case DiagramSpacePreset.detail:
        // Detail drawing: 1m = 100px, origin at center
        scale = 100.0;
        effectiveOrigin = origin ?? Offset(canvasSize.width / 2, canvasSize.height / 2);
      case DiagramSpacePreset.schematic:
        // Schematic: 1m = 10px, origin at center
        scale = 10.0;
        effectiveOrigin = origin ?? Offset(canvasSize.width / 2, canvasSize.height / 2);
    }
    
    return DiagramSpace(
      baseScale: scale,
      origin: effectiveOrigin,
      viewport: viewport,
    );
  }

  /// Current effective scale (baseScale * viewport.scale)
  double get scale => viewport != null 
      ? baseScale * viewport!.effectiveScale 
      : baseScale;

  /// Current effective origin (origin + viewport.panOffset)
  Offset get effectiveOrigin => viewport != null 
      ? origin + viewport!.effectiveOffset 
      : origin;

  /// Convert engineering coordinates to canvas (screen) coordinates
  /// 
  /// Engineering Y is inverted because in engineering drawings:
  /// - Y increases upward (elevation)
  /// - Canvas Y increases downward (screen coordinates)
  /// 
  /// If viewport is set, applies zoom and pan transformations.
  Offset toCanvas(double x, double y) {
    final effectiveOffset = effectiveOrigin;
    return Offset(
      effectiveOffset.dx + x * scale,
      effectiveOffset.dy - y * scale, // Y-axis inversion for engineering coords
    );
  }

  /// Convert engineering Offset to canvas Offset
  Offset toCanvasOffset(Offset engineeringOffset) {
    return toCanvas(engineeringOffset.dx, engineeringOffset.dy);
  }

  /// Convert canvas (screen) coordinates to engineering coordinates
  /// 
  /// If viewport is set, applies inverse zoom and pan transformations.
  Offset toEngineering(Offset canvasPoint) {
    final effectiveOffset = effectiveOrigin;
    return Offset(
      (canvasPoint.dx - effectiveOffset.dx) / scale,
      (effectiveOffset.dy - canvasPoint.dy) / scale, // Y-axis inversion
    );
  }

  /// Convert canvas coordinates to engineering with viewport transform
  Offset canvasToEngineeringWithViewport(Offset canvasPoint) {
    if (viewport == null) return toEngineering(canvasPoint);
    
    // First apply inverse viewport transform
    final untransformed = Offset(
      (canvasPoint.dx - viewport!.panOffset.dx) / viewport!.scale,
      (canvasPoint.dy - viewport!.panOffset.dy) / viewport!.scale,
    );
    
    // Then convert to engineering
    return Offset(
      (untransformed.dx - origin.dx) / baseScale,
      (origin.dy - untransformed.dy) / baseScale,
    );
  }

  /// Convert engineering coordinates to canvas with viewport transform
  Offset engineeringToCanvasWithViewport(double x, double y) {
    if (viewport == null) return toCanvas(x, y);
    
    // First convert engineering to base canvas
    final baseCanvas = Offset(
      origin.dx + x * baseScale,
      origin.dy - y * baseScale,
    );
    
    // Then apply viewport transform
    return Offset(
      baseCanvas.dx * viewport!.scale + viewport!.panOffset.dx,
      baseCanvas.dy * viewport!.scale + viewport!.panOffset.dy,
    );
  }

  /// Convert engineering size to canvas size
  Size toCanvasSize(Size engineeringSize) {
    return Size(engineeringSize.width * scale, engineeringSize.height * scale);
  }

  /// Convert a single engineering unit (1 meter) to canvas pixels
  double get pixelsPerUnit => scale;

  /// Convert canvas pixels to engineering units
  double toEngineeringUnits(double pixels) {
    return pixels / scale;
  }

  /// Get scaled stroke width that maintains visual consistency
  double scaledStrokeWidth(double baseStrokeWidth) {
    // Stroke width should scale with viewport if set
    final effectiveScale = viewport?.effectiveScale ?? 1.0;
    return baseStrokeWidth * baseScale * effectiveScale;
  }

  /// Get scaled font size that maintains visual consistency
  double scaledFontSize(double baseFontSize) {
    // Font size should NOT scale with viewport (readability)
    return baseFontSize * baseScale;
  }

  /// Create a copy with updated scale (zooming)
  DiagramSpace withScale(double newScale) {
    return DiagramSpace(
      baseScale: newScale,
      origin: origin,
      viewport: viewport,
    );
  }

  /// Create a copy with updated origin (panning)
  DiagramSpace withOrigin(Offset newOrigin) {
    return DiagramSpace(
      baseScale: baseScale,
      origin: newOrigin,
      viewport: viewport,
    );
  }

  /// Create a copy with zoom centered on a canvas point
  DiagramSpace zoomAt(double factor, Offset canvasPoint) {
    if (viewport != null) {
      // Delegate to viewport
      final newViewport = viewport!.copyWith(
        scale: (viewport!.scale * factor).clamp(viewport!.minScale, viewport!.maxScale),
      );
      return DiagramSpace(
        baseScale: baseScale,
        origin: origin,
        viewport: newViewport,
      );
    }
    
    final newScale = (baseScale * factor).clamp(1.0, 500.0);
    // Adjust origin to keep the point fixed
    final engineeringPoint = toEngineering(canvasPoint);
    final newOrigin = Offset(
      canvasPoint.dx - engineeringPoint.dx * newScale,
      canvasPoint.dy + engineeringPoint.dy * newScale,
    );
    return DiagramSpace(baseScale: newScale, origin: newOrigin, viewport: viewport);
  }

  /// Pan the diagram by canvas delta
  DiagramSpace pan(Offset canvasDelta) {
    if (viewport != null) {
      // Delegate to viewport
      return DiagramSpace(
        baseScale: baseScale,
        origin: origin,
        viewport: viewport!.copyWith(panOffset: viewport!.panOffset + canvasDelta),
      );
    }
    
    return DiagramSpace(
      baseScale: baseScale,
      origin: Offset(origin.dx + canvasDelta.dx, origin.dy + canvasDelta.dy),
      viewport: viewport,
    );
  }

  /// Pan to keep a point centered on the canvas
  DiagramSpace panToCenter(Offset canvasCenter, Offset targetEngineeringPoint) {
    return DiagramSpace(
      baseScale: baseScale,
      origin: Offset(
        canvasCenter.dx - targetEngineeringPoint.dx * scale,
        canvasCenter.dy + targetEngineeringPoint.dy * scale,
      ),
      viewport: viewport,
    );
  }

  /// Create a copy with a new viewport
  DiagramSpace withViewport(DiagramViewport? newViewport) {
    return DiagramSpace(
      baseScale: baseScale,
      origin: origin,
      viewport: newViewport,
    );
  }

  /// Get canvas bounds for a given engineering rect
  Rect toCanvasRect(Rect engineeringRect) {
    final topLeft = toCanvas(engineeringRect.left, engineeringRect.top);
    final bottomRight = toCanvas(engineeringRect.right, engineeringRect.bottom);
    return Rect.fromPoints(topLeft, bottomRight);
  }

  /// Get engineering bounds for a given canvas rect
  Rect toEngineeringRect(Rect canvasRect) {
    final topLeft = toEngineering(Offset(canvasRect.left, canvasRect.top));
    final bottomRight = toEngineering(Offset(canvasRect.right, canvasRect.bottom));
    return Rect.fromPoints(topLeft, bottomRight);
  }

  /// Check if a canvas point is within the visible engineering area
  bool isPointVisible(Offset canvasPoint, Size canvasSize) {
    return canvasPoint.dx >= 0 &&
        canvasPoint.dx <= canvasSize.width &&
        canvasPoint.dy >= 0 &&
        canvasPoint.dy <= canvasSize.height;
  }

  /// Check if an engineering point is within the visible engineering area
  bool isEngineeringPointVisible(Offset engineeringPoint, Size canvasSize) {
    final canvasPoint = toCanvasOffset(engineeringPoint);
    return isPointVisible(canvasPoint, canvasSize);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiagramSpace &&
        other.baseScale == baseScale &&
        other.origin == origin &&
        other.viewport == viewport;
  }

  @override
  int get hashCode => Object.hash(baseScale, origin, viewport);

  @override
  String toString() => 'DiagramSpace(baseScale: $baseScale, origin: $origin, viewport: $viewport)';
}

/// Preset configurations for common diagram types
enum DiagramSpacePreset {
  /// Engineering drawings (structural, civil)
  /// Scale: 50px per meter
  engineering,

  /// Architectural drawings
  /// Scale: 20px per meter
  architectural,

  /// Detail drawings (high detail)
  /// Scale: 100px per meter
  detail,

  /// Schematic diagrams (low detail)
  /// Scale: 10px per meter
  schematic,
}

/// Default z-index layering constants for diagram primitives
/// 
/// Use these values when creating primitives to ensure proper layering:
/// ```dart
/// // Base layer (soil, ground)
/// DiagramRect(id: 'ground', ..., zIndex: DiagramLayers.base)
/// 
/// // Structure layer
/// DiagramRect(id: 'column', ..., zIndex: DiagramLayers.structure)
/// 
/// // Water layer
/// DiagramRect(id: 'water', ..., zIndex: DiagramLayers.water)
/// 
/// // Dimension lines
/// DiagramLine(..., zIndex: DiagramLayers.dimension)
/// 
/// // Text labels (always on top)
/// DiagramText(..., zIndex: DiagramLayers.label)
/// ```
class DiagramLayers {
  DiagramLayers._();

  /// Soil / ground base layer
  static const int base = 0;

  /// Structure elements (columns, beams, walls)
  static const int structure = 1;

  /// Water / fluid elements
  static const int water = 2;

  /// Reinforcement / rebars
  static const int reinforcement = 3;

  /// Hatch patterns / fills
  static const int hatch = 4;

  /// Dimension lines and annotations
  static const int dimension = 10;

  /// Text labels (on top of everything)
  static const int label = 20;

  /// Temporary/debug elements (always on top)
  static const int debug = 100;
}

/// Utility functions for hatch pattern scaling
class HatchScaler {
  HatchScaler._();

  /// Calculate scaled spacing for hatch patterns
  /// 
  /// Ensures consistent visual density regardless of zoom level
  /// 
  /// [baseSpacing] - base spacing in pixels at 1x zoom
  /// [scale] - current scale factor
  /// [targetDensity] - target visual density (default: 1.0)
  static double getScaledSpacing(double baseSpacing, double scale, {double targetDensity = 1.0}) {
    return baseSpacing * scale * targetDensity;
  }

  /// Calculate scaled line width for hatch patterns
  static double getScaledLineWidth(double baseLineWidth, double scale) {
    return baseLineWidth * scale;
  }

  /// Calculate optimal hatch spacing for a given bounding box
  /// 
  /// Ensures approximately [desiredLines] lines across the bounding box
  static double optimalSpacing(double boundingBoxDimension, int desiredLines) {
    if (desiredLines <= 0) return boundingBoxDimension;
    return boundingBoxDimension / desiredLines;
  }

  /// Scale-aware hatch configuration
  static HatchConfig scaleHatch(HatchConfig config, double scale) {
    return HatchConfig(
      spacing: getScaledSpacing(config.spacing, scale),
      lineWidth: getScaledLineWidth(config.lineWidth, scale),
      angle: config.angle,
    );
  }
}

/// Configuration for hatch patterns with scale awareness
class HatchConfig {
  final double spacing;
  final double lineWidth;
  final double angle;

  const HatchConfig({
    required this.spacing,
    required this.lineWidth,
    this.angle = 45.0,
  });

  HatchConfig copyWith({
    double? spacing,
    double? lineWidth,
    double? angle,
  }) {
    return HatchConfig(
      spacing: spacing ?? this.spacing,
      lineWidth: lineWidth ?? this.lineWidth,
      angle: angle ?? this.angle,
    );
  }
}
