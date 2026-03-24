import 'package:flutter/material.dart';
import 'package:site_buddy/visualization/config/diagram_config.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart' show DiagramPrimitive, DiagramRect, DiagramLine, CoordinateMapper;
import 'package:site_buddy/visualization/coordinate_system/coordinate_mapper.dart';
import 'package:site_buddy/visualization/coordinate_system/diagram_space.dart' show DiagramSpace;

/// Main diagram renderer widget
/// 
/// Supports both legacy [DiagramConfig] based rendering and
/// modern [DiagramSpace] based engineering coordinate rendering.
class DiagramWidget extends StatefulWidget {
  final DiagramConfig config;
  final List<DiagramPrimitive> primitives;
  final Widget? overlay;
  
  /// Optional DiagramSpace for engineering coordinate support
  /// When provided, uses engineering units (meters) instead of world units
  final DiagramSpace? space;

  const DiagramWidget({
    super.key,
    required this.config,
    required this.primitives,
    this.overlay,
    this.space,
  });

  @override
  State<DiagramWidget> createState() => DiagramWidgetState();
}

class DiagramWidgetState extends State<DiagramWidget> {
  late DiagramConfig _config;
  late CoordinateMapper _mapper;
  late List<DiagramPrimitive> _sortedPrimitives;
  DiagramSpace? _space;

  @override
  void initState() {
    super.initState();
    _updateFromConfig();
  }

  @override
  void didUpdateWidget(DiagramWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config || 
        oldWidget.space != widget.space ||
        oldWidget.primitives != widget.primitives) {
      _updateFromConfig();
    }
  }

  void _updateFromConfig() {
    _config = widget.config;
    _space = widget.space;
    
    // Create mapper with or without DiagramSpace
    if (_space != null) {
      _mapper = DefaultCoordinateMapper(_config, space: _space);
    } else {
      _mapper = DefaultCoordinateMapper(_config);
    }
    
    // Sort primitives by zIndex for proper layering
    // Z-index layering ensures correct render order:
    // - 0: Soil/base elements
    // - 1: Structures
    // - 2: Water
    // - 10: Dimensions
    // - 20: Labels
    _sortedPrimitives = List.from(widget.primitives)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));
  }

  DiagramConfig get config => _config;
  CoordinateMapper get mapper => _mapper;
  DiagramSpace? get space => _space;

  /// Pan the diagram by canvas delta
  void pan(Offset canvasDelta) {
    setState(() {
      if (_space != null) {
        // Use DiagramSpace for panning
        _space = _space!.pan(canvasDelta);
        _mapper = DefaultCoordinateMapper(_config, space: _space);
      } else {
        // Use legacy config-based panning
        _config = _config.copyWith(
          panOffset: Offset(
            _config.panOffset.dx + canvasDelta.dx / _mapper.scale,
            _config.panOffset.dy - canvasDelta.dy / _mapper.scale,
          ),
        );
        _mapper = DefaultCoordinateMapper(_config);
      }
    });
  }

  /// Zoom the diagram
  void zoom(double delta, Offset focalPoint) {
    setState(() {
      final newZoom = (_config.zoom + delta).clamp(0.1, 10.0);
      _config = _config.copyWith(zoom: newZoom);
      
      if (_space != null) {
        // Zoom centered on focal point
        _space = _space!.zoomAt(1.0 + delta, focalPoint);
        _mapper = DefaultCoordinateMapper(_config, space: _space);
      } else {
        _mapper = DefaultCoordinateMapper(_config);
      }
    });
  }

  /// Zoom to a specific scale
  void zoomTo(double targetScale, {Offset? focalPoint}) {
    setState(() {
      if (_space != null) {
        final factor = targetScale / _space!.scale;
        final center = focalPoint ?? Offset(
          _config.canvasWidth / 2,
          _config.canvasHeight / 2,
        );
        _space = _space!.zoomAt(factor, center);
        _mapper = DefaultCoordinateMapper(_config, space: _space);
      } else {
        _mapper = DefaultCoordinateMapper(_config);
      }
    });
  }

  /// Fit the diagram to show all primitives within the canvas
  void fitToContent() {
    if (_sortedPrimitives.isEmpty) return;
    
    // Calculate bounding box of all primitives
    // This is a simplified implementation - full version would
    // query each primitive type for its bounds
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    
    for (final primitive in _sortedPrimitives) {
      if (primitive is DiagramRect) {
        final right = primitive.position.dx + primitive.width;
        final top = primitive.position.dy + primitive.height;
        if (primitive.position.dx < minX) minX = primitive.position.dx;
        if (primitive.position.dy < minY) minY = primitive.position.dy;
        if (right > maxX) maxX = right;
        if (top > maxY) maxY = top;
      } else if (primitive is DiagramLine) {
        if (primitive.start.dx < minX) minX = primitive.start.dx;
        if (primitive.start.dy < minY) minY = primitive.start.dy;
        if (primitive.end.dx > maxX) maxX = primitive.end.dx;
        if (primitive.end.dy > maxY) maxY = primitive.end.dy;
      }
    }
    
    if (minX == double.infinity) return;
    
    // Calculate required scale
    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;
    
    if (contentWidth <= 0 || contentHeight <= 0) return;
    
    final scaleX = _config.canvasWidth / (contentWidth * 1.2);
    final scaleY = _config.canvasHeight / (contentHeight * 1.2);
    final newScale = (scaleX < scaleY ? scaleX : scaleY).clamp(1.0, 500.0);
    
    // Center the content
    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;
    
    setState(() {
      _space = DiagramSpace(
        baseScale: newScale,
        origin: Offset(
          _config.canvasWidth / 2 - centerX * newScale,
          _config.canvasHeight / 2 + centerY * newScale,
        ),
      );
      _mapper = DefaultCoordinateMapper(_config, space: _space);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {
        if (details.scale != 1.0) {
          zoom(details.scale - 1.0, details.focalPoint);
        } else {
          pan(details.focalPointDelta);
        }
      },
      child: ClipRect(
        child: CustomPaint(
          painter: DiagramPainter(
            config: _config,
            primitives: _sortedPrimitives,
            mapper: _mapper,
          ),
          child: widget.overlay,
        ),
      ),
    );
  }
}

