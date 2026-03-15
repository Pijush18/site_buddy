import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_engines/slab_design_engine.dart';
import 'package:site_buddy/core/design_engines/beam_design_engine.dart';
import 'package:site_buddy/core/design_engines/column_design_engine.dart';
import 'package:site_buddy/core/optimization/optimization_engine.dart';

/// Provider for SlabDesignEngine
final slabEngineProvider = Provider<SlabDesignEngine>((ref) {
  return const SlabDesignEngine();
});

/// Provider for BeamDesignEngine
final beamEngineProvider = Provider<BeamDesignEngine>((ref) {
  return const BeamDesignEngine();
});

/// Provider for ColumnDesignEngine
final columnEngineProvider = Provider<ColumnDesignEngine>((ref) {
  return const ColumnDesignEngine();
});

/// Provider for OptimizationEngine
final optimizationEngineProvider = Provider<OptimizationEngine>((ref) {
  return OptimizationEngine();
});
