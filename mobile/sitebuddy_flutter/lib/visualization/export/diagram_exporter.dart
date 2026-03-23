import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../primitives/primitives.dart';
import '../config/diagram_config.dart';
import '../coordinate_system/diagram_space.dart';
import '../coordinate_system/coordinate_mapper.dart';
import '../core/viewport_controller.dart';

/// Configuration for diagram export
class ExportConfig {
  /// Target size for export in pixels
  final Size size;

  /// Background color (null for transparent)
  final Color? backgroundColor;

  /// Scale factor for high-resolution export
  /// 1.0 = 100%, 2.0 = 200% (Retina)
  final double pixelRatio;

  /// Whether to include grid
  final bool includeGrid;

  /// Grid spacing (used if includeGrid is true)
  final double gridSpacing;

  /// Whether to respect current viewport transform
  /// When true, exports at current zoom/pan state
  /// When false, exports at canonical view (no transform)
  final bool respectViewport;

  /// Viewport state to respect (required if respectViewport is true)
  final DiagramViewport? viewport;

  const ExportConfig({
    required this.size,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.pixelRatio = 1.0,
    this.includeGrid = false,
    this.gridSpacing = 50.0,
    this.respectViewport = false,
    this.viewport,
  });

  /// Factory for common export sizes
  static ExportConfig thumbnail({Color? background}) => const ExportConfig(
    size: Size(200, 200),
    backgroundColor: Color(0xFFFFFFFF),
    pixelRatio: 1.0,
    respectViewport: false,
  );

  static ExportConfig standard({Color? background}) => const ExportConfig(
    size: Size(800, 600),
    backgroundColor: Color(0xFFFFFFFF),
    pixelRatio: 1.0,
    respectViewport: false,
  );

  static ExportConfig highRes({Color? background}) => const ExportConfig(
    size: Size(1920, 1080),
    backgroundColor: Color(0xFFFFFFFF),
    pixelRatio: 2.0,
    respectViewport: false,
  );

  static ExportConfig print({Color? background}) => const ExportConfig(
    size: Size(2480, 3508), // A4 at 300 DPI
    backgroundColor: Color(0xFFFFFFFF),
    pixelRatio: 3.0,
    respectViewport: false,
  );

  /// Export current view (respects viewport transform)
  static ExportConfig currentView({
    required Size size,
    required DiagramViewport viewport,
    Color? background,
  }) => ExportConfig(
    size: size,
    backgroundColor: background ?? const Color(0xFFFFFFFF),
    pixelRatio: 1.0,
    respectViewport: true,
    viewport: viewport,
  );
}

