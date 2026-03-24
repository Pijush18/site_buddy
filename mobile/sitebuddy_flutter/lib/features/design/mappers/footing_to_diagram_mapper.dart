// FILE HEADER
// ----------------------------------------------
// File: footing_to_diagram_mapper.dart
// Feature: design
// Layer: application/mappers
//
// PURPOSE:
// Transforms FootingDesignState (real engineering calculations)
// into DiagramPrimitives for rendering by the DiagramEngine.
//
// This mapper converts:
// - Footing geometry (length, width, thickness)
// - Column projection on footing
// - Reinforcement grid layout
// - Soil pressure distribution
//
// ----------------------------------------------

import 'dart:math' as math;
import 'dart:ui';

import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_state.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_type.dart';

/// MAPPER: FootingToDiagramMapper
/// PURPOSE: Convert FootingDesignState to diagram primitives for rendering.
class FootingToDiagramMapper {
  // Diagram dimensions (world units in mm)
  static const double diagramWidth = 600.0;
  static const double diagramHeight = 400.0;
  static const double footingScale = 0.06;

  // Colors
  static const Color concreteColor = Color(0xFFE0E0E0);
  static const Color concreteStroke = Color(0xFF424242);
  static const Color rebarColor = Color(0xFF2E7D32);
  static const Color columnColor = Color(0xFF757575);
  static const Color dimensionColor = Color(0xFF616161);
  static const Color labelColor = Color(0xFF212121);
  static const Color safeColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFD32F2F);
  static const Color soilPressureColor = Color(0xFF8D6E63);

  /// TRANSFORM: mapPlanView
  /// Creates plan view diagram primitives from footing state.
  static List<DiagramPrimitive> mapPlanView(FootingDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.footingLength <= 0 || state.footingWidth <= 0) {
      return primitives;
    }

    // Scale to fit in diagram
    final scale = footingScale;
    final length = state.footingLength * scale;
    final width = state.footingWidth * scale;

    // Center the footing in diagram
    final centerX = 200.0;
    final centerY = 200.0;
    final originX = centerX - length / 2;
    final originY = centerY - width / 2;

    // 1. Draw footing outline
    primitives.add(DiagramRect(
      id: 'footing_outline',
      position: Offset(originX, originY),
      width: length,
      height: width,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 2.0,
      zIndex: 1,
      label: 'Footing Plan',
    ));

    // 2. Draw column projection
    final colA = state.colA * scale;
    final colB = state.colB * scale;
    primitives.add(DiagramRect(
      id: 'column_projection',
      position: Offset(centerX - colA / 2, centerY - colB / 2),
      width: colA,
      height: colB,
      fillColor: columnColor.withValues(alpha: 0.3),
      strokeColor: concreteStroke,
      strokeWidth: 1.5,
      zIndex: 2,
      label: 'Column',
    ));

    // 3. Draw reinforcement grid (X direction - main bars)
    _drawRebarGridX(primitives, state, originX, originY, length, width);

    // 4. Draw reinforcement grid (Y direction - distribution bars)
    _drawRebarGridY(primitives, state, originX, originY, length, width);

    // 5. Add dimension labels
    _addFootingDimensions(primitives, state, originX, originY, length, width);

    // 6. Reinforcement info
    _addReinforcementInfo(primitives, state, originX, originY);

    return primitives;
  }

  static void _drawRebarGridX(
    List<DiagramPrimitive> primitives,
    FootingDesignState state,
    double originX,
    double originY,
    double length,
    double width,
  ) {
    final barSpacing = state.mainBarSpacing * footingScale;
    final barDia = state.mainBarDia * footingScale;
    final barRadius = math.max(2.0, barDia / 2);

    // Calculate number of bars
    final numBars = (length / barSpacing).floor();
    final coverOffset = 20.0 * footingScale;

    for (int i = 1; i < numBars; i++) {
      final x = originX + coverOffset + i * barSpacing;
      if (x > originX + length - coverOffset) break;

      primitives.add(DiagramLine(
        id: 'rebar_x_$i',
        start: Offset(x, originY + coverOffset),
        end: Offset(x, originY + width - coverOffset),
        strokeWidth: math.max(1.5, barRadius),
        color: rebarColor,
        zIndex: 3,
      ));
    }

    // Label
    primitives.add(DiagramText(
      id: 'rebar_x_label',
      position: Offset(originX + length + 30, originY + width / 2),
      text: 'X-X\n${state.mainBarSpacing.toInt()} mm',
      fontSize: 9,
      color: rebarColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));
  }

  static void _drawRebarGridY(
    List<DiagramPrimitive> primitives,
    FootingDesignState state,
    double originX,
    double originY,
    double length,
    double width,
  ) {
    final barSpacing = state.crossBarSpacing * footingScale;
    final barDia = state.crossBarDia * footingScale;
    final barRadius = math.max(2.0, barDia / 2);

    // Calculate number of bars
    final numBars = (width / barSpacing).floor();
    final coverOffset = 20.0 * footingScale;

    for (int i = 1; i < numBars; i++) {
      final y = originY + coverOffset + i * barSpacing;
      if (y > originY + width - coverOffset) break;

      primitives.add(DiagramLine(
        id: 'rebar_y_$i',
        start: Offset(originX + coverOffset, y),
        end: Offset(originX + length - coverOffset, y),
        strokeWidth: math.max(1.5, barRadius),
        color: rebarColor.withValues(alpha: 0.7),
        zIndex: 3,
      ));
    }

    // Label
    primitives.add(DiagramText(
      id: 'rebar_y_label',
      position: Offset(originX + length / 2, originY - 20),
      text: 'Y-Y\n${state.crossBarSpacing.toInt()} mm',
      fontSize: 9,
      color: rebarColor.withValues(alpha: 0.8),
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));
  }

  static void _addFootingDimensions(
    List<DiagramPrimitive> primitives,
    FootingDesignState state,
    double originX,
    double originY,
    double length,
    double width,
  ) {
    // Length dimension (L)
    final lengthDimY = originY + width + 30;
    primitives.add(DiagramLine(
      id: 'footing_length_dim',
      start: Offset(originX, lengthDimY),
      end: Offset(originX + length, lengthDimY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Ticks
    primitives.add(DiagramLine(
      id: 'footing_length_tick1',
      start: Offset(originX, lengthDimY - 4),
      end: Offset(originX, lengthDimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'footing_length_tick2',
      start: Offset(originX + length, lengthDimY - 4),
      end: Offset(originX + length, lengthDimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'footing_length_label',
      position: Offset(originX + length / 2, lengthDimY - 12),
      text: 'L = ${(state.footingLength / 1000).toStringAsFixed(2)} m',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // Width dimension (B)
    final widthDimX = originX + length + 25;
    primitives.add(DiagramLine(
      id: 'footing_width_dim',
      start: Offset(widthDimX, originY),
      end: Offset(widthDimX, originY + width),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Ticks
    primitives.add(DiagramLine(
      id: 'footing_width_tick1',
      start: Offset(widthDimX - 4, originY),
      end: Offset(widthDimX + 4, originY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'footing_width_tick2',
      start: Offset(widthDimX - 4, originY + width),
      end: Offset(widthDimX + 4, originY + width),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'footing_width_label',
      position: Offset(widthDimX + 8, originY + width / 2),
      text: 'B = ${(state.footingWidth / 1000).toStringAsFixed(2)} m',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));
  }

  static void _addReinforcementInfo(
    List<DiagramPrimitive> primitives,
    FootingDesignState state,
    double originX,
    double originY,
  ) {
    // Main reinforcement info
    primitives.add(DiagramText(
      id: 'main_rebar_info',
      position: Offset(originX + 10, originY + 15),
      text: 'Ast,X = ${state.astProvidedX.toInt()} mm²',
      fontSize: 9,
      color: rebarColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // Distribution reinforcement info
    primitives.add(DiagramText(
      id: 'dist_rebar_info',
      position: Offset(originX + 10, originY + 30),
      text: 'Ast,Y = ${state.astProvidedY.toInt()} mm²',
      fontSize: 9,
      color: rebarColor.withValues(alpha: 0.8),
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));
  }

  /// TRANSFORM: mapSectionView
  /// Creates section view diagram of footing.
  static List<DiagramPrimitive> mapSectionView(FootingDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.footingLength <= 0 || state.footingWidth <= 0) {
      return primitives;
    }

    final scale = footingScale;
    final thickness = state.footingThickness * scale * 0.3; // Exaggerate thickness for visibility

    // Center in diagram
    const originX = 50.0;
    const originY = 350.0;
    final length = state.footingLength * scale;
    final width = state.footingWidth * scale;

    // 1. Draw footing body (rectangle)
    primitives.add(DiagramRect(
      id: 'footing_section',
      position: Offset(originX, originY - thickness),
      width: length,
      height: thickness,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 2.0,
      zIndex: 1,
      label: 'Footing Section',
    ));

    // 2. Draw column above
    final colA = state.colA * scale;
    final colHeight = 60.0;
    primitives.add(DiagramRect(
      id: 'column_section',
      position: Offset(originX + length / 2 - colA / 2, originY - thickness - colHeight),
      width: colA,
      height: colHeight,
      fillColor: columnColor.withValues(alpha: 0.3),
      strokeColor: concreteStroke,
      strokeWidth: 1.5,
      zIndex: 2,
      label: 'Column',
    ));

    // 3. Draw reinforcement bars (cross-section)
    final barDia = state.mainBarDia * scale * 0.5;
    final barRadius = math.max(2.0, barDia / 2);

    // Top layer (X direction)
    final topY = originY - thickness + 5;
    final numBars = math.min(10, (length / (state.mainBarSpacing * scale)).floor());
    for (int i = 1; i <= numBars; i++) {
      final x = originX + (length / (numBars + 1)) * i;
      primitives.add(_createBarPrimitive(
        id: 'section_bar_x_$i',
        center: Offset(x, topY),
        radius: barRadius,
        zIndex: 3,
      ));
    }

    // Bottom layer (Y direction)
    final numBarsY = math.min(10, (width / (state.crossBarSpacing * scale)).floor());
    for (int i = 1; i <= numBarsY; i++) {
      final y = originY - thickness + thickness * (i / (numBarsY + 1));
      // Use short horizontal lines for Y bars
      primitives.add(DiagramLine(
        id: 'section_bar_y_$i',
        start: Offset(originX + 10, y),
        end: Offset(originX + length - 10, y),
        strokeWidth: math.max(1.0, barRadius),
        color: rebarColor.withValues(alpha: 0.7),
        zIndex: 3,
      ));
    }

    // 4. Dimension labels
    // Thickness
    primitives.add(DiagramText(
      id: 'thickness_label',
      position: Offset(originX - 25, originY - thickness / 2),
      text: 'D = ${state.footingThickness.toInt()} mm',
      fontSize: 9,
      color: labelColor,
      fontWeight: FontWeight.w500,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));

    // Section title
    primitives.add(DiagramText(
      id: 'section_title',
      position: Offset(originX + length / 2, originY - thickness - colHeight - 20),
      text: 'Section A-A',
      fontSize: 11,
      color: labelColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapSoilPressure
  /// Creates soil pressure distribution diagram.
  static List<DiagramPrimitive> mapSoilPressure(FootingDesignState state) {
    final primitives = <DiagramPrimitive>[];

    const originX = 50.0;
    const originY = 150.0;
    const width = 500.0;
    const height = 80.0;

    // 1. Draw base line
    primitives.add(const DiagramLine(
      id: 'pressure_base',
      start: Offset(originX, originY),
      end: Offset(originX + width, originY),
      strokeWidth: 1.5,
      color: dimensionColor,
      zIndex: 1,
    ));

    // 2. Calculate pressure values
    final maxPressure = state.maxSoilPressure;
    final minPressure = state.minSoilPressure;
    final scale = height / (maxPressure > 0 ? maxPressure : 1);

    // 3. Draw pressure distribution (trapezoidal)
    final p1 = originY;
    final p2 = originY - minPressure * scale;
    final p3 = originY - maxPressure * scale;

    // Left pressure line
    primitives.add(DiagramLine(
      id: 'pressure_left',
      start: Offset(originX, p1),
      end: Offset(originX, p2),
      strokeWidth: 2.0,
      color: soilPressureColor,
      zIndex: 2,
    ));

    // Top pressure line
    primitives.add(DiagramLine(
      id: 'pressure_top',
      start: Offset(originX, p2),
      end: Offset(originX + width, p3),
      strokeWidth: 2.0,
      color: soilPressureColor,
      zIndex: 2,
    ));

    // Right pressure line
    primitives.add(DiagramLine(
      id: 'pressure_right',
      start: Offset(originX + width, p3),
      end: Offset(originX + width, p1),
      strokeWidth: 2.0,
      color: soilPressureColor,
      zIndex: 2,
    ));

    // Fill area
    primitives.add(DiagramRect(
      id: 'pressure_fill',
      position: Offset(originX, math.min(p1, math.min(p2, p3))),
      width: width,
      height: math.max(p1 - p2, p1 - p3),
      fillColor: soilPressureColor.withValues(alpha: 0.15),
      strokeColor: const Color(0x00000000),
      strokeWidth: 0,
      zIndex: 1,
    ));

    // 4. Labels
    primitives.add(DiagramText(
      id: 'max_pressure_label',
      position: Offset(originX + width - 50, p3 - 15),
      text: 'qmax = ${maxPressure.toStringAsFixed(1)} kN/m²',
      fontSize: 9,
      color: soilPressureColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    primitives.add(DiagramText(
      id: 'min_pressure_label',
      position: Offset(originX + 10, p2 - 15),
      text: 'qmin = ${minPressure.toStringAsFixed(1)} kN/m²',
      fontSize: 9,
      color: soilPressureColor.withValues(alpha: 0.8),
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // Title
    primitives.add(const DiagramText(
      id: 'pressure_title',
      position: Offset(originX + width / 2, originY - height - 15),
      text: 'Soil Pressure Distribution',
      fontSize: 11,
      color: labelColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    // SBC comparison
    final isSafe = maxPressure <= state.sbc;
    primitives.add(DiagramText(
      id: 'sbc_comparison',
      position: const Offset(originX + width / 2, originY + 20),
      text: 'qmax (${maxPressure.toStringAsFixed(1)}) ${isSafe ? '≤' : '>'} SBC (${state.sbc.toStringAsFixed(0)})',
      fontSize: 9,
      color: isSafe ? safeColor : warningColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapComplete
  /// Creates complete footing diagram with all elements.
  static List<DiagramPrimitive> mapComplete(FootingDesignState state) {
    final primitives = <DiagramPrimitive>[];

    // Add title
    primitives.add(DiagramText(
      id: 'footing_title',
      position: const Offset(50, 30),
      text: '${_getFootingTypeLabel(state.type)} Footing: ${(state.footingLength / 1000).toStringAsFixed(2)}x${(state.footingWidth / 1000).toStringAsFixed(2)} m',
      fontSize: 14,
      color: labelColor,
      fontWeight: FontWeight.w700,
      zIndex: 20,
    ));

    // Add plan view
    primitives.addAll(mapPlanView(state));

    // Add soil pressure (positioned below)
    primitives.addAll(_offsetPrimitives(mapSoilPressure(state), 0.0, 250.0));

    return primitives;
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  static String _getFootingTypeLabel(FootingType type) {
    switch (type) {
      case FootingType.isolated:
        return 'Isolated';
      case FootingType.combined:
        return 'Combined';
      case FootingType.strap:
        return 'Strap';
      case FootingType.strip:
        return 'Strip';
      case FootingType.raft:
        return 'Raft';
      case FootingType.pile:
        return 'Pile';
    }
  }

  static DiagramGroup _createBarPrimitive({
    required String id,
    required Offset center,
    required double radius,
    required int zIndex,
    String? label,
  }) {
    return DiagramGroup(
      id: id,
      children: [
        DiagramRect(
          id: '${id}_fill',
          position: Offset(center.dx - radius, center.dy - radius),
          width: radius * 2,
          height: radius * 2,
          fillColor: rebarColor,
          strokeColor: rebarColor,
          strokeWidth: 1.0,
          cornerRadius: radius,
          zIndex: zIndex,
        ),
      ],
      zIndex: zIndex,
      label: label,
    );
  }

  static List<DiagramPrimitive> _offsetPrimitives(
    List<DiagramPrimitive> primitives,
    double offsetX,
    double offsetY,
  ) {
    return primitives.map((p) {
      if (p is DiagramLine) {
        return p.copyWith(
          start: p.start + Offset(offsetX, offsetY),
          end: p.end + Offset(offsetX, offsetY),
        );
      } else if (p is DiagramRect) {
        return p.copyWith(
          position: p.position + Offset(offsetX, offsetY),
        );
      } else if (p is DiagramText) {
        return p.copyWith(
          position: p.position + Offset(offsetX, offsetY),
        );
      } else if (p is DiagramGroup) {
        return p.copyWith(
          translation: p.translation + Offset(offsetX, offsetY),
        );
      }
      return p;
    }).toList();
  }
}
