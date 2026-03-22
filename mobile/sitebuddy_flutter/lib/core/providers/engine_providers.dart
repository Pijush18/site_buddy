import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/engineering/standards/design_code.dart';
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/core/engineering/standards/resolver.dart';
import 'package:site_buddy/core/design_engines/slab_design_engine.dart';
import 'package:site_buddy/core/design_engines/beam_design_engine.dart';
import 'package:site_buddy/core/design_engines/column_design_engine.dart';
import 'package:site_buddy/core/optimization/optimization_engine.dart';
import 'package:site_buddy/core/services/design_report_service.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_service.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_design_service.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_service.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_service.dart' as domain;
import 'package:site_buddy/features/estimation/brick/domain/brick_design_service.dart';
import 'package:site_buddy/features/estimation/concrete/domain/concrete_design_service.dart';
import 'package:site_buddy/features/estimation/plaster/domain/plaster_design_service.dart';
import 'package:site_buddy/features/estimation/excavation/domain/excavation_design_service.dart';
import 'package:site_buddy/features/estimation/shuttering/domain/shuttering_design_service.dart';
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';
import 'package:site_buddy/core/engineering/standards/transport/irc_37_2018.dart';
import 'package:site_buddy/features/transport/road/domain/services/traffic_analysis_service.dart';
import 'package:site_buddy/features/transport/road/domain/services/pavement_design_service.dart';
import 'package:site_buddy/features/transport/road/domain/services/camber_design_service.dart';
import 'package:site_buddy/core/engineering/standards/hydrology/hydrology_standard.dart';
import 'package:site_buddy/core/engineering/standards/hydrology/basic_hydrology_standard.dart';
import 'package:site_buddy/features/water/irrigation/domain/services/irrigation_design_service.dart';
import 'package:site_buddy/features/water/irrigation/domain/services/manning_service.dart';
import 'package:site_buddy/features/water/irrigation/domain/services/canal_design_service.dart';
import 'package:site_buddy/features/water/irrigation/domain/services/flow_simulation_service.dart';
import 'package:site_buddy/features/report/application/report_generator.dart';

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
  return IRC37Standard();
});

final trafficAnalysisServiceProvider = Provider<TrafficAnalysisService>((ref) {
  final standard = ref.watch(roadStandardProvider);
  return TrafficAnalysisService(standard);
});

final pavementDesignServiceProvider = Provider<PavementDesignService>((ref) {
  final standard = ref.watch(roadStandardProvider);
  return PavementDesignService(standard);
});

final camberDesignServiceProvider = Provider<CamberDesignService>((ref) {
  return CamberDesignService();
});

final hydrologyStandardProvider = Provider<HydrologyStandard>((ref) {
  return BasicHydrologyStandard();
});

final irrigationServiceProvider = Provider<IrrigationDesignService>((ref) {
  final standard = ref.watch(hydrologyStandardProvider);
  return IrrigationDesignService(standard);
});

final manningServiceProvider = Provider<ManningService>((ref) {
  return ManningService();
});

final canalDesignServiceProvider = Provider<CanalDesignService>((ref) {
  final standard = ref.watch(hydrologyStandardProvider);
  final manning = ref.watch(manningServiceProvider);
  return CanalDesignService(standard, manning);
});

final reportGeneratorProvider = Provider<ReportGenerator>((ref) {
  return ReportGenerator();
});
final flowSimulationServiceProvider = Provider<FlowSimulationService>((ref) {
  return FlowSimulationService();
});
