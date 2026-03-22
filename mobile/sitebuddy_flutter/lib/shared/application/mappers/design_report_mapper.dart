import 'package:uuid/uuid.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';

import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// MAPPER: DesignReportMapper
/// PURPOSE: Decouples domain entities from the report system by providing centralized
/// transformation logic.
class DesignReportMapper {
  static const _uuid = Uuid();

  /// NEW: Converts a legacy [CalculationHistoryEntry] to a unified [DesignReport].
  static DesignReport fromHistoryEntry(CalculationHistoryEntry entry) {
    AppLogger.debug('Mapping CalculationHistoryEntry to DesignReport (Project: ${entry.projectId})', tag: 'Mapper');
    return DesignReport(
      id: entry.id,
      designType: _mapCalculationType(entry.calculationType),
      timestamp: entry.timestamp,
      projectId: entry.projectId,
      inputs: _normalize(entry.inputParameters),
      results: _normalize(entry.resultData),
      summary: entry.resultSummary,
      isSafe: true,
    );
  }

  static DesignType _mapCalculationType(CalculationType type) {
    switch (type) {
      case CalculationType.beam: return DesignType.beam;
      case CalculationType.slab: return DesignType.slab;
      case CalculationType.column: return DesignType.column;
      case CalculationType.footing: return DesignType.footing;
      case CalculationType.cement: return DesignType.cement;
      case CalculationType.rebar: return DesignType.rebar;
      case CalculationType.brick: return DesignType.brick;
      case CalculationType.plaster: return DesignType.plaster;
      case CalculationType.excavation: return DesignType.excavation;
      case CalculationType.shuttering: return DesignType.shuttering;
      case CalculationType.sand: return DesignType.sand;
      case CalculationType.levelLog: return DesignType.levelLog;
      case CalculationType.gradient: return DesignType.gradient;
      case CalculationType.unitConverter: return DesignType.unitConverter;
      case CalculationType.currencyConverter: return DesignType.currencyConverter;
    }
  }

  /// Converts [BeamDesignState] to a unified [DesignReport].
  static DesignReport fromBeam(BeamDesignState state, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping BeamDesignState to DesignReport (Project: $projectId)', tag: 'Mapper');
    return DesignReport(
      id: id,
      designType: DesignType.beam,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: state.isFlexureSafe && state.isShearSafe && state.isDeflectionSafe,
      summary: 'Beam Design: ${state.width.toInt()}x${state.overallDepth.toInt()} mm, Span: ${(state.span / 1000).toStringAsFixed(1)}m',
      inputs: {
        'Geometry': {
          'span': _f('Span', state.span, unit: 'mm'),
          'width': _f('Width (b)', state.width, unit: 'mm'),
          'depth': _f('Depth (D)', state.overallDepth, unit: 'mm'),
        },
        'Materials': {
          'fck': _f('Concrete Grade', state.concreteGrade),
          'fy': _f('Steel Grade', state.steelGrade),
        },
        'Loading': {
          'dead_load': _f('Dead Load', state.deadLoad, unit: 'kN/m'),
          'live_load': _f('Live Load', state.liveLoad, unit: 'kN/m'),
        },
      },
      results: {
        'Analysis': {
          'mu': _f('Moment (Mu)', state.mu, unit: 'kNm'),
          'vu': _f('Shear (Vu)', state.vu, unit: 'kN'),
        },
        'Reinforcement': {
          'ast_required': _f('Ast Required', state.astRequired, unit: 'mm²'),
          'ast_provided': _f('Ast Provided', state.astProvided, unit: 'mm²'),
          'num_bars': _f('Number of Bars', state.numBars),
          'bar_dia': _f('Main Bar Diameter', state.mainBarDia, unit: 'mm'),
        },
      },
    );
  }

  /// Converts [SlabDesignState] to a unified [DesignReport].
  static DesignReport fromSlab(SlabDesignState state, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping SlabDesignState to DesignReport (Project: $projectId)', tag: 'Mapper');
    final result = state.result;
    return DesignReport(
      id: id,
      designType: DesignType.slab,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: result?.isShearSafe ?? false,
      summary: 'Slab Design: ${state.lx.toStringAsFixed(1)}x${state.ly.toStringAsFixed(1)}m, D: ${state.d.toInt()}mm',
      inputs: {
        'Geometry': {
          'lx': _f('Short Span (Lx)', state.lx, unit: 'm'),
          'ly': _f('Long Span (Ly)', state.ly, unit: 'm'),
          'D': _f('Slab Depth', state.d, unit: 'mm'),
        },
        'Materials': {
          'fck': _f('Concrete Grade', state.concreteGrade),
          'fy': _f('Steel Grade', state.steelGrade),
        },
      },
      results: {
        'Analysis': {
          'bending_moment': _f('Bending Moment', result?.bendingMoment ?? 0.0, unit: 'kNm/m'),
        },
        'Reinforcement': {
          'main_rebar': _f('Main Steel', result?.mainRebar ?? '-'),
          'distribution': _f('Distribution Steel', result?.distributionSteel ?? '-'),
          'ast_required': _f('Ast Required', result?.astRequired ?? 0.0, unit: 'mm²/m'),
        },
      },
    );
  }