/// Renders a diagram to a canvas using the same rendering logic for both
/// on-screen display and export.
///
/// This is the SINGLE SOURCE OF TRUTH for diagram rendering.
/// All rendering paths must use this function to ensure visual consistency.
///
/// Usage:
/// ```dart
/// // In CustomPainter paint()
/// renderDiagram(
///   canvas: canvas,
///   size: size,
///   primitives: myPrimitives,
///   config: myConfig,
///   space: mySpace,
/// );
///
/// // For export
/// final bytes = await DiagramExporter.exportToPng(...);
/// ```
void renderDiagram({
  required Canvas canvas,
  required Size size,
  required List<DiagramPrimitive> primitives,
  required DiagramConfig config,
  DiagramSpace? space,
  CoordinateMapper? mapper,
  double viewportScale = 1.0,
}) {
  // Draw background
  if (config.backgroundColor != null) {
    final bgPaint = Paint()
      ..color = config.backgroundColor!
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  // Draw grid if needed
  if (config.showGrid) {
    _drawGrid(canvas, size, config, mapper);
  }

  // Create coordinate mapper if not provided
  final coordMapper = mapper ?? DefaultCoordinateMapper(config, space: space);
  final paint = Paint();

  // Apply viewport transform if scale != 1
  if (viewportScale != 1.0) {
    canvas.save();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    canvas.translate(centerX, centerY);
    canvas.scale(viewportScale);
    canvas.translate(-centerX, -centerY);
  }

  // Sort and render primitives by zIndex
  final sortedPrimitives = List<DiagramPrimitive>.from(primitives)
    ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

  for (final primitive in sortedPrimitives) {
    if (primitive.visible) {
      primitive.render(canvas, paint, coordMapper);
    }
  }

  if (viewportScale != 1.0) {
    canvas.restore();
  }
}

void _drawGrid(
  Canvas canvas,
  Size size,
  DiagramConfig config,
  CoordinateMapper? mapper,
) {
  final paint = Paint()
    ..color = config.gridColor
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

  final spacing = config.gridSpacing * (mapper?.scale ?? 1.0);
  if (spacing < 5) return;

  Offset origin;
  if (mapper is DefaultCoordinateMapper) {
    origin = (mapper as DefaultCoordinateMapper).worldToCanvas(Offset.zero);
  } else if (mapper != null) {
    origin = mapper.worldToCanvas(Offset.zero);
  } else {
    origin = Offset.zero;
  }

  // Vertical lines
  var x = origin.dx % spacing;
  while (x < size.width) {
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    x += spacing;
  }

  // Horizontal lines
  var y = origin.dy % spacing;
  while (y < size.height) {
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    y += spacing;
  }
}

/// Diagram exporter for generating PNG images
///
/// Reuses the SAME rendering pipeline as the interactive renderer
/// to ensure visual consistency between on-screen and exported output.
///
/// Key Design Decisions:
/// 1. Export ALWAYS uses [renderDiagram] - the same logic as on-screen
/// 2. By default, exports at canonical view (respectViewport: false)
/// 3. Use respectViewport: true to export current zoom/pan state
/// 4. ui.Image is disposed immediately after use to prevent memory leaks
class DiagramExporter {
  DiagramExporter._();

  /// Export diagram to PNG bytes
  ///
  /// [primitives] - List of diagram primitives to render
  /// [config] - Export configuration (size, background, viewport)
  /// [space] - DiagramSpace for coordinate transformation
  ///
  /// Memory Safety:
  /// - ui.Image is converted to bytes and disposed
  /// - No lingering GPU resources
  ///
  /// API Safety:
  /// - Validates primitives list (throws on null/empty)
  /// - Clamps pixelRatio to safe range
  static Future<Uint8List> exportToPng({
    required List<DiagramPrimitive>? primitives,
    required Size size,
    DiagramSpace? space,
    ExportConfig? config,
  }) async {
    // API Safety: Validate primitives
    if (primitives == null) {
      throw ArgumentError.notNull('primitives');
    }
    if (primitives.isEmpty) {
      throw ArgumentError('primitives cannot be empty');
    }

    final exportConfig = config ?? ExportConfig(size: size);

    // Clamp pixelRatio to prevent excessive memory usage
    final safePixelRatio = exportConfig.pixelRatio.clamp(0.5, 4.0);
    final safeSize = Size(
      (size.width * safePixelRatio).round().toDouble(),
      (size.height * safePixelRatio).round().toDouble(),
    );

    // Create diagram config
    final diagramConfig = DiagramConfig(
      worldWidth: safeSize.width,
      worldHeight: safeSize.height,
      canvasWidth: safeSize.width,
      canvasHeight: safeSize.height,
      showGrid: exportConfig.includeGrid,
      gridSpacing: exportConfig.gridSpacing * safePixelRatio,
      backgroundColor: exportConfig.backgroundColor ?? const Color(0xFFFFFFFF),
    );

    // Create coordinate mapper
    // If respecting viewport, create a space with the viewport transform baked in
    DiagramSpace? exportSpace = space;
    if (exportConfig.respectViewport && exportConfig.viewport != null) {
      if (space != null) {
        exportSpace = DiagramSpace(
          baseScale: space.baseScale,
          origin: space.origin + exportConfig.viewport!.panOffset,
          viewport: exportConfig.viewport,
        );
      }
    }

    // Use PictureRecorder for synchronous rendering
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Render using shared pipeline
    renderDiagram(
      canvas: canvas,
      size: safeSize,
      primitives: primitives,
      config: diagramConfig,
      space: exportSpace,
      viewportScale: exportConfig.respectViewport && exportConfig.viewport != null
          ? exportConfig.viewport!.effectiveScale
          : 1.0,
    );

    // End recording
    final picture = recorder.endRecording();

    // Convert to image with memory-safe approach
    ui.Image? image;
    try {
      image = await picture.toImage(
        safeSize.width.toInt(),
        safeSize.height.toInt(),
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to PNG bytes');
      }

      return byteData.buffer.asUint8List();
    } finally {
      // CRITICAL: Dispose image to prevent memory leaks
      image?.dispose();
      picture.dispose();
    }
  }

  /// Export diagram to PNG bytes (simplified API)
  static Future<Uint8List> exportToPngSimple({
    required List<DiagramPrimitive> primitives,
    required Size size,
    DiagramSpace? space,
    Color backgroundColor = const Color(0xFFFFFFFF),
    double pixelRatio = 1.0,
  }) {
    return exportToPng(
      primitives: primitives,
      size: size,
      space: space,
      config: ExportConfig(
        size: size,
        backgroundColor: backgroundColor,
        pixelRatio: pixelRatio,
      ),
    );
  }

  /// Export diagram to a Flutter ui.Image
  ///
  /// IMPORTANT: Caller MUST dispose the returned image to prevent memory leaks
  ///
  /// ```dart
  /// ui.Image? image;
  /// try {
  ///   image = await DiagramExporter.exportToImage(...);
  ///   // Use image
  /// } finally {
  ///   image?.dispose();
  /// }
  /// ```
  ///
  /// API Safety:
  /// - Validates primitives list (throws on null/empty)
  static Future<ui.Image> exportToImage({
    required List<DiagramPrimitive>? primitives,
    required Size size,
    DiagramSpace? space,
    ExportConfig? config,
  }) async {
    // API Safety: Validate primitives
    if (primitives == null) {
      throw ArgumentError.notNull('primitives');
    }
    if (primitives.isEmpty) {
      throw ArgumentError('primitives cannot be empty');
    }

    final exportConfig = config ?? ExportConfig(size: size);

    final safePixelRatio = exportConfig.pixelRatio.clamp(0.5, 4.0);
    final safeSize = Size(
      (size.width * safePixelRatio).round().toDouble(),
      (size.height * safePixelRatio).round().toDouble(),
    );

    final diagramConfig = DiagramConfig(
      worldWidth: safeSize.width,
      worldHeight: safeSize.height,
      canvasWidth: safeSize.width,
      canvasHeight: safeSize.height,
      showGrid: exportConfig.includeGrid,
      gridSpacing: exportConfig.gridSpacing * safePixelRatio,
      backgroundColor: exportConfig.backgroundColor ?? const Color(0xFFFFFFFF),
    );

    DiagramSpace? exportSpace = space;
    if (exportConfig.respectViewport && exportConfig.viewport != null) {
      if (space != null) {
        exportSpace = DiagramSpace(
          baseScale: space.baseScale,
          origin: space.origin + exportConfig.viewport!.panOffset,
          viewport: exportConfig.viewport,
        );
      }
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Render using shared pipeline
    renderDiagram(
      canvas: canvas,
      size: safeSize,
      primitives: primitives,
      config: diagramConfig,
      space: exportSpace,
      viewportScale: exportConfig.respectViewport && exportConfig.viewport != null
          ? exportConfig.viewport!.effectiveScale
          : 1.0,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      safeSize.width.toInt(),
      safeSize.height.toInt(),
    );

    // Picture is no longer needed after toImage
    picture.dispose();

    return image;
  }
}

/// Widget wrapper for exporting diagrams via RenderRepaintBoundary
///
/// ⚠️ DEPRECATED: This is a UI-dependent export path.
///
/// For production-safe exports, use [DiagramExporter.exportToPng] instead.
/// This widget is kept only for backward compatibility with legacy code.
///
/// The pure export pipeline does NOT depend on:
/// - RepaintBoundary
/// - BuildContext
/// - RenderObject
/// - UI frame timing
@Deprecated('Use DiagramExporter.exportToPng() for production-safe export')
class DiagramExportCapture extends StatelessWidget {
  final GlobalKey repaintBoundaryKey;
  final Widget child;

  const DiagramExportCapture({
    super.key,
    required this.repaintBoundaryKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: child,
    );
  }
}

/// Helper for capturing widgets to images
///
/// ⚠️ DEPRECATED: This is a UI-dependent export path.
///
/// This captures the widget AS IT APPEARS on screen, including
/// all viewport transforms. Use ONLY for backward compatibility.
///
/// For production-safe exports, use [DiagramExporter.exportToPng] instead.
///
/// The pure export pipeline provides:
/// - Deterministic output regardless of UI state
/// - No dependency on RepaintBoundary or RenderObject
/// - No race conditions with frame timing
/// - Same rendering logic as on-screen display
@Deprecated('Use DiagramExporter.exportToPng() for production-safe export')
class DiagramCaptureHelper {
  DiagramCaptureHelper._();

  /// Capture a RepaintBoundary to PNG bytes
  ///
  /// Returns null if capture fails (e.g., widget not rendered yet)
  static Future<Uint8List?> captureBoundary(
    GlobalKey key, {
    double pixelRatio = 2.0,
  }) async {
    final safePixelRatio = pixelRatio.clamp(0.5, 4.0);

    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: safePixelRatio);

      try {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    } catch (e) {
      debugPrint('DiagramCaptureHelper error: $e');
      return null;
    }
  }

  /// Capture a RepaintBoundary to ui.Image
  ///
  /// IMPORTANT: Caller MUST dispose the returned image
  static Future<ui.Image?> captureBoundaryToImage(
    GlobalKey key, {
    double pixelRatio = 2.0,
  }) async {
    final safePixelRatio = pixelRatio.clamp(0.5, 4.0);

    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      return await boundary.toImage(pixelRatio: safePixelRatio);
    } catch (e) {
      debugPrint('DiagramCaptureHelper error: $e');
      return null;
    }
  }
}

