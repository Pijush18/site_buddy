// FILE HEADER
// ----------------------------------------------
// File: column_to_diagram_mapper.dart
// Feature: design
// Layer: application/mappers
//
// PURPOSE:
// Transforms ColumnDesignState (real engineering calculations)
// into DiagramPrimitives for rendering by the DiagramEngine.
//
// This mapper converts:
// - Column geometry (b x D, circular/rectangular)
// - Reinforcement details (bars, ties)
// - Interaction diagram data
// - Slenderness visualization
//
// ----------------------------------------------

import 'dart:math' as math;
import 'dart:ui';

import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_state.dart';
import 'package:site_buddy/features/structural/column/domain/column_enums.dart';

/// MAPPER: ColumnToDiagramMapper
/// PURPOSE: Convert ColumnDesignState to diagram primitives for rendering.
class ColumnToDiagramMapper {
  // Diagram dimensions (world units in mm)
  static const double diagramWidth = 600.0;
  static const double diagramHeight = 400.0;
  static const double columnScale = 0.12;

  // Colors
  static const Color concreteColor = Color(0xFFE0E0E0);
  static const Color concreteStroke = Color(0xFF424242);
  static const Color rebarColor = Color(0xFFD84315);
  static const Color tieColor = Color(0xFF757575);
  static const Color dimensionColor = Color(0xFF616161);
  static const Color labelColor = Color(0xFF212121);
  static const Color safeColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFD32F2F);
  static const Color interactionCurveColor = Color(0xFF1565C0);
  static const Color designPointColor = Color(0xFFFF5722);

  /// TRANSFORM: mapCrossSection
  /// Creates cross-section diagram primitives from column state.
  static List<DiagramPrimitive> mapCrossSection(ColumnDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.b <= 0 || state.d <= 0) {
      return primitives;
    }

    final centerX = 180.0;
    final centerY = 200.0;

    if (state.type == ColumnType.circular) {
      primitives.addAll(_mapCircularSection(state, centerX, centerY));
    } else {
      primitives.addAll(_mapRectangularSection(state, centerX, centerY));
    }

    // Add dimension labels
    _addColumnDimensions(primitives, state, centerX, centerY);

    return primitives;
  }

  static List<DiagramPrimitive> _mapRectangularSection(
    ColumnDesignState state,
    double centerX,
    double centerY,
  ) {
    final primitives = <DiagramPrimitive>[];
    final scale = columnScale;
    final b = state.b * scale;
    final d = state.d * scale;
    final cover = state.cover * scale;
    final barDia = state.mainBarDia * scale;

    // 1. Draw column outline
    primitives.add(DiagramRect(
      id: 'column_outline',
      position: Offset(centerX - b / 2, centerY - d / 2),
      width: b,
      height: d,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 2.0,
      zIndex: 1,
      label: 'Column Section',
    ));

    // 2. Draw tie/lateral reinforcement outline
    primitives.add(DiagramRect(
      id: 'column_tie_outline',
      position: Offset(centerX - b / 2 + cover, centerY - d / 2 + cover),
      width: b - 2 * cover,
      height: d - 2 * cover,
      fillColor: const Color(0x00000000),
      strokeColor: tieColor.withValues(alpha: 0.5),
      strokeWidth: 1.0,
      zIndex: 2,
    ));

    // 3. Draw reinforcement bars
    _drawRectangularBars(primitives, state, centerX, centerY, b, d, cover, barDia);

    return primitives;
  }

  static void _drawRectangularBars(
    List<DiagramPrimitive> primitives,
    ColumnDesignState state,
    double centerX,
    double centerY,
    double b,
    double d,
    double cover,
    double barDia,
  ) {
    final numBars = state.numBars;
    final barRadius = barDia / 2;

    if (numBars < 4) {
      // Place 4 corner bars minimum
      final positions = [
        Offset(centerX - b / 2 + cover + barRadius, centerY - d / 2 + cover + barRadius),
        Offset(centerX + b / 2 - cover - barRadius, centerY - d / 2 + cover + barRadius),
        Offset(centerX - b / 2 + cover + barRadius, centerY + d / 2 - cover - barRadius),
        Offset(centerX + b / 2 - cover - barRadius, centerY + d / 2 - cover - barRadius),
      ];

      for (int i = 0; i < 4; i++) {
        primitives.add(_createBarPrimitive(
          id: 'corner_bar_$i',
          center: positions[i],
          radius: math.max(3.0, barRadius),
          zIndex: 3,
          label: 'Corner Bar',
        ));
      }
    } else {
      // Place corner bars
      final cornerPositions = [
        Offset(centerX - b / 2 + cover + barRadius, centerY - d / 2 + cover + barRadius),
        Offset(centerX + b / 2 - cover - barRadius, centerY - d / 2 + cover + barRadius),
        Offset(centerX - b / 2 + cover + barRadius, centerY + d / 2 - cover - barRadius),
        Offset(centerX + b / 2 - cover - barRadius, centerY + d / 2 - cover - barRadius),
      ];

      for (int i = 0; i < 4; i++) {
        primitives.add(_createBarPrimitive(
          id: 'corner_bar_$i',
          center: cornerPositions[i],
          radius: math.max(3.0, barRadius),
          zIndex: 3,
          label: 'Corner Bar',
        ));
      }

      // Distribute remaining bars on sides
      final remainingBars = numBars - 4;
      final sideBars = (remainingBars / 2).floor();
      final innerWidth = b - 2 * cover - 2 * barRadius;

      for (int i = 1; i <= sideBars; i++) {
        final t = i / (sideBars + 1);

        // Top side
        primitives.add(_createBarPrimitive(
          id: 'side_bar_top_$i',
          center: Offset(
            centerX - b / 2 + cover + barRadius + innerWidth * t,
            centerY - d / 2 + cover + barRadius,
          ),
          radius: math.max(3.0, barRadius),
          zIndex: 3,
          label: 'Side Bar',
        ));

        // Bottom side
        primitives.add(_createBarPrimitive(
          id: 'side_bar_bottom_$i',
          center: Offset(
            centerX - b / 2 + cover + barRadius + innerWidth * t,
            centerY + d / 2 - cover - barRadius,
          ),
          radius: math.max(3.0, barRadius),
          zIndex: 3,
          label: 'Side Bar',
        ));
      }
    }
  }

  static List<DiagramPrimitive> _mapCircularSection(
    ColumnDesignState state,
    double centerX,
    double centerY,
  ) {
    final primitives = <DiagramPrimitive>[];
    final scale = columnScale;
    final radius = (state.b / 2) * scale; // b is diameter for circular
    final cover = state.cover * scale;
    final barDia = state.mainBarDia * scale;
    final barRadius = math.max(3.0, barDia / 2);

    // 1. Draw column outline (using rectangle approximation for circle)
    // For circular, we use a square section of size = diameter
    final diameter = radius * 2;
    primitives.add(DiagramRect(
      id: 'column_outline',
      position: Offset(centerX - radius, centerY - radius),
      width: diameter,
      height: diameter,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 2.0,
      cornerRadius: radius,
      zIndex: 1,
      label: 'Circular Column',
    ));

    // 2. Draw tie outline
    primitives.add(DiagramRect(
      id: 'column_tie_outline',
      position: Offset(centerX - radius + cover, centerY - radius + cover),
      width: diameter - 2 * cover,
      height: diameter - 2 * cover,
      fillColor: const Color(0x00000000),
      strokeColor: tieColor.withValues(alpha: 0.5),
      strokeWidth: 1.0,
      cornerRadius: radius - cover,
      zIndex: 2,
    ));

    // 3. Draw reinforcement bars in circular pattern
    final tieRadius = radius - cover;
    for (int i = 0; i < state.numBars; i++) {
      final angle = (2 * math.pi / state.numBars) * i;
      final barX = centerX + tieRadius * math.cos(angle);
      final barY = centerY + tieRadius * math.sin(angle);

      primitives.add(_createBarPrimitive(
        id: 'circular_bar_$i',
        center: Offset(barX, barY),
        radius: barRadius,
        zIndex: 3,
        label: 'Main Bar',
      ));
    }

    return primitives;
  }

  static void _addColumnDimensions(
    List<DiagramPrimitive> primitives,
    ColumnDesignState state,
    double centerX,
    double centerY,
  ) {
    final scale = columnScale;
    final b = state.b * scale;
    final d = state.d * scale;

    // Width dimension (b)
    final widthDimY = centerY + d / 2 + 35;
    primitives.add(DiagramLine(
      id: 'col_width_dim',
      start: Offset(centerX - b / 2, widthDimY),
      end: Offset(centerX + b / 2, widthDimY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Width dimension ticks
    primitives.add(DiagramLine(
      id: 'col_width_tick1',
      start: Offset(centerX - b / 2, widthDimY - 4),
      end: Offset(centerX - b / 2, widthDimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'col_width_tick2',
      start: Offset(centerX + b / 2, widthDimY - 4),
      end: Offset(centerX + b / 2, widthDimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'col_width_label',
      position: Offset(centerX, widthDimY - 12),
      text: 'b = ${state.b.toInt()} mm',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // Depth dimension (D)
    final depthDimX = centerX + b / 2 + 25;
    primitives.add(DiagramLine(
      id: 'col_depth_dim',
      start: Offset(depthDimX, centerY - d / 2),
      end: Offset(depthDimX, centerY + d / 2),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Depth dimension ticks
    primitives.add(DiagramLine(
      id: 'col_depth_tick1',
      start: Offset(depthDimX - 4, centerY - d / 2),
      end: Offset(depthDimX + 4, centerY - d / 2),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'col_depth_tick2',
      start: Offset(depthDimX - 4, centerY + d / 2),
      end: Offset(depthDimX + 4, centerY + d / 2),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'col_depth_label',
      position: Offset(depthDimX + 8, centerY),
      text: 'D = ${state.d.toInt()} mm',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));

    // Reinforcement info label
    primitives.add(DiagramText(
      id: 'rebar_info',
      position: Offset(centerX - b / 2, centerY - d / 2 - 20),
      text: '${state.numBars}Ø${state.mainBarDia.toInt()} / Ø${state.tieDia.toInt()} @ ${state.tieSpacing.toInt()} mm',
      fontSize: 9,
      color: rebarColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));
  }

  /// TRANSFORM: mapInteractionDiagram
  /// Creates P-M interaction diagram with design point.
  static List<DiagramPrimitive> mapInteractionDiagram(ColumnDesignState state) {
    final primitives = <DiagramPrimitive>[];

    const originX = 50.0;
    const originY = 250.0;
    const width = 200.0;
    const height = 160.0;

    // 1. Draw axes
    primitives.add(const DiagramLine(
      id: 'pm_axis_x',
      start: Offset(originX, originY),
      end: Offset(originX + width, originY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 1,
    ));
    primitives.add(const DiagramLine(
      id: 'pm_axis_y',
      start: Offset(originX, originY),
      end: Offset(originX, originY - height),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 1,
    ));

    // 2. Draw interaction curve (simplified bezier approximation)
    // The curve represents column capacity: P vs M interaction
    _drawInteractionCurve(primitives, originX, originY, width, height);

    // 3. Plot design point
    final pu = state.pu;
    // Use the appropriate moment based on load type
    final mu = state.loadType == LoadType.axial ? 0.0 : state.magnifiedMx > 0 ? state.magnifiedMx : state.mx;
    final ratio = state.interactionRatio;

    // Scale point position based on ratio
    final pointX = originX + (ratio.clamp(0.0, 1.0) * width * 0.8);
    final pointY = originY - (ratio.clamp(0.0, 1.0) * height * 0.7);

    final pointColor = ratio <= 1.0 ? safeColor : warningColor;

    // Draw design point
    primitives.add(DiagramRect(
      id: 'design_point',
      position: Offset(pointX - 5, pointY - 5),
      width: 10,
      height: 10,
      fillColor: pointColor,
      strokeColor: const Color(0xFFFFFFFF),
      strokeWidth: 2.0,
      cornerRadius: 5,
      zIndex: 10,
    ));

    // Design point label
    primitives.add(DiagramText(
      id: 'design_point_label',
      position: Offset(pointX + 10, pointY - 15),
      text: 'Pu=${pu.toInt()}, M=${mu.toInt()}',
      fontSize: 8,
      color: pointColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.below,
      zIndex: 11,
    ));

    // 4. Axis labels
    primitives.add(const DiagramText(
      id: 'pm_x_label',
      position: Offset(originX + width / 2, originY + 20),
      text: 'Mu (kNm)',
      fontSize: 9,
      color: labelColor,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));
    primitives.add(const DiagramText(
      id: 'pm_y_label',
      position: Offset(originX - 25, originY - height / 2),
      text: 'Pu (kN)',
      fontSize: 9,
      color: labelColor,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));

    // 5. Title
    primitives.add(const DiagramText(
      id: 'pm_title',
      position: Offset(originX + width / 2, originY - height - 20),
      text: 'P-M Interaction',
      fontSize: 11,
      color: labelColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  static void _drawInteractionCurve(
    List<DiagramPrimitive> primitives,
    double originX,
    double originY,
    double width,
    double height,
  ) {
    // Create points along the interaction curve
    final curvePoints = <Offset>[];
    const numPoints = 20;

    for (int i = 0; i <= numPoints; i++) {
      final t = i / numPoints;
      // Simplified curve: starts high on P-axis, curves to M-axis
      final x = originX + width * (1 - math.pow(1 - t, 2)) * 0.95;
      final y = originY - height * math.pow(t, 0.7) * 0.9;
      curvePoints.add(Offset(x, y));
    }

    // Draw curve segments
    for (int i = 0; i < curvePoints.length - 1; i++) {
      primitives.add(DiagramLine(
        id: 'pm_curve_$i',
        start: curvePoints[i],
        end: curvePoints[i + 1],
        strokeWidth: 2.0,
        color: interactionCurveColor,
        zIndex: 2,
      ));
    }

    // Fill under curve
    if (curvePoints.isNotEmpty) {
      // Create closing path (simplified - just the line back to origin)
      primitives.add(DiagramLine(
        id: 'pm_curve_close',
        start: curvePoints.last,
        end: Offset(originX, originY),
        strokeWidth: 1.0,
        color: interactionCurveColor.withValues(alpha: 0.3),
        zIndex: 1,
      ));
    }
  }

  /// TRANSFORM: mapSlendernessDiagram
  /// Creates slenderness ratio visualization.
  static List<DiagramPrimitive> mapSlendernessDiagram(ColumnDesignState state) {
    final primitives = <DiagramPrimitive>[];

    const originX = 50.0;
    const originY = 150.0;
    const width = 500.0;
    const height = 100.0;

    // 1. Draw column representation
    final columnHeight = height - 20;

    // Left support
    primitives.add(DiagramRect(
      id: 'col_left_support',
      position: Offset(originX, originY - columnHeight),
      width: 10,
      height: columnHeight,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 1.0,
      zIndex: 1,
    ));

    // Right support
    primitives.add(DiagramRect(
      id: 'col_right_support',
      position: Offset(originX + width - 10, originY - columnHeight),
      width: 10,
      height: columnHeight,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 1.0,
      zIndex: 1,
    ));

    // Column shaft
    primitives.add(DiagramRect(
      id: 'col_shaft',
      position: Offset(originX + 10, originY - columnHeight),
      width: width - 20,
      height: columnHeight,
      fillColor: concreteColor.withValues(alpha: 0.5),
      strokeColor: concreteStroke,
      strokeWidth: 1.5,
      zIndex: 2,
    ));

    // 2. Effective length indicators
    primitives.add(const DiagramLine(
      id: 'effective_length_line',
      start: Offset(originX + 10, originY + 15),
      end: Offset(originX + width - 10, originY + 15),
      strokeWidth: 1.0,
      color: dimensionColor,
      dashed: true,
      zIndex: 3,
    ));

    // Effective length label
    primitives.add(DiagramText(
      id: 'effective_length_label',
      position: const Offset(originX + width / 2, originY + 25),
      text: 'Le = ${state.lex.toInt()} mm',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    // 3. Slenderness ratios
    primitives.add(DiagramText(
      id: 'slenderness_x',
      position: Offset(originX + width / 2, originY - columnHeight - 30),
      text: 'λx = ${state.slendernessX.toStringAsFixed(1)} (lex/b = ${state.lex / state.b})',
      fontSize: 10,
      color: state.isShort ? safeColor : warningColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    // 4. Title
    primitives.add(DiagramText(
      id: 'slenderness_title',
      position: Offset(originX + width / 2, originY - columnHeight - 50),
      text: 'Slenderness Check',
      fontSize: 12,
      color: labelColor,
      fontWeight: FontWeight.w700,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapComplete
  /// Creates complete column diagram with all elements.
  static List<DiagramPrimitive> mapComplete(ColumnDesignState state) {
    final primitives = <DiagramPrimitive>[];

    // Add title
    primitives.add(DiagramText(
      id: 'column_title',
      position: const Offset(50, 30),
      text: '${state.type.label} Column: ${state.b.toInt()}x${state.d.toInt()} mm',
      fontSize: 14,
      color: labelColor,
      fontWeight: FontWeight.w700,
      zIndex: 20,
    ));

    primitives.addAll(mapCrossSection(state));

    // Position interaction diagram
    primitives.addAll(_offsetPrimitives(
      mapInteractionDiagram(state),
      280.0,
      0.0,
    ));

    return primitives;
  }

  // ============================================
  // HELPER METHODS
  // ============================================

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
