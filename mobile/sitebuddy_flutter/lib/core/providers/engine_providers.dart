import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/engineering/standards/design_code.dart';
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/core/engineering/standards/resolver.dart';
import 'package:site_buddy/core/design_engines/slab_design_engine.dart';
import 'package:site_buddy/core/design_engines/beam_design_engine.dart';
import 'package:site_buddy/core/design_engines/column_design_engine.dart';
import 'package:site_buddy/core/optimization/optimization_engine.dart';
import 'package:site_buddy/core/services/design_report_service.dart';
import 'package:site_buddy/features/design/beam/beam_design_service.dart';
import 'package:site_buddy/features/design/slab/slab_design_service.dart';
import 'package:site_buddy/features/design/column/column_design_service.dart';
import 'package:site_buddy/features/design/footing/footing_design_service.dart' as domain;
import 'package:site_buddy/features/design/brick/brick_design_service.dart';
import 'package:site_buddy/features/design/concrete/concrete_design_service.dart';
import 'package:site_buddy/features/design/plaster/plaster_design_service.dart';
import 'package:site_buddy/features/design/excavation/excavation_design_service.dart';
import 'package:site_buddy/features/design/shuttering/shuttering_design_service.dart';
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';
import 'package:site_buddy/core/engineering/standards/transport/irc_standard.dart';
import 'package:site_buddy/features/transport/road/domain/services/road_design_service.dart';

/// Provider for current DesignCode
final designCodeProvider = StateProvider<DesignCode>((ref) {
  return DesignCode.is456; // Default to IS 456
});

/// Provider for DesignStandard
final designStandardProvider = Provider<DesignStandard>((ref) {
  final code = ref.watch(designCodeProvider);
  return DesignStandardResolver.resolve(code);
});

/// Provider for SlabDesignService
final slabDesignServiceProvider = Provider<SlabDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return SlabDesignService(standard);
});

/// Provider for SlabDesignEngine
final slabEngineProvider = Provider<SlabDesignEngine>((ref) {
  final service = ref.watch(slabDesignServiceProvider);
  return SlabDesignEngine(service);
});

/// Provider for BeamDesignService
final beamDesignServiceProvider = Provider<BeamDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return BeamDesignService(standard);
});

/// Provider for BeamDesignEngine
final beamEngineProvider = Provider<BeamDesignEngine>((ref) {
  final service = ref.watch(beamDesignServiceProvider);
  return BeamDesignEngine(service);
});

/// Provider for ColumnDesignService
final columnDesignServiceProvider = Provider<ColumnDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return ColumnDesignService(standard);
});

/// Provider for ColumnDesignEngine
final columnEngineProvider = Provider<ColumnDesignEngine>((ref) {
  final service = ref.watch(columnDesignServiceProvider);
  return ColumnDesignEngine(service);
});

/// Provider for FootingDesignService (Domain)
final footingDesignServiceProvider = Provider<domain.FootingDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return domain.FootingDesignService(standard);
});

/// Provider for OptimizationEngine
final optimizationEngineProvider = Provider<OptimizationEngine>((ref) {
  final standard = ref.watch(designStandardProvider);
  final beamService = ref.watch(beamDesignServiceProvider);
  final slabService = ref.watch(slabDesignServiceProvider);
  final columnService = ref.watch(columnDesignServiceProvider);
  final footingService = ref.watch(footingDesignServiceProvider);
  return OptimizationEngine(
    standard,
    beamService: beamService,
    slabService: slabService,
    columnService: columnService,
    footingService: footingService,
  );
});

/// Provider for DesignReportService
final designReportServiceProvider = Provider<DesignReportService>((ref) {
  final standard = ref.watch(designStandardProvider);
  final beamService = ref.watch(beamDesignServiceProvider);
  final slabService = ref.watch(slabDesignServiceProvider);
  final columnService = ref.watch(columnDesignServiceProvider);
  final footingService = ref.watch(footingDesignServiceProvider);
  return DesignReportService(
    standard,
    beamService: beamService,
    slabService: slabService,
    columnService: columnService,
    footingService: footingService,
  );
});

final brickDesignServiceProvider = Provider<BrickDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return BrickDesignService(standard);
});

final concreteDesignServiceProvider = Provider<ConcreteDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return ConcreteDesignService(standard);
});

final plasterDesignServiceProvider = Provider<PlasterDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return PlasterDesignService(standard);
});

final excavationDesignServiceProvider = Provider<ExcavationDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return ExcavationDesignService(standard);
});

final shutteringDesignServiceProvider = Provider<ShutteringDesignService>((ref) {
  final standard = ref.watch(designStandardProvider);
  return ShutteringDesignService(standard);
});

final roadStandardProvider = Provider<RoadStandard>((ref) {
  return IRCStandard();
});

final roadDesignServiceProvider = Provider<RoadDesignService>((ref) {
  final standard = ref.watch(roadStandardProvider);
  return RoadDesignService(standard);
});



