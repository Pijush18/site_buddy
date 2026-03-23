import 'dart:ui';
import '../primitives/primitives.dart' show DiagramPrimitive, DiagramText, DiagramLine, DiagramRect;
import '../primitives/path_primitives.dart' show DiagramTrapezoid, HatchPattern;
import '../dimension/dimension_annotation.dart';
import 'package:flutter/material.dart';

/// Canal cross-section data model
class CanalSection {
  final double bedWidth; // Bottom width
  final double topWidth; // Top width (calculated from side slopes)
  final double depth;
  final double sideSlope; // Horizontal:Vertical ratio (e.g., 1.5:1)
  final double flowDepth; // Current water depth
  final Color bedColor;
  final Color bankColor;
  final HatchPattern? hatch;

  const CanalSection({
    required this.bedWidth,
    required this.depth,
    required this.sideSlope,
    this.flowDepth = 0,
    this.bedColor = const Color(0xFF8D6E63),
    this.bankColor = const Color(0xFFFFEB3B),
    this.hatch,
  }) : topWidth = bedWidth + (depth * sideSlope * 2);

  double get sideSlopeLength {
    final horizontal = depth * sideSlope;
    final vertical = depth;
    return (horizontal * horizontal + vertical * vertical);
  }
}

/// Canal diagram adapter - REWRITTEN to use DiagramTrapezoid
/// FIXED: No more rectangle stacking - uses single trapezoid primitive
class CanalDiagramAdapter {
  /// Generate primitives for canal cross-section
  /// NOW USES: DiagramTrapezoid instead of 20 rectangle stripes
  List<DiagramPrimitive> createDiagram({
    required CanalSection section,
    required double centerX,
    required double groundY,
    double horizontalScale = 1.0,
    double verticalScale = 2.0,
  }) {
    final primitives = <DiagramPrimitive>[];
    int zIndex = 0;

    // Calculate positions with scale
    final bedY = groundY - (section.depth * verticalScale);
    final bedLeftX = centerX - (section.bedWidth * horizontalScale / 2);
    final bedRightX = centerX + (section.bedWidth * horizontalScale / 2);
    final topLeftX = bedLeftX - (section.depth * section.sideSlope * horizontalScale);
    final topRightX = bedRightX + (section.depth * section.sideSlope * horizontalScale);

    // === FIXED: Use single DiagramTrapezoid for canal cross-section ===
    primitives.add(DiagramTrapezoid(
      id: 'canal_section',
      bottomLeft: Offset(bedLeftX, bedY),
      bottomRight: Offset(bedRightX, bedY),
      topLeft: Offset(topLeftX, groundY),
      topRight: Offset(topRightX, groundY),
      fillColor: section.bedColor,
      strokeColor: const Color(0xFF3E2723),
      strokeWidth: 2.0,
      hatch: section.hatch,
      label: 'Canal Cross-Section',
      zIndex: zIndex++,
    ));

    // Left bank (embankment)
    primitives.add(DiagramRect(
      id: 'left_bank',
      position: Offset(topLeftX - 20, groundY),
      width: 20,
      height: section.depth * verticalScale,
      fillColor: section.bankColor,
      strokeColor: const Color(0xFF5D4037),
      strokeWidth: 1.0,
      label: 'Left Bank',
      zIndex: zIndex++,
    ));

    // Right bank (embankment)
    primitives.add(DiagramRect(
      id: 'right_bank',
      position: Offset(topRightX, groundY),
      width: 20,
      height: section.depth * verticalScale,
      fillColor: section.bankColor,
      strokeColor: const Color(0xFF5D4037),
      strokeWidth: 1.0,
      label: 'Right Bank',
      zIndex: zIndex++,
    ));

    // === Use DimensionAnnotation helper for dimensions ===
    final depthDim = DimensionAnnotation.vertical(
      start: Offset(bedLeftX, bedY),
      end: Offset(bedLeftX, groundY),
      label: 'D=${section.depth.toStringAsFixed(1)}m',
      offset: -30,
    );
    primitives.addAll(depthDim.toPrimitives('depth_dim', startZIndex: zIndex));
    zIndex += depthDim.toPrimitives('depth_dim').length;

    final widthDim = DimensionAnnotation.horizontal(
      start: Offset(bedLeftX, bedY),
      end: Offset(bedRightX, bedY),
      label: 'b=${section.bedWidth.toStringAsFixed(1)}m',
      offset: -15,
    );
    primitives.addAll(widthDim.toPrimitives('width_dim', startZIndex: zIndex));
    zIndex += widthDim.toPrimitives('width_dim').length;

    // Ground level
    primitives.add(DiagramLine(
      id: 'ground_level',
      start: Offset(topLeftX - 50, groundY),
      end: Offset(topRightX + 50, groundY),
      strokeWidth: 1.5,
      color: const Color(0xFF4CAF50),
      label: 'Ground Level',
      zIndex: zIndex++,
    ));

    // Water fill if flow depth specified
    if (section.flowDepth > 0) {
      final waterY = bedY + ((section.depth - section.flowDepth) * verticalScale);
      final waterLeftX = bedLeftX + ((section.depth - section.flowDepth) * section.sideSlope * horizontalScale);
      final waterRightX = bedRightX - ((section.depth - section.flowDepth) * section.sideSlope * horizontalScale);

      // Use DiagramTrapezoid for water
      primitives.add(DiagramTrapezoid(
        id: 'water_body',
        bottomLeft: Offset(bedLeftX, bedY),
        bottomRight: Offset(bedRightX, bedY),
        topLeft: Offset(waterLeftX, waterY),
        topRight: Offset(waterRightX, waterY),
        fillColor: const Color(0xFF4FC3F7).withValues(alpha: 0.6),
        strokeColor: const Color(0xFF0288D1),
        strokeWidth: 1.0,
        label: 'Water',
        zIndex: zIndex++,
      ));

      // Water level line
      primitives.add(DiagramLine(
        id: 'water_level',
        start: Offset(waterLeftX, waterY),
        end: Offset(waterRightX, waterY),
        strokeWidth: 1.0,
        color: const Color(0xFF0288D1),
        dashed: true,
        label: 'Water Level',
        zIndex: zIndex++,
      ));

      // Water level annotation
      final wlDim = DimensionAnnotation.vertical(
        start: Offset(waterLeftX, waterY),
        end: Offset(waterLeftX, groundY),
        label: 'FRL=${section.flowDepth.toStringAsFixed(1)}m',
        offset: -30,
      );
      primitives.addAll(wlDim.toPrimitives('wl_dim', startZIndex: zIndex));
      zIndex += wlDim.toPrimitives('wl_dim').length;
    }

    // Section title
    primitives.add(DiagramText(
      id: 'section_title',
      position: Offset(centerX, groundY + 40),
      text: 'Typical Cross-Section',
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF212121),
      textAlign: TextAlign.center,
      label: 'Section Title',
      zIndex: zIndex++,
    ));

    return primitives;
  }
}

/// Canal section templates
class CanalTemplates {
  static CanalSection rectangularCanal() => const CanalSection(
    bedWidth: 5.0,
    depth: 3.0,
    sideSlope: 0,
    flowDepth: 2.0,
    hatch: HatchPattern.soil,
  );

  static CanalSection trapezoidalCanal() => const CanalSection(
    bedWidth: 3.0,
    depth: 2.5,
    sideSlope: 1.5,
    flowDepth: 1.8,
    hatch: HatchPattern.soil,
  );

  static CanalSection linedCanal() => const CanalSection(
    bedWidth: 4.0,
    depth: 2.0,
    sideSlope: 1.0,
    flowDepth: 1.5,
    hatch: HatchPattern.concrete,
  );
}
