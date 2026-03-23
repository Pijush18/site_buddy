import 'dart:typed_data';
import 'dart:ui' show Color, Offset, Size;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vector_math/vector_math_64.dart' show Matrix4;
import '../primitives/primitives.dart';
import '../coordinate_system/diagram_space.dart';
import '../coordinate_system/coordinate_mapper.dart';
import '../config/diagram_config.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';

/// Vector PDF renderer for structural diagrams
///
/// Converts DiagramPrimitive objects to TRUE vector PDF drawing commands.
/// Does NOT embed raster images - all output is scalable vector graphics.
///
/// This renderer reuses the same coordinate transformation logic
/// as the screen renderer to ensure visual consistency.
class PdfDiagramRenderer {
  PdfDiagramRenderer._();

  /// Export diagram to vector PDF bytes
  ///
  /// [primitives] - List of diagram primitives to render
  /// [pageSize] - Page dimensions in points (1 point = 1/72 inch)
  /// [space] - DiagramSpace for coordinate transformation
  /// [margin] - Page margin in points
  /// [title] - Optional document title
  /// [showGrid] - Whether to render grid lines
  ///
  /// Returns PDF document as bytes, ready to save or transmit.
  static Future<Uint8List> exportToPdf({
    required List<DiagramPrimitive>? primitives,
    required PdfPageFormat pageSize,
    DiagramSpace? space,
    double margin = 40.0,
    String? title,
    bool showGrid = false,
    double gridSpacing = 50.0,
  }) async {
    if (primitives == null) {
      throw ArgumentError.notNull('primitives');
    }
    if (primitives.isEmpty) {
      throw ArgumentError('primitives cannot be empty');
    }

    final pdf = pw.Document();

    // Calculate render area
    final renderWidth = pageSize.availableWidth - (2 * margin);
    final renderHeight = pageSize.availableHeight - (2 * margin);

    // Create coordinate mapper using shared logic
    final config = DiagramConfig(
      worldWidth: renderWidth,
      worldHeight: renderHeight,
      canvasWidth: renderWidth,
      canvasHeight: renderHeight,
      showGrid: showGrid,
      gridSpacing: gridSpacing,
    );

    final mapper = DefaultCoordinateMapper(config, space: space);

    // Sort primitives by zIndex
    final sortedPrimitives = List<DiagramPrimitive>.from(primitives)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    pdf.addPage(
      pw.Page(
        pageFormat: pageSize,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Primitives with optional grid
              pw.Positioned.fill(
                child: pw.CustomPaint(
                  size: PdfPoint(renderWidth, renderHeight),
                  painter: (canvas, size) {
                    // Draw grid if enabled
                    if (showGrid) {
                      _drawGrid(canvas, config, mapper, renderWidth, renderHeight);
                    }
                    // Render primitives
                    _renderPrimitivesToPdf(
                      canvas: canvas,
                      primitives: sortedPrimitives,
                      mapper: mapper,
                    );
                  },
                ),
              ),
              // Title if provided
              if (title != null)
                pw.Positioned(
                  left: margin,
                  top: margin - 20,
                  right: margin,
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Export diagram to PDF with multiple pages for large diagrams
  ///
  /// [primitives] - List of diagram primitives to render
  /// [pageSize] - Page dimensions in points
  /// [space] - DiagramSpace for coordinate transformation
  /// [tileSize] - Size of each tile/page in diagram units
  static Future<Uint8List> exportToPdfTiled({
    required List<DiagramPrimitive>? primitives,
    required PdfPageFormat pageSize,
    DiagramSpace? space,
    required double tileSize,
    double margin = 40.0,
    String? title,
  }) async {
    if (primitives == null) {
      throw ArgumentError.notNull('primitives');
    }

    final pdf = pw.Document();

    // Calculate render area per page
    final renderWidth = pageSize.availableWidth - (2 * margin);
    final renderHeight = pageSize.availableHeight - (2 * margin);

    // Calculate scale to fit tile size on page
    final scaleX = renderWidth / tileSize;
    final scaleY = renderHeight / tileSize;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // Create scaled space
    DiagramSpace? scaledSpace = space;
    if (space != null) {
      scaledSpace = DiagramSpace(
        baseScale: space.baseScale * scale,
        origin: space.origin,
        viewport: space.viewport,
      );
    }

    final config = DiagramConfig(
      worldWidth: renderWidth,
      worldHeight: renderHeight,
      canvasWidth: renderWidth,
      canvasHeight: renderHeight,
      showGrid: false,
      gridSpacing: 50.0,
    );

    final mapper = DefaultCoordinateMapper(config, space: scaledSpace);

    // Calculate number of tiles needed based on primitive bounds
    final bounds = _calculatePrimitiveBounds(primitives);
    if (bounds == null) {
      // No primitives to render
      return exportToPdf(
        primitives: primitives,
        pageSize: pageSize,
        space: space,
        margin: margin,
        title: title,
      );
    }

    final tilesX = ((bounds.maxX - bounds.minX) / tileSize).ceil() + 1;
    final tilesY = ((bounds.maxY - bounds.minY) / tileSize).ceil() + 1;

    final sortedPrimitives = List<DiagramPrimitive>.from(primitives)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    // Generate each tile as a page
    for (int ty = 0; ty < tilesY; ty++) {
      for (int tx = 0; tx < tilesX; tx++) {
        final offsetX = bounds.minX + (tx * tileSize);
        final offsetY = bounds.minY + (ty * tileSize);

        pdf.addPage(
          pw.Page(
            pageFormat: pageSize,
            build: (pw.Context context) {
              return pw.Stack(
                children: [
                  pw.Positioned.fill(
                    child: pw.CustomPaint(
                      size: PdfPoint(renderWidth, renderHeight),
                      painter: (canvas, size) {
                        // Translate to tile origin
                        canvas.saveContext();
                        canvas.setTransform(Matrix4.translationValues(
                          -offsetX * scale,
                          -offsetY * scale,
                          0,
                        ));
                        _renderPrimitivesToPdf(
                          canvas: canvas,
                          primitives: sortedPrimitives,
                          mapper: mapper,
                        );
                        canvas.restoreContext();
                      },
                    ),
                  ),
                  pw.Positioned(
                    left: margin,
                    bottom: margin - 15,
                    right: margin,
                    child: pw.Center(
                      child: pw.Text(
                        'Tile ${tx + 1},${ty + 1} of $tilesX x $tilesY${title != null ? ' - $title' : ''}',
                        style: const pw.SbTypography.caption,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }
    }

    return pdf.save();
  }

  /// Calculate bounding box of all primitives
  static _PrimitiveBounds? _calculatePrimitiveBounds(List<DiagramPrimitive> primitives) {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final primitive in primitives) {
      if (!primitive.visible) continue;

      if (primitive is DiagramLine) {
        minX = minX > primitive.start.dx ? primitive.start.dx : minX;
        minX = minX > primitive.end.dx ? primitive.end.dx : minX;
        minY = minY > primitive.start.dy ? primitive.start.dy : minY;
        minY = minY > primitive.end.dy ? primitive.end.dy : minY;
        maxX = maxX < primitive.start.dx ? primitive.start.dx : maxX;
        maxX = maxX < primitive.end.dx ? primitive.end.dx : maxX;
        maxY = maxY < primitive.start.dy ? primitive.start.dy : maxY;
        maxY = maxY < primitive.end.dy ? primitive.end.dy : maxY;
      } else if (primitive is DiagramRect) {
        minX = minX > primitive.position.dx ? primitive.position.dx : minX;
        minY = minY > primitive.position.dy ? primitive.position.dy : minY;
        maxX = maxX < (primitive.position.dx + primitive.width) 
            ? (primitive.position.dx + primitive.width) : maxX;
        maxY = maxY < (primitive.position.dy + primitive.height) 
            ? (primitive.position.dy + primitive.height) : maxY;
      } else if (primitive is DiagramText) {
        minX = minX > primitive.position.dx ? primitive.position.dx : minX;
        minY = minY > primitive.position.dy ? primitive.position.dy : minY;
        // Approximate text bounds
        maxX = maxX < (primitive.position.dx + 100) 
            ? (primitive.position.dx + 100) : maxX;
        maxY = maxY < (primitive.position.dy + primitive.fontSize) 
            ? (primitive.position.dy + primitive.fontSize) : maxY;
      }
    }

    if (minX == double.infinity) return null;

    return _PrimitiveBounds(minX, minY, maxX, maxY);
  }

  /// Draw grid lines
  static void _drawGrid(
    dynamic canvas,
    DiagramConfig config,
    CoordinateMapper mapper,
    double pageWidth,
    double pageHeight,
  ) {
    final spacing = config.gridSpacing * mapper.scale;
    if (spacing < 5) return;

    canvas.setStrokeColor(PdfColors.grey300);
    canvas.setLineWidth(0.5);

    // Calculate grid origin in canvas coordinates
    final origin = mapper.worldToCanvas(Offset.zero);

    // Vertical lines
    var x = origin.dx % spacing;
    while (x < pageWidth) {
      canvas.drawLine(x, 0, x, pageHeight);
      x += spacing;
    }
    canvas.strokePath();

    // Horizontal lines
    var y = origin.dy % spacing;
    while (y < pageHeight) {
      canvas.drawLine(0, y, pageWidth, y);
      y += spacing;
    }
    canvas.strokePath();
  }

  /// Render primitives to PDF canvas using shared coordinate system
  static void _renderPrimitivesToPdf({
    required dynamic canvas,
    required List<DiagramPrimitive> primitives,
    required CoordinateMapper mapper,
  }) {
    for (final primitive in primitives) {
      if (!primitive.visible) continue;

      if (primitive is DiagramLine) {
        _renderLineToPdf(canvas, primitive, mapper);
      } else if (primitive is DiagramRect) {
        _renderRectToPdf(canvas, primitive, mapper);
      } else if (primitive is DiagramText) {
        _renderTextToPdf(canvas, primitive, mapper);
      }
      // Note: Additional primitive types can be added as needed
    }
  }

  /// Render a DiagramLine to PDF
  static void _renderLineToPdf(
    dynamic canvas,
    DiagramLine line,
    CoordinateMapper mapper,
  ) {
    final start = mapper.worldToCanvas(line.start);
    final end = mapper.worldToCanvas(line.end);

    // PDF uses points, bottom-left origin
    final pdfColor = _toPdfColor(line.color);
    
    if (line.dashed) {
      // PDF doesn't have native dashed lines, draw segments
      _drawDashedLine(canvas, start, end, line.strokeWidth, pdfColor);
    } else {
      canvas.setStrokeColor(pdfColor);
      canvas.setLineWidth(line.strokeWidth);
      canvas.drawLine(start.dx, start.dy, end.dx, end.dy);
      canvas.strokePath();
    }
  }

  /// Render a DiagramRect to PDF
  static void _renderRectToPdf(
    dynamic canvas,
    DiagramRect rect,
    CoordinateMapper mapper,
  ) {
    final pos = mapper.worldToCanvas(rect.position);
    final size = mapper.worldToCanvasSize(Size(rect.width, rect.height));

    // Convert to PDF coordinate system (bottom-left origin)
    final pdfX = pos.dx;
    final pdfY = pos.dy;
    final pdfW = size.width;
    final pdfH = size.height;

    final pdfFillColor = _toPdfColor(rect.fillColor);
    final pdfStrokeColor = _toPdfColor(rect.strokeColor);

    // Draw fill if opaque
    if (rect.fillColor.alpha > 0) {
      canvas.setFillColor(pdfFillColor);
      if (rect.cornerRadius > 0) {
        canvas.drawRoundedRect(pdfX, pdfY, pdfW, pdfH, rect.cornerRadius * mapper.scale);
      } else {
        canvas.drawRect(pdfX, pdfY, pdfW, pdfH);
      }
      canvas.fillPath();
    }

    // Draw stroke if visible
    if (rect.strokeWidth > 0 && rect.strokeColor.alpha > 0) {
      canvas.setStrokeColor(pdfStrokeColor);
      canvas.setLineWidth(rect.strokeWidth * mapper.scale);
      if (rect.cornerRadius > 0) {
        canvas.drawRoundedRect(pdfX, pdfY, pdfW, pdfH, rect.cornerRadius * mapper.scale);
      } else {
        canvas.drawRect(pdfX, pdfY, pdfW, pdfH);
      }
      canvas.strokePath();
    }
  }

  /// Render a DiagramText to PDF
  static void _renderTextToPdf(
    dynamic canvas,
    DiagramText text,
    CoordinateMapper mapper,
  ) {
    final pos = mapper.worldToCanvas(text.position);
    final scaledFontSize = text.fontSize * mapper.scale;
    final pdfColor = _toPdfColor(text.color);

    canvas.setFillColor(pdfColor);
    
    // For PDF, we use drawString which draws from bottom-left
    // Need to offset for vertical alignment
    double textX = pos.dx;
    double textY = pos.dy;

    switch (text.alignMode) {
      case TextAlignMode.above:
        textY -= scaledFontSize + (4 * mapper.scale);
        break;
      case TextAlignMode.below:
        textY += 4 * mapper.scale;
        break;
      case TextAlignMode.center:
        // Center - no additional offset needed for baseline
        break;
    }

    canvas.drawString(
      _getPdfFont(text.fontFamily),
      scaledFontSize,
      text.text,
      textX,
      textY,
    );
  }

  /// Draw a dashed line segment by segment
  static void _drawDashedLine(
    dynamic canvas,
    Offset start,
    Offset end,
    double strokeWidth,
    PdfColor color,
  ) {
    const dashLength = 5.0;
    const gapLength = 3.0;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final squaredDistance = dx * dx + dy * dy;
    if (squaredDistance == 0) return;

    // Calculate total length (Euclidean distance)
    final totalLength = _sqrt(squaredDistance);
    if (totalLength <= 0) return;

    // Unit vector
    final unitX = dx / totalLength;
    final unitY = dy / totalLength;

    double currentX = start.dx;
    double currentY = start.dy;
    double drawn = 0.0;
    bool isDash = true;

    canvas.setStrokeColor(color);
    canvas.setLineWidth(strokeWidth);

    while (drawn < totalLength) {
      final segmentLength = isDash ? dashLength : gapLength;
      final remainingLength = totalLength - drawn;
      final actualLength = segmentLength > remainingLength ? remainingLength : segmentLength;
      
      if (actualLength <= 0) break;

      final nextX = currentX + unitX * actualLength;
      final nextY = currentY + unitY * actualLength;

      if (isDash) {
        canvas.drawLine(currentX, currentY, nextX, nextY);
        canvas.strokePath();
      }

      currentX = nextX;
      currentY = nextY;
      drawn += actualLength;
      isDash = !isDash;
    }
  }

  /// Fast sqrt approximation (faster than dart:math sqrt for comparison)
  static double _sqrt(double x) {
    if (x <= 0) return 0;
    // Initial guess
    double guess = x / 2;
    // Newton-Raphson iteration (2 iterations for good precision)
    guess = (guess + x / guess) / 2;
    guess = (guess + x / guess) / 2;
    return guess;
  }

  /// Convert Flutter Color to PDF Color
  static PdfColor _toPdfColor(Color color) {
    return PdfColor.fromInt(color.value);
  }

  /// Get PDF font by name
  static pw.Font _getPdfFont(String fontFamily) {
    switch (fontFamily.toLowerCase()) {
      case 'helvetica':
      case 'roboto':
        return pw.Font.helvetica();
      case 'times':
        return pw.Font.times();
      case 'courier':
        return pw.Font.courier();
      default:
        return pw.Font.helvetica();
    }
  }
}

/// Internal bounds calculation helper
class _PrimitiveBounds {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  _PrimitiveBounds(this.minX, this.minY, this.maxX, this.maxY);
}

/// Common PDF page formats with margins
class DiagramPdfPageFormat {
  DiagramPdfPageFormat._();

  /// A4 portrait with standard margins
  static PdfPageFormat a4({double margin = 40}) =>
      PdfPageFormat.a4.copyWith(
        marginTop: margin,
        marginBottom: margin,
        marginLeft: margin,
        marginRight: margin,
      );

  /// Letter portrait with standard margins
  static PdfPageFormat letter({double margin = 40}) =>
      PdfPageFormat.letter.copyWith(
        marginTop: margin,
        marginBottom: margin,
        marginLeft: margin,
        marginRight: margin,
      );

  /// Custom size with standard margins
  static PdfPageFormat custom(double width, double height, {double margin = 40}) =>
      PdfPageFormat(width, height).copyWith(
        marginTop: margin,
        marginBottom: margin,
        marginLeft: margin,
        marginRight: margin,
      );
}
