import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/optimization/optimization_result.dart';

import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/core/design_engines/slab_design_engine.dart';
import 'package:site_buddy/core/design_engines/beam_design_engine.dart';
import 'package:site_buddy/core/design_engines/column_design_engine.dart';

import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_type.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_type.dart';
import 'package:site_buddy/features/structural/column/domain/column_enums.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_type.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_service.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_design_service.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_service.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_models.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_service.dart' as domain;

/// ENGINE: OptimizationEngine
/// Provides automated structural optimization for RCC components using a pluggable DesignStandard.
class OptimizationEngine {
  final DesignStandard standard;
  final ColumnDesignEngine _columnEngine;
  final BeamDesignEngine _beamEngine;
  final SlabDesignEngine _slabEngine;
  final domain.FootingDesignService _footingService;

  OptimizationEngine(
    this.standard, {
    required BeamDesignService beamService,
    required SlabDesignService slabService,
    required ColumnDesignService columnService,
    required domain.FootingDesignService footingService,
  }) : _columnEngine = ColumnDesignEngine(columnService),
       _beamEngine = BeamDesignEngine(beamService),
       _slabEngine = SlabDesignEngine(slabService),
       _footingService = footingService;

  /// METHOD: optimizeColumnSection
  /// Generates top 3 column design options based on Pu/Mu loads.
  OptimizationResult optimizeColumnSection({
    required double pu,
    required double mx,
    required double my,
    required String concreteGrade,
    required String steelGrade,
    double length = 3000,
  }) {
    final List<OptimizationOption> candidates = [];
    final List<double> sizes = [230, 300, 375, 450, 525, 600];

    for (var b in sizes) {
      for (var d in sizes) {
        if (d < b) continue; // Avoid duplicate ratios for square/rectangle

        final inputs = ColumnDesignInputs(
          pu: pu,
          mx: mx,
          my: my,
          b: b,
          d: d,
          length: length,
          concreteGrade: concreteGrade,
          steelGrade: steelGrade,
          type: ColumnType.rectangular,
          endCondition: EndCondition.pinned, // Default for optimization
          cover: 40.0,
        );

        final result = _columnEngine.calculate(inputs);

        if (result.isCapacitySafe && result.interactionRatio > 0.3) {
          candidates.add(
            OptimizationOption(
              title: '${b.toInt()}x${d.toInt()} mm',
              description: result.reinforcement,
              steelArea: 0, // Placeholder
              utilization: result.interactionRatio,
              parameters: {'b': b, 'd': d},
            ),
          );
        }
      }
    }

    // Sort: Lowest steel area first (Economical), then filter for Top 3
    candidates.sort((a, b) => a.steelArea.compareTo(b.steelArea));

    return OptimizationResult(options: candidates.take(3).toList());
  }

  /// METHOD: optimizeBeamSection
  /// Suggests beam depth/width based on moment and shear.
  OptimizationResult optimizeBeamSection({
    required double span,
    required double deadLoad,
    required double liveLoad,
    required String concreteGrade,
    required String steelGrade,
    BeamType type = BeamType.simplySupported,
  }) {
    final List<OptimizationOption> candidates = [];
    final List<double> widths = [230, 300];

    for (var b in widths) {
      for (double d = 300; d <= 750; d += 50) {
        final inputs = BeamDesignInputs(
          span: span,
          width: b,
          overallDepth: d,
          deadLoad: deadLoad,
          liveLoad: liveLoad,
          concreteGrade: concreteGrade,
          steelGrade: steelGrade,
          type: type,
          cover: 25.0,
        );

        final result = _beamEngine.calculate(inputs);

        if (result.isFlexureSafe &&
            result.isDeflectionSafe &&
            result.isShearSafe) {
          candidates.add(
            OptimizationOption(
              title: '${b.toInt()}x${d.toInt()} mm',
              description: result.bottomRebar,
              steelArea: 0, // Simplified
              utilization: 0.8, // Simplified
              parameters: {'width': b, 'depth': d},
            ),
          );
        }
      }
    }

    candidates.sort((a, b) => a.steelArea.compareTo(b.steelArea));
    return OptimizationResult(options: candidates.take(3).toList());
  }

  /// METHOD: optimizeSlabThickness
  /// Suggests thickness to satisfy deflection and minimize reinforcement.
  OptimizationResult optimizeSlabThickness({
    required double lx,
    required double ly,
    required double deadLoad,
    required double liveLoad,
    SlabType type = SlabType.oneWay,
  }) {
    final List<OptimizationOption> candidates = [];

    for (double d = 100; d <= 350; d += 25) {
      final inputs = SlabDesignInputs(
        type: type,
        lx: lx,
        ly: ly,
        depth: d,
        deadLoad: deadLoad,
        liveLoad: liveLoad,
      );

      final res = _slabEngine.calculate(inputs);

      if (res.isDeflectionSafe) {
        candidates.add(
          OptimizationOption(
            title: '${d.toInt()} mm Thickness',
            description: res.mainRebar,
            steelArea: d * 10, // Approximation for ranking
            utilization: d / 150, // Dummy utilization for scaling
            parameters: {'thickness': d},
          ),
        );
      }
    }

    candidates.sort((a, b) => a.steelArea.compareTo(b.steelArea));
    return OptimizationResult(options: candidates.take(3).toList());
  }

  /// METHOD: optimizeFootingSize
  /// Balances foundation area against bearing capacity.
  OptimizationResult optimizeFootingSize({
    required double columnLoad,
    required double sbc,
    required String concreteGrade,
    required String steelGrade,
    double momentX = 0,
    double momentY = 0,
  }) {
    final List<OptimizationOption> candidates = [];

    for (double dim = 1000; dim <= 4000; dim += 250) {
      for (double t = 300; t <= 900; t += 150) {
        final input = FootingInput(
          type: FootingType.isolated, // Default for square optimization
          columnLoad: columnLoad,
          sbc: sbc,
          footingLength: dim,
          footingWidth: dim,
          footingThickness: t,
          concreteGrade: concreteGrade,
          steelGrade: steelGrade,
          momentX: momentX,
          momentY: momentY,
        );

        final result = _footingService.designFooting(input);

        if (result.isAreaSafe && result.isPunchingShearSafe) {
          final utilization = result.maxSoilPressure / sbc;
          candidates.add(
            OptimizationOption(
              title:
                  '${(dim / 1000).toStringAsFixed(1)}m Square x ${t.toInt()}mm',
              description: 'SBC Utilization: ${(utilization * 100).toInt()}%',
              steelArea: result.astProvidedX,
              utilization: utilization,
              parameters: {'length': dim, 'width': dim, 'thickness': t},
            ),
          );
        }
      }
    }

    candidates.sort((a, b) => a.steelArea.compareTo(b.steelArea));
    return OptimizationResult(options: candidates.take(3).toList());
  }
}






