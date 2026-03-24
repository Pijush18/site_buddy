import 'dart:ui';

/// Core configuration for diagram rendering
/// Controls viewport, scaling, grid, and display settings
class DiagramConfig {
  /// World coordinate bounds (origin at bottom-left)
  final double worldWidth;
  final double worldHeight;

  /// Canvas size in pixels
  final double canvasWidth;
  final double canvasHeight;

  /// Viewport offset (pan) in world coordinates
  final Offset panOffset;

  /// Zoom level (1.0 = 100%)
  final double zoom;

  /// Grid settings
  final bool showGrid;
  final double gridSpacing;
  final Color gridColor;

  /// Background color
  final Color backgroundColor;

  /// Default constructor
  const DiagramConfig({
    this.worldWidth = 1000.0,
    this.worldHeight = 800.0,
    this.canvasWidth = 400.0,
    this.canvasHeight = 300.0,
    this.panOffset = Offset.zero,
    this.zoom = 1.0,
    this.showGrid = true,
    this.gridSpacing = 100.0,
    this.gridColor = const Color(0xFFE0E0E0),
    this.backgroundColor = const Color(0xFFFFFFFF),
  });

  /// Create a copy with modifications
  DiagramConfig copyWith({
    double? worldWidth,
    double? worldHeight,
    double? canvasWidth,
    double? canvasHeight,
    Offset? panOffset,
    double? zoom,
    bool? showGrid,
    double? gridSpacing,
    Color? gridColor,
    Color? backgroundColor,
  }) {
    return DiagramConfig(
      worldWidth: worldWidth ?? this.worldWidth,
      worldHeight: worldHeight ?? this.worldHeight,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      panOffset: panOffset ?? this.panOffset,
      zoom: zoom ?? this.zoom,
      showGrid: showGrid ?? this.showGrid,
      gridSpacing: gridSpacing ?? this.gridSpacing,
      gridColor: gridColor ?? this.gridColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() => {
        'worldWidth': worldWidth,
        'worldHeight': worldHeight,
        'canvasWidth': canvasWidth,
        'canvasHeight': canvasHeight,
        'panOffset': {'dx': panOffset.dx, 'dy': panOffset.dy},
        'zoom': zoom,
        'showGrid': showGrid,
        'gridSpacing': gridSpacing,
        'gridColor': gridColor.toARGB32(),
        'backgroundColor': backgroundColor.toARGB32(),
      };

  /// Create from JSON
  factory DiagramConfig.fromJson(Map<String, dynamic> json) {
    return DiagramConfig(
      worldWidth: (json['worldWidth'] as num?)?.toDouble() ?? 1000.0,
      worldHeight: (json['worldHeight'] as num?)?.toDouble() ?? 800.0,
      canvasWidth: (json['canvasWidth'] as num?)?.toDouble() ?? 400.0,
      canvasHeight: (json['canvasHeight'] as num?)?.toDouble() ?? 300.0,
      panOffset: json['panOffset'] != null
          ? Offset(
              (json['panOffset']['dx'] as num).toDouble(),
              (json['panOffset']['dy'] as num).toDouble(),
            )
          : Offset.zero,
      zoom: (json['zoom'] as num?)?.toDouble() ?? 1.0,
      showGrid: json['showGrid'] as bool? ?? true,
      gridSpacing: (json['gridSpacing'] as num?)?.toDouble() ?? 100.0,
      gridColor: Color(json['gridColor'] as int? ?? 0xFFE0E0E0),
      backgroundColor: Color(json['backgroundColor'] as int? ?? 0xFFFFFFFF),
    );
  }
}
