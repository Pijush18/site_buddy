// FILE HEADER
// ----------------------------------------------
// File: slab_to_diagram_mapper.dart
// Feature: design
// Layer: application/mappers
//
// PURPOSE:
// Transforms SlabDesignState (real engineering calculations)
// into DiagramPrimitives for rendering by the DiagramEngine.
//
// This mapper converts:
// - Slab geometry (Lx, Ly, thickness)
// - Reinforcement layout (main steel, distribution steel)
// - Two-way vs one-way slab indication
// - Bending moment visualization
//
// ----------------------------------------------

import 'dart:math' as math;
import 'dart:ui';

import 'package:site_buddy/visualization/primitives/primitives.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_design_state.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_type.dart';

/// MAPPER: SlabToDiagramMapper
/// PURPOSE: Convert SlabDesignState to diagram primitives for rendering.
class SlabToDiagramMapper {
  // Diagram dimensions (world units in mm)
  static const double diagramWidth = 600.0;
  static const double diagramHeight = 400.0;

  // Colors
  static const Color concreteColor = Color(0xFFE0E0E0);
  static const Color concreteStroke = Color(0xFF424242);
  static const Color mainRebarColor = Color(0xFF1565C0);
  static const Color distRebarColor = Color(0xFF4CAF50);
  static const Color dimensionColor = Color(0xFF616161);
  static const Color labelColor = Color(0xFF212121);
  static const Color safeColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFD32F2F);

  /// TRANSFORM: mapPlanView
  /// Creates plan view diagram primitives from slab state.
  static List<DiagramPrimitive> mapPlanView(SlabDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.lx <= 0 || state.ly <= 0) {
      return primitives;
    }

    // Calculate scale to fit diagram
    final aspectRatio = state.lx / state.ly;
    final padding = 80.0;
    final availableWidth = diagramWidth - 2 * padding;
    final availableHeight = diagramHeight - 2 * padding - 100; // Extra space for labels

    double slabWidth, slabHeight;
    if (aspectRatio > 1) {
      slabWidth = availableWidth;
      slabHeight = slabWidth / aspectRatio;
    } else {
      slabHeight = availableHeight;
      slabWidth = slabHeight * aspectRatio;
    }

    // Adjust scale: Lx and Ly are in meters, convert to mm for consistency
    final mmScale = slabWidth / (state.lx * 1000);

    // Center the slab in diagram
    final centerX = diagramWidth / 2;
    final centerY = diagramHeight / 2 - 50;
    final originX = centerX - slabWidth / 2;
    final originY = centerY - slabHeight / 2;

    // 1. Draw slab outline
    primitives.add(DiagramRect(
      id: 'slab_outline',
      position: Offset(originX, originY),
      width: slabWidth,
      height: slabHeight,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 2.0,
      zIndex: 1,
      label: 'Slab Plan',
    ));

    // 2. Draw main reinforcement (along shorter span Lx)
    _drawMainReinforcement(primitives, state, originX, originY, slabWidth, slabHeight, mmScale);

    // 3. Draw distribution reinforcement (along longer span Ly)
    _drawDistributionReinforcement(primitives, state, originX, originY, slabWidth, slabHeight, mmScale);

    // 4. Add dimension labels
    _addSlabDimensions(primitives, state, originX, originY, slabWidth, slabHeight);

    // 5. Add reinforcement info
    _addSlabReinforcementInfo(primitives, state, originX, originY, slabWidth, slabHeight);

    return primitives;
  }

  static void _drawMainReinforcement(
    List<DiagramPrimitive> primitives,
    SlabDesignState state,
    double originX,
    double originY,
    double slabWidth,
    double slabHeight,
    double mmScale,
  ) {
    // Extract spacing from mainRebar string (e.g., "10mm @ 150mm c/c" -> 150)
    final spacing = _extractSpacing(state.result?.mainRebar, 150.0);
    final barDia = _extractBarDia(state.result?.mainRebar, 10.0);
    final barRadius = math.max(1.5, (barDia * mmScale) / 2);

    // Calculate number of bars
    final coverOffset = 20.0; // mm in diagram units
    final numBars = ((slabWidth - 2 * coverOffset) / (spacing * mmScale)).floor();

    for (int i = 1; i <= numBars; i++) {
      final x = originX + coverOffset + i * (spacing * mmScale);
      if (x > originX + slabWidth - coverOffset) break;

      primitives.add(DiagramLine(
        id: 'main_rebar_$i',
        start: Offset(x, originY + coverOffset),
        end: Offset(x, originY + slabHeight - coverOffset),
        strokeWidth: math.max(1.5, barRadius),
        color: mainRebarColor,
        zIndex: 3,
      ));
    }

    // Label
    primitives.add(DiagramText(
      id: 'main_rebar_label',
      position: Offset(originX + slabWidth + 30, originY + slabHeight / 2),
      text: state.result != null
          ? '${state.result!.mainRebar}\n(Short span)'
          : 'Main Steel\n(Short span)',
      fontSize: 9,
      color: mainRebarColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));
  }

  static void _drawDistributionReinforcement(
    List<DiagramPrimitive> primitives,
    SlabDesignState state,
    double originX,
    double originY,
    double slabWidth,
    double slabHeight,
    double mmScale,
  ) {
    // Extract spacing from distributionSteel string
    final spacing = _extractSpacing(state.result?.distributionSteel, 200.0);
    final barDia = _extractBarDia(state.result?.distributionSteel, 8.0);
    final barRadius = math.max(1.5, (barDia * mmScale) / 2);

    // Calculate number of bars
    final coverOffset = 20.0;
    final numBars = ((slabHeight - 2 * coverOffset) / (spacing * mmScale)).floor();

    for (int i = 1; i <= numBars; i++) {
      final y = originY + coverOffset + i * (spacing * mmScale);
      if (y > originY + slabHeight - coverOffset) break;

      primitives.add(DiagramLine(
        id: 'dist_rebar_$i',
        start: Offset(originX + coverOffset, y),
        end: Offset(originX + slabWidth - coverOffset, y),
        strokeWidth: math.max(1.0, barRadius),
        color: distRebarColor.withValues(alpha: 0.8),
        zIndex: 2,
      ));
    }

    // Label
    primitives.add(DiagramText(
      id: 'dist_rebar_label',
      position: Offset(originX + slabWidth / 2, originY - 25),
      text: state.result != null
          ? '${state.result!.distributionSteel}\n(Long span)'
          : 'Distribution Steel\n(Long span)',
      fontSize: 9,
      color: distRebarColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));
  }

  static void _addSlabDimensions(
    List<DiagramPrimitive> primitives,
    SlabDesignState state,
    double originX,
    double originY,
    double slabWidth,
    double slabHeight,
  ) {
    // Lx dimension (along width)
    final lxDimY = originY + slabHeight + 30;
    primitives.add(DiagramLine(
      id: 'slab_lx_dim',
      start: Offset(originX, lxDimY),
      end: Offset(originX + slabWidth, lxDimY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Ticks
    primitives.add(DiagramLine(
      id: 'slab_lx_tick1',
      start: Offset(originX, lxDimY - 4),
      end: Offset(originX, lxDimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'slab_lx_tick2',
      start: Offset(originX + slabWidth, lxDimY - 4),
      end: Offset(originX + slabWidth, lxDimY + 4),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'slab_lx_label',
      position: Offset(originX + slabWidth / 2, lxDimY - 12),
      text: 'Lx = ${state.lx.toStringAsFixed(2)} m',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // Ly dimension (along height)
    final lyDimX = originX + slabWidth + 25;
    primitives.add(DiagramLine(
      id: 'slab_ly_dim',
      start: Offset(lyDimX, originY),
      end: Offset(lyDimX, originY + slabHeight),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    // Ticks
    primitives.add(DiagramLine(
      id: 'slab_ly_tick1',
      start: Offset(lyDimX - 4, originY),
      end: Offset(lyDimX + 4, originY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));
    primitives.add(DiagramLine(
      id: 'slab_ly_tick2',
      start: Offset(lyDimX - 4, originY + slabHeight),
      end: Offset(lyDimX + 4, originY + slabHeight),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 5,
    ));

    primitives.add(DiagramText(
      id: 'slab_ly_label',
      position: Offset(lyDimX + 8, originY + slabHeight / 2),
      text: 'Ly = ${state.ly.toStringAsFixed(2)} m',
      fontSize: 10,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));
  }

  static void _addSlabReinforcementInfo(
    List<DiagramPrimitive> primitives,
    SlabDesignState state,
    double originX,
    double originY,
    double slabWidth,
    double slabHeight,
  ) {
    // Thickness
    primitives.add(DiagramText(
      id: 'slab_thickness',
      position: Offset(originX + 10, originY + 15),
      text: 'Depth d = ${state.d.toInt()} mm',
      fontSize: 9,
      color: labelColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.below,
      zIndex: 10,
    ));

    // Safety indicators
    if (state.result != null) {
      final result = state.result!;

      // Safety status
      final allSafe = result.isShearSafe && result.isDeflectionSafe && result.isCrackingSafe;
      final safetyColor = allSafe ? safeColor : warningColor;

      primitives.add(DiagramText(
        id: 'slab_safety_status',
        position: Offset(originX + slabWidth / 2, originY + slabHeight - 20),
        text: allSafe ? '✓ All Checks Passed' : '⚠ Review Required',
        fontSize: 9,
        color: safetyColor,
        fontWeight: FontWeight.w600,
        alignMode: TextAlignMode.center,
        zIndex: 10,
      ));

      // Moment value
      primitives.add(DiagramText(
        id: 'slab_moment',
        position: Offset(originX + slabWidth - 10, originY + 15),
        text: 'Mu = ${result.bendingMoment.toStringAsFixed(1)} kNm/m',
        fontSize: 9,
        color: mainRebarColor,
        fontWeight: FontWeight.w500,
        alignMode: TextAlignMode.below,
        zIndex: 10,
      ));
    }
  }

  /// TRANSFORM: mapSectionView
  /// Creates section view of slab reinforcement.
  static List<DiagramPrimitive> mapSectionView(SlabDesignState state) {
    final primitives = <DiagramPrimitive>[];

    const originX = 50.0;
    const originY = 300.0;
    const slabWidth = 500.0;
    final slabHeight = math.max(15.0, state.d * 0.05); // Scale thickness

    // 1. Draw slab body
    primitives.add(DiagramRect(
      id: 'slab_section',
      position: Offset(originX, originY - slabHeight),
      width: slabWidth,
      height: slabHeight,
      fillColor: concreteColor,
      strokeColor: concreteStroke,
      strokeWidth: 2.0,
      zIndex: 1,
      label: 'Slab Section',
    ));

    // 2. Draw reinforcement bars (top and bottom)
    final barDia = 10.0 * 0.05; // Scale bar diameter
    final barRadius = math.max(1.5, barDia / 2);

    // Bottom reinforcement (main steel)
    final bottomY = originY - 3;
    const numMainBars = 15;
    for (int i = 1; i <= numMainBars; i++) {
      final x = originX + (slabWidth / (numMainBars + 1)) * i;
      primitives.add(_createBarPrimitive(
        id: 'section_main_$i',
        center: Offset(x, bottomY),
        radius: barRadius,
        zIndex: 3,
        color: mainRebarColor,
      ));
    }

    // Top reinforcement (distribution steel)
    final topY = originY - slabHeight + 3;
    const numDistBars = 10;
    for (int i = 1; i <= numDistBars; i++) {
      final x = originX + (slabWidth / (numDistBars + 1)) * i;
      primitives.add(_createBarPrimitive(
        id: 'section_dist_$i',
        center: Offset(x, topY),
        radius: math.max(1.0, barRadius * 0.8),
        zIndex: 3,
        color: distRebarColor,
      ));
    }

    // 3. Cover indication
    primitives.add(DiagramText(
      id: 'cover_label',
      position: Offset(originX - 20, originY - slabHeight / 2),
      text: 'd = ${state.d.toInt()}',
      fontSize: 8,
      color: labelColor,
      rotation: -math.pi / 2,
      zIndex: 10,
    ));

    // Section title
    primitives.add(DiagramText(
      id: 'section_title',
      position: Offset(originX + slabWidth / 2, originY - slabHeight - 20),
      text: 'Section B-B (Typical)',
      fontSize: 11,
      color: labelColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapMomentDiagram
  /// Creates bending moment distribution visualization.
  static List<DiagramPrimitive> mapMomentDiagram(SlabDesignState state) {
    final primitives = <DiagramPrimitive>[];

    if (state.result == null) {
      return _createPlaceholder(primitives, 'Moment Distribution', 'No analysis data');
    }

    const originX = 50.0;
    const originY = 100.0;
    const width = 500.0;
    const height = 80.0;

    // 1. Draw axis
    primitives.add(const DiagramLine(
      id: 'moment_axis',
      start: Offset(originX, originY),
      end: Offset(originX + width, originY),
      strokeWidth: 1.0,
      color: dimensionColor,
      zIndex: 1,
    ));

    // 2. Draw moment curve (simplified parabolic for simply supported)
    final maxMoment = state.result!.bendingMoment;
    final scale = (height / 2) / (maxMoment > 0 ? maxMoment : 1);

    // Parabolic curve approximation
    const numPoints = 30;
    for (int i = 0; i < numPoints; i++) {
      final t1 = i / numPoints;
      final t2 = (i + 1) / numPoints;

      // Parabolic moment distribution: M = Mmax * 4 * x/L * (1 - x/L)
      final x1 = originX + t1 * width;
      final x2 = originX + t2 * width;
      final y1 = originY - maxMoment * scale * 4 * t1 * (1 - t1);
      final y2 = originY - maxMoment * scale * 4 * t2 * (1 - t2);

      primitives.add(DiagramLine(
        id: 'moment_curve_$i',
        start: Offset(x1, y1),
        end: Offset(x2, y2),
        strokeWidth: 2.5,
        color: mainRebarColor,
        zIndex: 2,
      ));
    }

    // 3. Labels
    primitives.add(const DiagramText(
      id: 'moment_title',
      position: Offset(originX + width / 2, originY - height - 15),
      text: 'Bending Moment Distribution (kNm/m)',
      fontSize: 11,
      color: labelColor,
      fontWeight: FontWeight.w600,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    primitives.add(DiagramText(
      id: 'moment_max_label',
      position: Offset(originX + width / 2, originY - maxMoment * scale - 15),
      text: 'Mu,max = ${maxMoment.toStringAsFixed(1)} kNm/m',
      fontSize: 9,
      color: mainRebarColor,
      fontWeight: FontWeight.w500,
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  static List<DiagramPrimitive> _createPlaceholder(
    List<DiagramPrimitive> primitives,
    String title,
    String message,
  ) {
    const originX = 50.0;
    const originY = 100.0;
    const width = 500.0;
    const height = 80.0;

    primitives.add(const DiagramRect(
      id: 'placeholder',
      position: Offset(originX, originY - height),
      width: width,
      height: height,
      fillColor: Color(0xFFF5F5F5),
      strokeColor: Color(0xFFBDBDBD),
      strokeWidth: 1.0,
      zIndex: 1,
    ));

    primitives.add(DiagramText(
      id: 'placeholder_title',
      position: const Offset(originX + width / 2, originY - height / 2),
      text: message,
      fontSize: 11,
      color: const Color(0xFF9E9E9E),
      alignMode: TextAlignMode.center,
      zIndex: 10,
    ));

    return primitives;
  }

  /// TRANSFORM: mapComplete
  /// Creates complete slab diagram with all elements.
  static List<DiagramPrimitive> mapComplete(SlabDesignState state) {
    final primitives = <DiagramPrimitive>[];

    // Add title
    final slabTypeLabel = state.type == SlabType.oneWay ? 'One-Way' : 'Two-Way';
    primitives.add(DiagramText(
      id: 'slab_title',
      position: const Offset(50, 30),
      text: '$slabTypeLabel Slab: ${state.lx.toStringAsFixed(2)} x ${state.ly.toStringAsFixed(2)} m',
      fontSize: 14,
      color: labelColor,
      fontWeight: FontWeight.w700,
      zIndex: 20,
    ));

    // Add plan view
    primitives.addAll(mapPlanView(state));

    // Add moment diagram (positioned below)
    primitives.addAll(_offsetPrimitives(mapMomentDiagram(state), 0.0, 250.0));

    return primitives;
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  static double _extractSpacing(String? rebarString, double defaultValue) {
    if (rebarString == null || rebarString.isEmpty) return defaultValue;

    // Try to extract spacing from strings like "10mm @ 150mm c/c"
    final patterns = [
      RegExp(r'@\s*(\d+)\s*mm'),
      RegExp(r'(\d+)\s*mm\s*c/c'),
      RegExp(r's@\s*(\d+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(rebarString);
      if (match != null) {
        return double.tryParse(match.group(1) ?? '') ?? defaultValue;
      }
    }

    return defaultValue;
  }

  static double _extractBarDia(String? rebarString, double defaultValue) {
    if (rebarString == null || rebarString.isEmpty) return defaultValue;

    // Try to extract bar diameter from strings like "10mm @ 150mm c/c"
    final patterns = [
      RegExp(r'(\d+)\s*mm\s*@'),
      RegExp(r'Ø(\d+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(rebarString);
      if (match != null) {
        return double.tryParse(match.group(1) ?? '') ?? defaultValue;
      }
    }

    return defaultValue;
  }

  static DiagramGroup _createBarPrimitive({
    required String id,
    required Offset center,
    required double radius,
    required int zIndex,
    required Color color,
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
          fillColor: color,
          strokeColor: color,
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
