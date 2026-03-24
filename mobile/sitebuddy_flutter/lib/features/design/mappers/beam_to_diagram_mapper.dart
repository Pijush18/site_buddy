// FILE HEADER
// ----------------------------------------------
// File: beam_to_diagram_mapper.dart
// Feature: design
// Layer: application/mappers
//
// PURPOSE:
// Transforms BeamDesignState (real engineering calculations)
// into DiagramPrimitives for rendering by the DiagramEngine.
//
// This mapper converts:
// - Beam geometry (width, depth, span)
// - Reinforcement details (main bars, stirrups)
// - Analysis results (SFD, BMD points)
//
// ----------------------------------------------

import 'dart:math' as math;
import 'dart:ui';

import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';

/// MAPPER: BeamToDiagramMapper
/// PURPOSE: Convert BeamDesignState to diagram primitives for rendering.
class BeamToDiagramMapper {
  // Diagram dimensions (world units in mm)
  static const double diagramWidth = 600.0;
  static const double diagramHeight = 400.0;
  static const double beamScale = 0.15; // Scale factor for beam visualization

  // Colors
  static const Color concreteColor = Color(0xFFE0E0E0);
  static const Color concreteStroke = Color(0xFF424242);
  static const Color rebarColor = Color(0xFF1565C0);
  static const Color rebarSecondaryColor = Color(0xFF90CAF9);
  static const Color stirrupColor = Color(0xFF757575);
  static const Color dimensionColor = Color(0xFF616161);
  static const Color labelColor = Color(0xFF212121);
  static const Color safeColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFD32F2F);

  /// TRANSFORM: mapCrossSection
  /// Creates cross-section diagram primitives from beam state.
  static List<DiagramPrimitive> mapCrossSection(BeamDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.width <= 0 || state.overallDepth <= 0) {
      return primitives;
    }

    // Calculate scaling
    final beamWidth = state.width * beamScale;
    final beamDepth = state.overallDepth * beamScale;

    // Origin point (center-left of diagram)
    const originX = 80.0;
    const originY = 300.0;

    // 1. Draw concrete cross-section outline
    primitives.add(DiagramRect(
      id: 'beam_concrete_outline',
      position: Offset(originX, originY - beamDepth),
      width: beamWidth,
      height: beamDepth,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 2.0,
      zIndex: 1,
      label: 'Concrete Section',
    ));

    // 2. Draw stirrup outline (cover region)
    final coverOffset = state.cover * beamScale;
    primitives.add(DiagramRect(
      id: 'beam_stirrup_outline',
      position: Offset(originX + coverOffset, originY - beamDepth + coverOffset),
      width: beamWidth - 2 * coverOffset,
      height: beamDepth - 2 * coverOffset,
      fillColor: const Color(0x00000000),
      strokeColor: stirrupColor.withValues(alpha: 0.5),
      strokeWidth: 1.0,
      zIndex: 2,
      label: 'Stirrup Region',
    ));

    // 3. Draw main reinforcement bars (bottom)
    final tensionY = originY - coverOffset - 5;
    final barRadius = math.max(3.0, (state.mainBarDia * beamScale) / 2);

    if (state.numBars > 0) {
      final spacing = (beamWidth - 2 * coverOffset - 10) / (state.numBars + 1);

      for (int i = 1; i <= state.numBars; i++) {
        final barX = originX + coverOffset + 5 + i * spacing;

        // Draw bar as circle
        primitives.add(_createCirclePrimitive(
          id: 'main_bar_$i',
          center: Offset(barX, tensionY),
          radius: barRadius,
          fillColor: rebarColor,
          strokeColor: rebarColor,
          zIndex: 3,
          label: 'Main Bar ${state.mainBarDia.toInt()}mm',
        ));

        // Bar label
        if (i == 1) {
          primitives.add(DiagramText(
            id: 'main_bar_label',
            position: Offset(barX, tensionY + barRadius + 8),
            text: '${state.numBars}Ø${state.mainBarDia.toInt()}',
            fontSize: 9,
            color: labelColor,
            fontWeight: FontWeight.w500,
            alignMode: TextAlignMode.above,
            zIndex: 10,
          ));
        }
      }
    }

    // 4. Draw hanger bars (top - minimum 2)
    final hangerY = originY - beamDepth + coverOffset + 5;
    final hangerRadius = math.max(3.0, (10.0 * beamScale) / 2);

    // Left hanger
    primitives.add(_createCirclePrimitive(
      id: 'hanger_bar_left',
      center: Offset(originX + coverOffset + 5, hangerY),
      radius: hangerRadius,
      fillColor: rebarSecondaryColor,
      strokeColor: rebarSecondaryColor,
      zIndex: 3,
      label: 'Hanger Bar',
    ));

    // Right hanger
    primitives.add(_createCirclePrimitive(
      id: 'hanger_bar_right',
      center: Offset(originX + beamWidth - coverOffset - 5, hangerY),
      radius: hangerRadius,
      fillColor: rebarSecondaryColor,
      strokeColor: rebarSecondaryColor,
      zIndex: 3,
      label: 'Hanger Bar',
    ));

    // 5. Dimension labels
    _addDimensionLabels(primitives, state, originX, originY, beamWidth, beamDepth);

    return primitives;
  }

  /// TRANSFORM: mapSFD
  /// Creates Shear Force Diagram from analysis points.
  static List<DiagramPrimitive> mapSFD(BeamDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.sfdPoints.isEmpty || state.span <= 0) {
      return _createEmptyDiagramPlaceholder(
        primitives,
        'Shear Force Diagram',
        'SFD',
        'No analysis data',
      );
    }

    const originX = 50.0;
    const originY = 200.0;
    const diagramWidth = 500.0;
    const diagramHeight = 100.0;

    // 1. Draw axis
    primitives.add(const DiagramLine(
      id: 'sfd_axis',
      start: Offset(originX, originY),
      end: Offset(originX + diagramWidth, originY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 1,
    ));

    // 2. Scale calculations
    final span = state.sfdPoints.last.x;
    final maxShear = state.sfdPoints.fold(
      0.0,
      (max, p) => p.value.abs() > max ? p.value.abs() : max,
    );
    if (maxShear == 0) return primitives;

    final xScale = diagramWidth / span;
    final yScale = (diagramHeight / 2) / maxShear;

    // 3. Draw SFD curve
    final pathPrimitives = <DiagramLine>[];
    for (int i = 0; i < state.sfdPoints.length - 1; i++) {
      final p1 = state.sfdPoints[i];
      final p2 = state.sfdPoints[i + 1];

      final x1 = originX + p1.x * xScale;
      final y1 = originY - p1.value * yScale;
      final x2 = originX + p2.x * xScale;
      final y2 = originY - p2.value * yScale;

      pathPrimitives.add(DiagramLine(
        id: 'sfd_segment_$i',
        start: Offset(x1, y1),
        end: Offset(x2, y2),
        strokeWidth: 2.0,
        color: warningColor,
        zIndex: 2,
      ));
    }
    primitives.addAll(pathPrimitives);

    // 4. Fill area under curve
    primitives.add(DiagramGroup(
      id: 'sfd_fill',
      children: [
        DiagramRect(
          id: 'sfd_fill_area',
          position: const Offset(originX, originY),
          width: diagramWidth,
          height: 0,
          fillColor: warningColor.withValues(alpha: 0.1),
          strokeColor: const Color(0x00000000),
          strokeWidth: 0,
          zIndex: 1,
        ),
      ],
      zIndex: 1,
    ));

    // 5. Labels
    primitives.add(const DiagramText(
      id: 'sfd_title',
      position: Offset(originX, originY - diagramHeight - 15),
      text: 'SFD (Shear Force Diagram)',
      fontSize: 11,
      color: labelColor,
      fontWeight: FontWeight.w600,
      zIndex: 10,
    ));

    // Max shear value
    final maxVu = state.vu;
    primitives.add(DiagramText(
      id: 'sfd_max',
      position: const Offset(originX + diagramWidth - 60, originY - diagramHeight / 2),
      text: 'Vu = ${maxVu.toStringAsFixed(1)} kN',
      fontSize: 9,
      color: warningColor,
      fontWeight: FontWeight.w500,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapBMD
  /// Creates Bending Moment Diagram from analysis points.
  static List<DiagramPrimitive> mapBMD(BeamDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.bmdPoints.isEmpty || state.span <= 0) {
      return _createEmptyDiagramPlaceholder(
        primitives,
        'Bending Moment Diagram',
        'BMD',
        'No analysis data',
      );
    }

    const originX = 50.0;
    const originY = 100.0;
    const diagramWidth = 500.0;
    const diagramHeight = 150.0;

    // 1. Draw axis
    primitives.add(const DiagramLine(
      id: 'bmd_axis',
      start: Offset(originX, originY),
      end: Offset(originX + diagramWidth, originY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 1,
    ));

    // 2. Scale calculations
    final span = state.bmdPoints.last.x;
    final maxMoment = state.bmdPoints.fold(
      0.0,
      (max, p) => p.value.abs() > max ? p.value.abs() : max,
    );
    if (maxMoment == 0) return primitives;

    final xScale = diagramWidth / span;
    final yScale = (diagramHeight / 2) / maxMoment;

    // 3. Draw BMD curve
    for (int i = 0; i < state.bmdPoints.length - 1; i++) {
      final p1 = state.bmdPoints[i];
      final p2 = state.bmdPoints[i + 1];

      final x1 = originX + p1.x * xScale;
      final y1 = originY - p1.value * yScale;
      final x2 = originX + p2.x * xScale;
      final y2 = originY - p2.value * yScale;

      primitives.add(DiagramLine(
        id: 'bmd_segment_$i',
        start: Offset(x1, y1),
        end: Offset(x2, y2),
        strokeWidth: 2.5,
        color: rebarColor,
        zIndex: 2,
      ));
    }

    // 4. Labels
    primitives.add(const DiagramText(
      id: 'bmd_title',
      position: Offset(originX, originY - diagramHeight - 15),
      text: 'BMD (Bending Moment Diagram)',
      fontSize: 11,
      color: labelColor,
      fontWeight: FontWeight.w600,
      zIndex: 10,
    ));

    // Max moment value
    final maxMu = state.mu;
    primitives.add(DiagramText(
      id: 'bmd_max',
      position: const Offset(originX + diagramWidth / 2, originY - diagramHeight + 10),
      text: 'Mu = ${maxMu.toStringAsFixed(1)} kNm',
      fontSize: 9,
      color: rebarColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.above,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapStirrupDetail
  /// Creates stirrup spacing detail visualization.
  static List<DiagramPrimitive> mapStirrupDetail(BeamDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.width <= 0 || state.overallDepth <= 0) {
      return primitives;
    }

    const originX = 50.0;
    const originY = 320.0;
    final beamWidth = state.width * beamScale;
    final beamDepth = state.overallDepth * beamScale;

    // 1. Draw beam outline (simplified)
    primitives.add(DiagramRect(
      id: 'stirrup_beam_outline',
      position: Offset(originX, originY - beamDepth),
      width: beamWidth,
      height: beamDepth,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 1.5,
      zIndex: 1,
    ));

    // 2. Draw stirrups at regular intervals
    final coverOffset = state.cover * beamScale;
    final spacing = state.stirrupSpacing * beamScale;

    // Draw 5 stirrups to show pattern
    const numStirrups = 5;
    for (int i = 0; i < numStirrups; i++) {
      final x = originX + coverOffset + i * spacing;

      if (x + spacing > originX + beamWidth - coverOffset) break;

      // Vertical stirrup line
      primitives.add(DiagramLine(
        id: 'stirrup_$i',
        start: Offset(x, originY - coverOffset),
        end: Offset(x, originY - beamDepth + coverOffset),
        strokeWidth: 1.5,
        color: stirrupColor,
        zIndex: 2,
      ));
    }

    // 3. Spacing dimension
    final dimStartX = originX + coverOffset;
    final dimEndX = dimStartX + spacing;
    const dimY = originY + 30;

    primitives.add(DiagramLine(
      id: 'spacing_dim_line',
      start: Offset(dimStartX, dimY),
      end: Offset(dimEndX, dimY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 3,
    ));

    // Dimension arrows
    primitives.add(DiagramLine(
      id: 'spacing_dim_arrow1',
      start: Offset(dimStartX, dimY - 4),
      end: Offset(dimStartX, dimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 3,
    ));
    primitives.add(DiagramLine(
      id: 'spacing_dim_arrow2',
      start: Offset(dimEndX, dimY - 4),
      end: Offset(dimEndX, dimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 3,
    ));

    // Spacing label
    primitives.add(DiagramText(
      id: 'spacing_label',
      position: Offset((dimStartX + dimEndX) / 2, dimY - 10),
      text: '@ ${state.stirrupSpacing.toInt()} mm c/c',
      fontSize: 9,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // 4. Legend
    primitives.add(DiagramText(
      id: 'stirrup_legend',
      position: Offset(dimEndX + 30, originY - beamDepth / 2),
      text: 'Ø${state.stirrupDia} ${state.stirrupLegs}L',
      fontSize: 9,
      color: stirrupColor,
      fontWeight: FontWeight.w500,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapComplete
  /// Creates complete beam diagram with all elements.
  static List<DiagramPrimitive> mapComplete(BeamDesignState state) {
    final primitives = <DiagramPrimitive>[];

    primitives.addAll(mapBMD(state));
    primitives.addAll(mapCrossSection(state));
    primitives.addAll(mapStirrupDetail(state));

    // Add section title
    primitives.add(DiagramText(
      id: 'beam_section_title',
      position: const Offset(50, 30),
      text: 'Beam Design: ${state.width.toInt()}x${state.overallDepth.toInt()} mm',
      fontSize: 14,
      color: labelColor,
      fontWeight: FontWeight.w700,
      zIndex: 20,
    ));

    return primitives;
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  static void _addDimensionLabels(
    List<DiagramPrimitive> primitives,
    BeamDesignState state,
    double originX,
    double originY,
    double beamWidth,
    double beamDepth,
  ) {
    // Width dimension (b)
    final widthLabelY = originY + 25;
    primitives.add(DiagramLine(
      id: 'width_dim_line',
      start: Offset(originX, widthLabelY),
      end: Offset(originX + beamWidth, widthLabelY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Width dimension ticks
    primitives.add(DiagramLine(
      id: 'width_dim_tick1',
      start: Offset(originX, widthLabelY - 4),
      end: Offset(originX, widthLabelY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'width_dim_tick2',
      start: Offset(originX + beamWidth, widthLabelY - 4),
      end: Offset(originX + beamWidth, widthLabelY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'width_label',
      position: Offset(originX + beamWidth / 2, widthLabelY - 12),
      text: 'b = ${state.width.toInt()} mm',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // Depth dimension (D)
    final depthLabelX = originX + beamWidth + 20;
    primitives.add(DiagramLine(
      id: 'depth_dim_line',
      start: Offset(depthLabelX, originY),
      end: Offset(depthLabelX, originY - beamDepth),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Depth dimension ticks
    primitives.add(DiagramLine(
      id: 'depth_dim_tick1',
      start: Offset(depthLabelX - 4, originY),
      end: Offset(depthLabelX + 4, originY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'depth_dim_tick2',
      start: Offset(depthLabelX - 4, originY - beamDepth),
      end: Offset(depthLabelX + 4, originY - beamDepth),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'depth_label',
      position: Offset(depthLabelX + 8, originY - beamDepth / 2),
      text: 'D = ${state.overallDepth.toInt()} mm',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));
  }

  static List<DiagramPrimitive> _createEmptyDiagramPlaceholder(
    List<DiagramPrimitive> primitives,
    String title,
    String abbrev,
    String message,
  ) {
    const originX = 50.0;
    const originY = 100.0;
    const width = 500.0;
    const height = 100.0;

    // Draw placeholder rectangle
    primitives.add(DiagramRect(
      id: '${abbrev.toLowerCase()}_placeholder',
      position: const Offset(originX, originY - height),
      width: width,
      height: height,
      fillColor: const Color(0xFFF5F5F5),
      strokeColor: const Color(0xFFBDBDBD),
      strokeWidth: 1.0,
      zIndex: 1,
    ));

    // Add title
    primitives.add(DiagramText(
      id: '${abbrev.toLowerCase()}_placeholder_title',
      position: const Offset(originX + width / 2, originY - height / 2),
      text: message,
      fontSize: 11,
      color: const Color(0xFF9E9E9E),
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  static DiagramGroup _createCirclePrimitive({
    required String id,
    required Offset center,
    required double radius,
    required Color fillColor,
    required Color strokeColor,
    required int zIndex,
    String? label,
  }) {
    // Create a group containing a rect that approximates a circle
    // The engine uses rectangles, so we use a small rect for the bar representation
    return DiagramGroup(
      id: id,
      children: [
        DiagramRect(
          id: '${id}_fill',
          position: Offset(center.dx - radius, center.dy - radius),
          width: radius * 2,
          height: radius * 2,
          fillColor: fillColor,
          strokeColor: strokeColor,
          strokeWidth: 1.0,
          cornerRadius: radius,
          zIndex: zIndex,
        ),
      ],
      zIndex: zIndex,
      label: label,
    );
  }
}