/// Async export with progress callback
///
/// For large exports that might block the UI thread
class AsyncDiagramExporter {
  AsyncDiagramExporter._();

  /// Export with progress callback
  ///
  /// Progress callback is called on UI thread
  static Future<Uint8List> exportWithProgress({
    required List<DiagramPrimitive> primitives,
    required Size size,
    DiagramSpace? space,
    ExportConfig? config,
    void Function(double progress)? onProgress,
  }) async {
    onProgress?.call(0.1);

    final exportConfig = config ?? ExportConfig(size: size);

    // Prepare data on main thread (lightweight)
    final safePixelRatio = exportConfig.pixelRatio.clamp(0.5, 4.0);
    final safeSize = Size(
      (size.width * safePixelRatio).round().toDouble(),
      (size.height * safePixelRatio).round().toDouble(),
    );

    onProgress?.call(0.2);

    // Render on main thread (can't be moved to isolate easily due to Flutter rendering)
    onProgress?.call(0.4);

    final bytes = await DiagramExporter.exportToPng(
      primitives: primitives,
      size: safeSize,
      space: space,
      config: exportConfig.copyWith(pixelRatio: safePixelRatio),
    );

    onProgress?.call(1.0);

    return bytes;
  }
}

/// Extension for ExportConfig with copyWith
extension ExportConfigCopyWith on ExportConfig {
  ExportConfig copyWith({
    Size? size,
    Color? backgroundColor,
    double? pixelRatio,
    bool? includeGrid,
    double? gridSpacing,
    bool? respectViewport,
    DiagramViewport? viewport,
  }) {
    return ExportConfig(
      size: size ?? this.size,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      includeGrid: includeGrid ?? this.includeGrid,
      gridSpacing: gridSpacing ?? this.gridSpacing,
      respectViewport: respectViewport ?? this.respectViewport,
      viewport: viewport ?? this.viewport,
    );
  }
}
