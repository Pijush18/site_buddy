// FILE HEADER
// ----------------------------------------------
// File: diagram_renderer.dart
// Feature: design
// Layer: presentation/widgets
//
// PURPOSE:
// Base widget for rendering DiagramPrimitives using the DiagramEngine.
// This widget converts the primitives to actual canvas drawings.
//
// This replaces the legacy CustomPainter-based diagrams with
// real engineering data rendering.
//
// ----------------------------------------------


import 'package:flutter/material.dart';

import 'package:site_buddy/visualization/engine_interface.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart';

/// WIDGET: DiagramRenderer
/// PURPOSE: Renders a list of DiagramPrimitives using the DiagramEngine.
class DiagramRenderer extends StatelessWidget {
  /// List of diagram primitives to render
  final List<DiagramPrimitive> primitives;

  /// Optional custom size (if null, uses available space)
  final Size? size;

  /// Background color
  final Color backgroundColor;

  /// Whether to show grid
  final bool showGrid;

  /// Custom configuration for the diagram
  final DiagramConfig? config;

  /// Diagram space for coordinate mapping
  final DiagramSpace? space;

  /// Title to display at top of diagram
  final String? title;

  const DiagramRenderer({
    super.key,
    required this.primitives,
    this.size,
    this.backgroundColor = Colors.white,
    this.showGrid = false,
    this.config,
    this.space,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBgColor = isDark
        ? const Color(0xFF1E1E1E)
        : backgroundColor;

    return Container(
      color: effectiveBgColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final renderSize = size ?? Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return CustomPaint(
            size: renderSize,
            painter: _DiagramPainter(
              primitives: primitives,
              config: config ?? const DiagramConfig(),
              space: space,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}

/// PAINTER: _DiagramPainter
/// PURPOSE: Custom painter that renders DiagramPrimitives using the engine.
class _DiagramPainter extends CustomPainter {
  final List<DiagramPrimitive> primitives;
  final DiagramConfig config;
  final DiagramSpace? space;
  final bool isDark;

  _DiagramPainter({
    required this.primitives,
    required this.config,
    this.space,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (primitives.isEmpty) {
      _drawEmptyState(canvas, size);
      return;
    }

    // Create coordinate mapper
    final mapper = _createMapper(size);

    // Create paint object for primitives
    final paint = Paint();

    // Sort primitives by zIndex for proper layering
    final sortedPrimitives = List<DiagramPrimitive>.from(primitives)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    // Render each primitive
    for (final primitive in sortedPrimitives) {
      if (!primitive.visible) continue;
      primitive.render(canvas, paint, mapper);
    }
  }

  void _drawEmptyState(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw placeholder rectangle
    final rect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.6,
    );
    canvas.drawRect(rect, paint);

    // Draw X
    canvas.drawLine(rect.topLeft, rect.bottomRight, paint);
    canvas.drawLine(rect.topRight, rect.bottomLeft, paint);

    // Draw placeholder text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'No diagram data available',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );
  }

  CoordinateMapper _createMapper(Size canvasSize) {
    // Use DiagramSpace if provided, otherwise use defaults
    if (space != null) {
      return _DiagramSpaceMapper(
        canvasSize: canvasSize,
        diagramSpace: space!,
      );
    }

    // Default mapper with 600x400 world units
    return _SimpleCoordinateMapper(
      canvasSize: canvasSize,
      worldSize: const Size(600, 400),
      origin: Offset.zero,
    );
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter oldDelegate) {
    // Check if primitives have changed
    if (oldDelegate.primitives.length != primitives.length) return true;

    for (int i = 0; i < primitives.length; i++) {
      if (primitives[i].hasChangedFrom(oldDelegate.primitives[i])) {
        return true;
      }
    }

    return false;
  }
}

/// COORDINATE MAPPER: _SimpleCoordinateMapper
/// PURPOSE: Maps between world coordinates and canvas coordinates.
class _SimpleCoordinateMapper implements CoordinateMapper {
  final Size canvasSize;
  final Size worldSize;
  final Offset origin;

  _SimpleCoordinateMapper({
    required this.canvasSize,
    required this.worldSize,
    required this.origin,
  });

  @override
  Offset worldToCanvas(Offset worldPoint) {
    // Translate origin to center of canvas
    final centeredWorld = worldPoint - origin;

    // Calculate scale to fit world in canvas with padding
    final padding = 40.0;
    final availableWidth = canvasSize.width - 2 * padding;
    final availableHeight = canvasSize.height - 2 * padding;

    final scaleX = availableWidth / worldSize.width;
    final scaleY = availableHeight / worldSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // Apply scaling and centering
    final scaledX = centeredWorld.dx * scale + padding;
    final scaledY = canvasSize.height - (centeredWorld.dy * scale + padding); // Flip Y

    return Offset(scaledX, scaledY);
  }

  @override
  Offset canvasToWorld(Offset canvasPoint) {
    // Inverse of worldToCanvas
    final padding = 40.0;
    final availableWidth = canvasSize.width - 2 * padding;
    final availableHeight = canvasSize.height - 2 * padding;

    final scaleX = availableWidth / worldSize.width;
    final scaleY = availableHeight / worldSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // Remove centering and padding
    final worldX = (canvasPoint.dx - padding) / scale + origin.dx;
    final worldY = (canvasSize.height - canvasPoint.dy - padding) / scale + origin.dy;

    return Offset(worldX, worldY);
  }

  @override
  Size worldToCanvasSize(Size worldSize) {
    final padding = 40.0;
    final availableWidth = canvasSize.width - 2 * padding;
    final availableHeight = canvasSize.height - 2 * padding;

    final scaleX = availableWidth / this.worldSize.width;
    final scaleY = availableHeight / this.worldSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    return Size(worldSize.width * scale, worldSize.height * scale);
  }

  @override
  double get scale {
    final padding = 40.0;
    final availableWidth = canvasSize.width - 2 * padding;
    final availableHeight = canvasSize.height - 2 * padding;

    final scaleX = availableWidth / worldSize.width;
    final scaleY = availableHeight / worldSize.height;

    return scaleX < scaleY ? scaleX : scaleY;
  }
}

/// COORDINATE MAPPER: _DiagramSpaceMapper
/// PURPOSE: Adapter that uses the DiagramSpace class directly.
class _DiagramSpaceMapper implements CoordinateMapper {
  final Size canvasSize;
  final DiagramSpace diagramSpace;

  _DiagramSpaceMapper({
    required this.canvasSize,
    required this.diagramSpace,
  });

  @override
  Offset worldToCanvas(Offset worldPoint) {
    return diagramSpace.toCanvasOffset(worldPoint);
  }

  @override
  Offset canvasToWorld(Offset canvasPoint) {
    return diagramSpace.toEngineering(canvasPoint);
  }

  @override
  Size worldToCanvasSize(Size worldSize) {
    return diagramSpace.toCanvasSize(worldSize);
  }

  @override
  double get scale => diagramSpace.scale;
}

/// WIDGET: DiagramRendererWithExport
/// PURPOSE: Diagram renderer with export functionality.
class DiagramRendererWithExport extends StatefulWidget {
  final List<DiagramPrimitive> primitives;
  final String? title;
  final Size? exportSize;
  final Color backgroundColor;

  const DiagramRendererWithExport({
    super.key,
    required this.primitives,
    this.title,
    this.exportSize,
    this.backgroundColor = Colors.white,
  });

  @override
  State<DiagramRendererWithExport> createState() =>
      _DiagramRendererWithExportState();
}

class _DiagramRendererWithExportState extends State<DiagramRendererWithExport> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DiagramRenderer(
            primitives: widget.primitives,
            title: widget.title,
            backgroundColor: widget.backgroundColor,
          ),
        ),
        if (_isExporting)
          const LinearProgressIndicator()
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _exportToPng,
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export PNG'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _exportToPng() async {
    setState(() => _isExporting = true);

    try {
      final size = widget.exportSize ?? const Size(800, 600);
      final pngBytes = await DiagramEngine.exportToPng(
        primitives: widget.primitives,
        size: size,
      );

      if (mounted) {
        // Show success or share dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Diagram exported (${(pngBytes.length / 1024).toStringAsFixed(1)} KB)',
            ),
            action: SnackBarAction(
              label: 'Share',
              onPressed: () {
                // TODO: Implement share functionality
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}
