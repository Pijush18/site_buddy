import 'package:uuid/uuid.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';

/// MAPPER: DesignReportMapper
/// PURPOSE: Decouples domain entities from the report system by providing centralized
/// transformation logic.
class DesignReportMapper {
  static const _uuid = Uuid();

  /// Converts [BeamDesignState] to a unified [DesignReport].
  static DesignReport fromBeam(BeamDesignState state) {
    return DesignReport(
      id: _uuid.v4(),
      designType: DesignType.beam,
      timestamp: DateTime.now(),
      projectId: state.projectId,
      isSafe: state.isFlexureSafe && state.isShearSafe && state.isDeflectionSafe,
      summary: 'Beam Design: ${state.width.toInt()}x${state.overallDepth.toInt()} mm, Span: ${(state.span / 1000).toStringAsFixed(1)}m',
      inputs: {
        'type': state.type.name,
        'span': state.span,
        'b': state.width,
        'D': state.overallDepth,
        'fck': state.concreteGrade,
        'fy': state.steelGrade,
        'dead_load': state.deadLoad,
        'live_load': state.liveLoad,
      },
      results: {
        'mu': state.mu,
        'vu': state.vu,
        'ast_required': state.astRequired,
        'ast_provided': state.astProvided,
        'num_bars': state.numBars,
        'bar_dia': state.mainBarDia,
        'is_flexure_safe': state.isFlexureSafe,
        'is_shear_safe': state.isShearSafe,
      },
    );
  }

  /// Converts [SlabDesignState] to a unified [DesignReport].
  static DesignReport fromSlab(SlabDesignState state) {
    final result = state.result;
    return DesignReport(
      id: _uuid.v4(),
      designType: DesignType.slab,
      timestamp: DateTime.now(),
      projectId: state.projectId,
      isSafe: result?.isShearSafe ?? false,
      summary: 'Slab Design: ${state.lx.toStringAsFixed(1)}x${state.ly.toStringAsFixed(1)}m, D: ${state.d.toInt()}mm',
      inputs: {
        'type': state.type.name,
        'lx': state.lx,
        'ly': state.ly,
        'D': state.d,
        'fck': state.concreteGrade,
        'fy': state.steelGrade,
      },
      results: {
        'bending_moment': result?.bendingMoment ?? 0.0,
        'main_rebar': result?.mainRebar ?? '-',
        'distribution': result?.distributionSteel ?? '-',
        'ast_required': result?.astRequired ?? 0.0,
        'is_shear_safe': result?.isShearSafe ?? false,
      },
    );
  }

  /// Converts [ColumnDesignState] to a unified [DesignReport].
  static DesignReport fromColumn(ColumnDesignState state) {
    return DesignReport(
      id: _uuid.v4(),
      designType: DesignType.column,
      timestamp: DateTime.now(),
      projectId: state.projectId,
      isSafe: state.isCapacitySafe && state.isReinforcementSafe,
      summary: 'Column Design: ${state.b.toInt()}x${state.d.toInt()} mm, Pu: ${state.pu.toInt()}kN',
      inputs: {
        'type': state.type.name,
        'b': state.b,
        'd': state.d,
        'length': state.length,
        'fck': state.concreteGrade,
        'fy': state.steelGrade,
        'pu': state.pu,
      },
      results: {
        'ast_required': state.astRequired,
        'ast_provided': state.astProvided,
        'steel_percentage': state.steelPercentage,
        'interaction_ratio': state.interactionRatio,
        'is_capacity_safe': state.isCapacitySafe,
      },
    );
  }

  /// Converts [FootingDesignState] to a unified [DesignReport].
  static DesignReport fromFooting(FootingDesignState state) {
    return DesignReport(
      id: _uuid.v4(),
      designType: DesignType.footing,
      timestamp: DateTime.now(),
      projectId: state.projectId,
      isSafe: state.isAreaSafe && state.isPunchingShearSafe && state.isBendingSafe,
      summary: 'Footing Design: ${state.footingLength.toInt()}x${state.footingWidth.toInt()} mm, SBC: ${state.sbc.toInt()}kN/m²',
      inputs: {
        'type': state.type.name,
        'load': state.columnLoad,
        'sbc': state.sbc,
        'L': state.footingLength,
        'B': state.footingWidth,
        'D': state.footingThickness,
        'fck': state.concreteGrade,
        'fy': state.steelGrade,
      },
      results: {
        'max_pressure': state.maxSoilPressure,
        'eccentricity_x': state.eccentricityX,
        'ast_required_x': state.astRequiredX,
        'ast_provided_x': state.astProvidedX,
        'is_area_safe': state.isAreaSafe,
        'is_punching_safe': state.isPunchingShearSafe,
      },
    );
  }
}
