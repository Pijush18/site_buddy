/// Engine interface for the SiteBuddy Diagram Engine
///
/// Engine Layer:
/// - primitives/
/// - coordinate_system/
/// - core/
/// - export/
/// - spatial/
/// - snapping/
///
/// App Layer:
/// - features/
/// - screens/
/// - controllers
///
/// Rules:
/// - No BuildContext
/// - No Flutter widgets
/// - No feature logic

library;

export 'primitives/primitives.dart'
    show DiagramPrimitive, DiagramLine, DiagramRect, DiagramText, DiagramGroup;
export 'primitives/polyline_primitive.dart' show DiagramPolyline;
export 'config/diagram_config.dart' show DiagramConfig;
export 'coordinate_system/diagram_space.dart' show DiagramSpace;
export 'export/diagram_exporter.dart' show ExportConfig;

import 'dart:typed_data';
import 'dart:ui';
import 'package:pdf/pdf.dart';
import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/visualization/config/diagram_config.dart';
import 'package:site_buddy/visualization/coordinate_system/diagram_space.dart';
import 'package:site_buddy/visualization/export/diagram_exporter.dart';
import 'package:site_buddy/visualization/export/pdf_diagram_renderer.dart';

class DiagramEngine {
  DiagramEngine._();

  static void render({
    required Canvas canvas,
    required Size size,
    required List<DiagramPrimitive> primitives,
    DiagramConfig? config,
    DiagramSpace? space,
  }) {
    renderDiagram(
      canvas: canvas,
      size: size,
      primitives: primitives,
      config: config ?? const DiagramConfig(),
      space: space,
    );
  }

  static Future<Uint8List> exportToPng({
    required List<DiagramPrimitive> primitives,
    required Size size,
    DiagramSpace? space,
    Color backgroundColor = const Color(0xFFFFFFFF),
    double pixelRatio = 1.0,
  }) {
    return DiagramExporter.exportToPng(
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

  static Future<Uint8List> exportToPdf({
    required List<DiagramPrimitive> primitives,
    required PdfPageFormat size,
    DiagramSpace? space,
    String? title,
    bool showGrid = false,
  }) {
    return PdfDiagramRenderer.exportToPdf(
      primitives: primitives,
      pageSize: size,
      space: space,
      title: title,
      showGrid: showGrid,
    );
  }
}