/// Interactive diagram widget with smooth zoom/pan using InteractiveViewer
/// 
/// Features:
/// - Pinch to zoom (0.5x - 5x)
/// - Drag to pan
/// - Double-tap to reset
/// - Bounded viewport
/// 
/// IMPORTANT: This widget applies ALL transforms via InteractiveViewer.
/// The CoordinateMapper uses the base space WITHOUT viewport to avoid double scaling.
/// 
/// Architecture:
/// - Primitives use base DiagramSpace (no viewport)
/// - InteractiveViewer applies zoom/pan at widget level
/// - This ensures visual zoom == export zoom when capturing
class InteractiveDiagramWidget extends StatefulWidget {
  final DiagramConfig config;
  final List<DiagramPrimitive> primitives;
  final Widget? overlay;
  
  /// DiagramSpace for coordinate transformation
  /// IMPORTANT: Do NOT set viewport here - InteractiveViewer handles zoom/pan
  final DiagramSpace? space;
  
  /// Minimum zoom level (0.1 = 10%)
  final double minScale;
  
  /// Maximum zoom level (10.0 = 1000%)
  final double maxScale;
  
  /// Callback when interaction starts
  final VoidCallback? onInteractionStart;
  
  /// Callback when interaction ends
  final VoidCallback? onInteractionEnd;