  /// Converts [ColumnDesignState] to a unified [DesignReport].
  static DesignReport fromColumn(ColumnDesignState state, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping ColumnDesignState to DesignReport (Project: $projectId)', tag: 'Mapper');
    return DesignReport(
      id: id,
      designType: DesignType.column,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: state.isCapacitySafe && state.isReinforcementSafe,
      summary: 'Column Design: ${state.b.toInt()}x${state.d.toInt()} mm, Pu: ${state.pu.toInt()}kN',
      inputs: {
        'Geometry': {
          'b': _f('Width (b)', state.b, unit: 'mm'),
          'd': _f('Depth (d)', state.d, unit: 'mm'),
          'length': _f('Length (L)', state.length, unit: 'm'),
        },
        'Materials': {
          'fck': _f('Concrete Grade', state.concreteGrade),
          'fy': _f('Steel Grade', state.steelGrade),
        },
        'Loading': {
          'pu': _f('Axial Load (Pu)', state.pu, unit: 'kN'),
        },
      },
      results: {
        'Reinforcement': {
          'ast_required': _f('Ast Required', state.astRequired, unit: 'mm²'),
          'ast_provided': _f('Ast Provided', state.astProvided, unit: 'mm²'),
          'percentage': _f('Steel Percentage', state.steelPercentage, unit: '%'),
        },
        'Safety': {
          'interaction': _f('Interaction Ratio', state.interactionRatio),
          'is_safe': _f('Capacity Safe', state.isCapacitySafe),
        },
      },
    );
  }

  /// Converts [FootingDesignState] to a unified [DesignReport].
  static DesignReport fromFooting(FootingDesignState state, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping FootingDesignState to DesignReport (Project: $projectId)', tag: 'Mapper');
    return DesignReport(
      id: id,
      designType: DesignType.footing,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: state.isAreaSafe && state.isPunchingShearSafe && state.isBendingSafe,
      summary: 'Footing Design: ${state.footingLength.toInt()}x${state.footingWidth.toInt()} mm, SBC: ${state.sbc.toInt()}kN/m²',
      inputs: {
        'Geometry': {
          'L': _f('Length (L)', state.footingLength, unit: 'mm'),
          'B': _f('Width (B)', state.footingWidth, unit: 'mm'),
          'D': _f('Thickness (D)', state.footingThickness, unit: 'mm'),
        },
        'Loading': {
          'axial_load': _f('Column Load', state.columnLoad, unit: 'kN'),
          'sbc': _f('Soil Capacity (SBC)', state.sbc, unit: 'kN/m²'),
        },
        'Materials': {
          'fck': _f('Concrete Grade', state.concreteGrade),
          'fy': _f('Steel Grade', state.steelGrade),
        },
      },
      results: {
        'Analysis': {
          'max_pressure': _f('Max Soil Pressure', state.maxSoilPressure, unit: 'kN/m²'),
          'eccentricity': _f('Eccentricity (e)', state.eccentricityX, unit: 'mm'),
        },
        'Reinforcement': {
          'ast_required': _f('Ast Required', state.astRequiredX, unit: 'mm²'),
          'ast_provided': _f('Ast Provided', state.astProvidedX, unit: 'mm²'),
        },
      },
    );
  }

  /// NEW: Converts Cement results to a unified [DesignReport].
  static DesignReport fromCement(dynamic result, Map<String, dynamic> inputs, String projectId) {
    AppLogger.debug('Mapping Cement result to DesignReport (Project: $projectId)', tag: 'Mapper');
    
    // Normalizing dynamic result (Map or dynamic) into structured results
    final resultsMap = result is Map<String, dynamic> ? result : (result is Map ? result.cast<String, dynamic>() : <String, dynamic>{});
    
    return DesignReport(
      id: _uuid.v4(),
      designType: DesignType.cement,
      timestamp: DateTime.now(),
      projectId: projectId,
      summary: '${inputs['length']}x${inputs['width']}m Cement estimation',
      inputs: _normalize(inputs),
      results: _normalize(resultsMap),
    );
  }

  /// Converts [PlasterResult] to a unified [DesignReport].
  static DesignReport fromPlaster(dynamic result, Map<String, dynamic> inputs, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping Plaster Calculator to DesignReport (Project: $projectId)', tag: 'Mapper');
    final resultsMap = result is Map<String, dynamic> ? result : (result is Map ? result.cast<String, dynamic>() : <String, dynamic>{});
    return DesignReport(
      id: id,
      designType: DesignType.plaster,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: true, // Assuming plaster calculations are generally "safe" if completed
      summary: 'Plaster estimation for ${inputs['area'] ?? 'N/A'}',
      inputs: _normalize(inputs),
      results: _normalize(resultsMap),
    );
  }

