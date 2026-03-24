import 'dart:typed_data';
import 'dart:ui';
import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/visualization/config/diagram_config.dart';

/// Export format types
enum ExportFormat {
  png,
  jpg,
  svg,
  pdf,
  dxf,
  dwg,
}

/// Export options
class ExportOptions {
  final double scale;
  final int? quality; // For jpg
  final bool includeBackground;
  final Rect? cropRegion;

  const ExportOptions({
    this.scale = 1.0,
    this.quality,
    this.includeBackground = true,
    this.cropRegion,
  });
}

/// Export result
class ExportResult {
  final Uint8List data;
  final String mimeType;
  final String format;

  const ExportResult({
    required this.data,
    required this.mimeType,
    required this.format,
  });
}

/// Exporter interface
abstract class DiagramExporter {
  /// Export to specified format
  Future<ExportResult> export(
    List<DiagramPrimitive> primitives,
    DiagramConfig config,
    ExportFormat format,
    ExportOptions options,
  );

  /// Export to file
  Future<void> exportToFile(
    List<DiagramPrimitive> primitives,
    DiagramConfig config,
    ExportFormat format,
    String filePath,
    ExportOptions options,
  );

  /// Get supported formats
  List<ExportFormat> getSupportedFormats();
}

/// Serialization format
enum SerializationFormat {
  json,
  yaml,
  xml,
}

/// Diagram serialization interface
abstract class DiagramSerializer {
  /// Serialize diagram to string
  String serialize(
    List<DiagramPrimitive> primitives,
    DiagramConfig config,
    SerializationFormat format,
  );

  /// Deserialize diagram from string
  (List<DiagramPrimitive>, DiagramConfig) deserialize(
    String data,
    SerializationFormat format,
  );

  /// Export to file
  Future<void> serializeToFile(
    List<DiagramPrimitive> primitives,
    DiagramConfig config,
    SerializationFormat format,
    String filePath,
  );
}