  const InteractiveDiagramWidget({
    super.key,
    required this.config,
    required this.primitives,
    this.overlay,
    this.space,
    this.minScale = 0.5,
    this.maxScale = 5.0,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  @override
  State<InteractiveDiagramWidget> createState() => InteractiveDiagramWidgetState();
}

class InteractiveDiagramWidgetState extends State<InteractiveDiagramWidget> {
  final TransformationController _transformationController = TransformationController();
  late List<DiagramPrimitive> _sortedPrimitives;
  
  /// Current scale (zoom level)
  double get currentScale => _transformationController.value.getMaxScaleOnAxis();
  
  /// Current zoom percentage
  int get zoomPercentage => (currentScale * 100).round();

  /// Current transformation matrix (for export)
  Matrix4 get transformationMatrix => _transformationController.value;

  @override
  void initState() {
    super.initState();
    _sortPrimitives();
    _transformationController.addListener(_onTransformChanged);
  }

  @override
  void didUpdateWidget(InteractiveDiagramWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.primitives != widget.primitives) {
      _sortPrimitives();
    }
  }

  void _sortPrimitives() {
    _sortedPrimitives = List.from(widget.primitives)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));
  }

  void _onTransformChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }

  /// Reset view to default (no zoom, centered)
  void resetView() {
    _transformationController.value = Matrix4.identity();
  }

  /// Zoom in by a factor
  void zoomIn({double factor = 1.5}) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final newScale = currentScale * factor;
    _applyScale(newScale.clamp(widget.minScale, widget.maxScale));
  }

  /// Zoom out by a factor
  void zoomOut({double factor = 1.5}) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final newScale = currentScale / factor;
    _applyScale(newScale.clamp(widget.minScale, widget.maxScale));
  }

  void _applyScale(double targetScale) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale == targetScale) return;
    
    final scaleFactor = targetScale / currentScale;
    final center = Offset(
      widget.config.canvasWidth / 2,
      widget.config.canvasHeight / 2,
    );
    
    // Build scale matrix around center: T * S * T^-1
    final translateToCenter = Matrix4.translationValues(center.dx, center.dy, 0);
    final scale = Matrix4.diagonal3Values(scaleFactor, scaleFactor, 1);
    final translateBack = Matrix4.translationValues(-center.dx, -center.dy, 0);
    final scaleAroundCenter = translateToCenter * scale * translateBack;
    
    final matrix = _transformationController.value.clone();
    matrix.multiply(scaleAroundCenter);
    
    _transformationController.value = matrix;
  }

  /// Fit content to view
  void fitToContent() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    
    for (final primitive in _sortedPrimitives) {
      if (primitive is DiagramRect) {
        if (primitive.position.dx < minX) minX = primitive.position.dx;
        if (primitive.position.dy < minY) minY = primitive.position.dy;
        if (primitive.position.dx + primitive.width > maxX) maxX = primitive.position.dx + primitive.width;
        if (primitive.position.dy + primitive.height > maxY) maxY = primitive.position.dy + primitive.height;
      } else if (primitive is DiagramLine) {
        if (primitive.start.dx < minX) minX = primitive.start.dx;
        if (primitive.start.dy < minY) minY = primitive.start.dy;
        if (primitive.end.dx > maxX) maxX = primitive.end.dx;
        if (primitive.end.dy > maxY) maxY = primitive.end.dy;
      }
    }
    
    if (minX == double.infinity) return;
    
    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;
    
    if (contentWidth <= 0 || contentHeight <= 0) return;
    
    final padding = 0.1;
    final scaleX = widget.config.canvasWidth / (contentWidth * (1 + padding * 2));
    final scaleY = widget.config.canvasHeight / (contentHeight * (1 + padding * 2));
    final targetScale = (scaleX < scaleY ? scaleX : scaleY).clamp(widget.minScale, widget.maxScale);
    
    final contentCenterX = (minX + maxX) / 2;
    final contentCenterY = (minY + maxY) / 2;
    
    final targetCenterX = widget.config.canvasWidth / 2;
    final targetCenterY = widget.config.canvasHeight / 2;
    
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 3, targetCenterX - contentCenterX * targetScale);
    matrix.setEntry(1, 3, targetCenterY - contentCenterY * targetScale);
    matrix.setEntry(0, 0, targetScale);
    matrix.setEntry(1, 1, targetScale);
    
    _transformationController.value = matrix;
  }

  @override
  Widget build(BuildContext context) {
    // Create mapper WITHOUT viewport to avoid double scaling
    // InteractiveViewer handles zoom/pan at the widget level
    final mapper = widget.space != null
        ? DefaultCoordinateMapper(widget.config, space: widget.space)
        : DefaultCoordinateMapper(widget.config);

    return ClipRect(
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        constrained: false,
        onInteractionStart: (_) => widget.onInteractionStart?.call(),
        onInteractionEnd: (_) => widget.onInteractionEnd?.call(),
        child: GestureDetector(
          onDoubleTap: resetView,
          child: SizedBox(
            width: widget.config.canvasWidth,
            height: widget.config.canvasHeight,
            child: Stack(
              children: [
                RepaintBoundary(
                  child: CustomPaint(
                    painter: DiagramPainter(
                      config: widget.config,
                      primitives: _sortedPrimitives,
                      mapper: mapper,
                    ),
                    size: Size(widget.config.canvasWidth, widget.config.canvasHeight),
                  ),
                ),
                if (widget.overlay != null) widget.overlay!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// CustomPainter for rendering the diagram
/// 
/// Renders primitives in z-index order and supports
/// scale-aware hatch patterns and line widths.
class DiagramPainter extends CustomPainter {
  final DiagramConfig config;
  final List<DiagramPrimitive> primitives;
  final CoordinateMapper mapper;
  final Paint _paint;

  DiagramPainter({
    required this.config,
    required this.primitives,
    required this.mapper,
  }) : _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint..color = config.backgroundColor..style = PaintingStyle.fill,
    );

    // Grid
    if (config.showGrid) {
      _drawGrid(canvas, size);
    }

    // Render primitives in z-index order
    // The list is pre-sorted by DiagramWidgetState
    for (final primitive in primitives) {
      if (primitive.visible) {
        primitive.render(canvas, _paint, mapper);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    _paint
      ..color = config.gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Calculate grid spacing based on scale
    // Use scale-aware spacing for consistent visual density
    final baseSpacing = config.gridSpacing;
    var spacing = baseSpacing * mapper.scale;
    
    // Adjust grid density based on zoom level
    while (spacing < 20) {
      spacing *= 2;
    }
    while (spacing > 100) {
      spacing /= 2;
    }
    
    if (spacing < 5) return; // Too dense, skip

    // Calculate grid origin
    Offset origin;
    if (mapper is DefaultCoordinateMapper) {
      origin = (mapper as DefaultCoordinateMapper).worldToCanvas(Offset.zero);
    } else {
      origin = mapper.worldToCanvas(Offset.zero);
    }

    // Vertical lines
    var x = origin.dx % spacing;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _paint);
      x += spacing;
    }

    // Horizontal lines
    var y = origin.dy % spacing;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _paint);
      y += spacing;
    }
  }

  @override
  bool shouldRepaint(DiagramPainter oldDelegate) {
    return config != oldDelegate.config ||
        primitives != oldDelegate.primitives ||
        mapper != oldDelegate.mapper;
  }
}
