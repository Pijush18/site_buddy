import 'dart:ui';
import '../primitives/primitives.dart' show DiagramPrimitive, DiagramText, DiagramLine, DiagramRect;
import '../primitives/path_primitives.dart' show DiagramPath, HatchPattern;
import '../dimension/dimension_annotation.dart';
import 'package:flutter/material.dart';

/// Pavement layer data model with hatch support
class PavementLayer {
  final String material;
  final double thickness; // in mm
  final Color color;
  final HatchPattern? hatch;

  const PavementLayer({
    required this.material,
    required this.thickness,
    required this.color,
    this.hatch,
  });

  String get thicknessLabel => '${thickness.toInt()}mm';
}

/// Pavement diagram adapter - UPDATED with hatch patterns
class PavementDiagramAdapter {
  /// Generate primitives for pavement layers
  /// NOW USES: Hatch patterns for material differentiation
  List<DiagramPrimitive> createDiagram({
    required List<PavementLayer> layers,
    required double width,
    required double groundY,
    double scale = 0.1,
  }) {
    final primitives = <DiagramPrimitive>[];
    double currentY = groundY;
    int zIndex = 0;

    for (final layer in layers) {
      final layerHeight = layer.thickness * scale;

      // Layer rectangle with hatch pattern
      primitives.add(DiagramRect(
        id: 'layer_${layer.material.toLowerCase()}',
        position: Offset(0, currentY),
        width: width,
        height: layerHeight,
        fillColor: layer.color,
        strokeColor: const Color(0xFF424242),
        strokeWidth: 1.0,
        label: layer.material,
        zIndex: zIndex++,
      ));

      // If hatch is specified, add a hatch overlay (simplified)
      if (layer.hatch != null) {
        final hatchPath = Path()
          ..addRect(Rect.fromLTWH(0, currentY, width, layerHeight));
        primitives.add(DiagramPath(
          id: 'hatch_${layer.material.toLowerCase()}',
          path: hatchPath,
          strokeColor: layer.hatch!.color,
          strokeWidth: layer.hatch!.lineWidth * 0.5,
          hatch: layer.hatch,
          closed: true,
          zIndex: zIndex++,
        ));
      }

      // Material label (inside layer)
      primitives.add(DiagramText(
        id: 'label_${layer.material.toLowerCase()}',
        position: Offset(width / 2, currentY + layerHeight / 2),
        text: layer.material,
        fontSize: 12,
        color: _getContrastingTextColor(layer.color),
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.center,
        label: '${layer.material} label',
        zIndex: zIndex++,
      ));

      // Thickness dimension using helper
      final thicknessDim = DimensionAnnotation.vertical(
        start: Offset(width + 5, currentY),
        end: Offset(width + 5, currentY + layerHeight),
        label: layer.thicknessLabel,
        offset: 30,
      );
      primitives.addAll(thicknessDim.toPrimitives(
        'thickness_${layer.material.toLowerCase()}',
        startZIndex: zIndex,
      ));
      zIndex += thicknessDim.toPrimitives('thickness_${layer.material.toLowerCase()}').length;

      currentY += layerHeight;
    }

    // Ground level indicator
    primitives.add(DiagramLine(
      id: 'ground_level',
      start: Offset(0, groundY),
      end: Offset(width + 80, groundY),
      strokeWidth: 2.0,
      color: const Color(0xFF4CAF50),
      label: 'Ground Level',
      zIndex: zIndex++,
    ));

    return primitives;
  }

  Color _getContrastingTextColor(Color bgColor) {
    final luminance = (0.299 * bgColor.red + 0.587 * bgColor.green + 0.114 * bgColor.blue) / 255;
    return luminance > 0.5 ? const Color(0xFF212121) : const Color(0xFFFFFFFF);
  }
}

/// Pre-defined pavement layer templates with hatch patterns
class PavementTemplates {
  static List<PavementLayer> flexiblePavement() => [
    const PavementLayer(
      material: 'WMM',
      thickness: 150,
      color: Color(0xFFE57373),
      hatch: HatchPattern.rock,
    ),
    const PavementLayer(
      material: 'DBM',
      thickness: 50,
      color: Color(0xFFBA68C8),
      hatch: HatchPattern.diagonal,
    ),
    const PavementLayer(
      material: 'PMC',
      thickness: 25,
      color: Color(0xFF7986CB),
      hatch: HatchPattern.diagonal,
    ),
    const PavementLayer(
      material: 'GSB',
      thickness: 200,
      color: Color(0xFFFFB74D),
      hatch: HatchPattern.dots,
    ),
    const PavementLayer(
      material: 'Sub-Grade',
      thickness: 500,
      color: Color(0xFF81C784),
      hatch: HatchPattern.soil,
    ),
  ];

  static List<PavementLayer> rigidPavement() => [
    const PavementLayer(
      material: 'PQC',
      thickness: 300,
      color: Color(0xFF90A4AE),
      hatch: HatchPattern.concrete,
    ),
    const PavementLayer(
      material: 'DLC',
      thickness: 100,
      color: Color(0xFF78909C),
      hatch: HatchPattern.cross,
    ),
    const PavementLayer(
      material: 'GSB',
      thickness: 150,
      color: Color(0xFFFFB74D),
      hatch: HatchPattern.dots,
    ),
  ];
}