  /// Converts [ExcavationResult] to a unified [DesignReport].
  static DesignReport fromExcavation(dynamic result, Map<String, dynamic> inputs, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping Excavation Calculator to DesignReport (Project: $projectId)', tag: 'Mapper');
    final resultsMap = result is Map<String, dynamic> ? result : (result is Map ? result.cast<String, dynamic>() : <String, dynamic>{});
    return DesignReport(
      id: id,
      designType: DesignType.excavation,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: true, // Assuming excavation calculations are generally "safe" if completed
      summary: 'Excavation volume: ${resultsMap['volume'] ?? 'N/A'}',
      inputs: _normalize(inputs),
      results: _normalize(resultsMap),
    );
  }

  /// Converts [ShutteringResult] to a unified [DesignReport].
  static DesignReport fromShuttering(dynamic result, Map<String, dynamic> inputs, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping Shuttering Calculator to DesignReport (Project: $projectId)', tag: 'Mapper');
    final resultsMap = result is Map<String, dynamic> ? result : (result is Map ? result.cast<String, dynamic>() : <String, dynamic>{});
    return DesignReport(
      id: id,
      designType: DesignType.shuttering,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: true, // Assuming shuttering calculations are generally "safe" if completed
      summary: 'Shuttering area: ${resultsMap['area'] ?? 'N/A'}',
      inputs: _normalize(inputs),
      results: _normalize(resultsMap),
    );
  }

  /// Converts [SandResult] to a unified [DesignReport].
  static DesignReport fromSand(dynamic result, Map<String, dynamic> inputs, String projectId) {
    final id = _uuid.v4();
    AppLogger.debug('Mapping Sand Calculator to DesignReport (Project: $projectId)', tag: 'Mapper');
    final resultsMap = result is Map<String, dynamic> ? result : (result is Map ? result.cast<String, dynamic>() : <String, dynamic>{});
    return DesignReport(
      id: id,
      designType: DesignType.sand,
      timestamp: DateTime.now(),
      projectId: projectId,
      isSafe: true, // Assuming sand calculations are generally "safe" if completed
      summary: 'Sand estimation for ${inputs['area'] ?? 'N/A'}',
      inputs: _normalize(inputs),
      results: _normalize(resultsMap),
    );
  }

  /// Converts Rebar results to a unified [DesignReport].
  static DesignReport fromRebar(dynamic result, Map<String, dynamic> inputs, String projectId) {
    AppLogger.debug('Mapping Rebar estimation to DesignReport (Project: $projectId)', tag: 'Mapper');
    final resultsMap = result is Map<String, dynamic> ? result : (result is Map ? result.cast<String, dynamic>() : <String, dynamic>{});
    return DesignReport(
      id: _uuid.v4(),
      designType: DesignType.rebar,
      timestamp: DateTime.now(),
      projectId: projectId,
      summary: '${resultsMap['totalWeight'] ?? '0'} kg Rebar Estimated',
      inputs: _normalize(inputs),
      results: _normalize(resultsMap),
    );
  }

  /// Converts Brick Wall results to a unified [DesignReport].
  static DesignReport fromBrick(dynamic result, Map<String, dynamic> inputs, String projectId) {
    AppLogger.debug('Mapping Brick estimation to DesignReport (Project: $projectId)', tag: 'Mapper');
    final resultsMap = result is Map<String, dynamic> ? result : (result is Map ? result.cast<String, dynamic>() : <String, dynamic>{});
    return DesignReport(
      id: _uuid.v4(),
      designType: DesignType.brick,
      timestamp: DateTime.now(),
      projectId: projectId,
      summary: '${resultsMap['numberOfBricks'] ?? '0'} Bricks Estimated',
      inputs: _normalize(inputs),
      results: _normalize(resultsMap),
    );
  }

  /// NEW: Generic calculator result mapper for rapid integration.
  static DesignReport fromGenericCalculator({
    required DesignType type,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> results,
    required String summary,
    required String projectId,
  }) {
    AppLogger.debug('Mapping Generic ${type.name} to DesignReport (Project: $projectId)', tag: 'Mapper');
    return DesignReport(
      id: _uuid.v4(),
      designType: type,
      timestamp: DateTime.now(),
      projectId: projectId,
      summary: summary,
      inputs: _normalize(inputs),
      results: _normalize(results),
    );
  }

  /// ── HELPERS: STRUCTURED DATA NORMALIZATION ──

  /// Helper to create a structured field object.
  static Map<String, dynamic> _f(String label, dynamic value, {String? unit}) {
    return {
      'label': label,
      'value': value,
      ...?unit != null ? {'unit': unit} : null,
    };
  }

  /// Helper to normalize mixed Map data. 
  /// Ensures every leaf node is a structured field {label, value, [unit]}.
  static Map<String, dynamic> _normalize(Map<String, dynamic> data) {
    final normalized = <String, dynamic>{};
    
    data.forEach((key, val) {
      if (val is Map<String, dynamic>) {
        // Handle Grouping: Check if it's already a structured field or a group
        if (val.containsKey('label') && val.containsKey('value')) {
          normalized[key] = val; // Already structured
        } else {
          normalized[key] = _normalize(val); // It's a group
        }
      } else {
        // Leaf value: convert to structured field
        normalized[key] = _f(_formatKey(key), val);
      }
    });

    return normalized;
  }

  /// Converts 'live_load' to 'Live Load'
  static String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : '')
        .join(' ');
  }
}
