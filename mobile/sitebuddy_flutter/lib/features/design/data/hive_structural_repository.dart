import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_result.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';
import 'package:site_buddy/features/design/domain/repositories/structural_repository.dart';

class HiveStructuralRepository implements StructuralRepository {
  static const String columnBoxName = 'column_designs';
  static const String beamBoxName = 'beam_designs';
  static const String slabBoxName = 'slab_designs';
  static const String footingBoxName = 'footing_designs';

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(columnBoxName)) {
      await Hive.openBox<ColumnDesignState>(columnBoxName);
    }
    if (!Hive.isBoxOpen(beamBoxName)) {
      await Hive.openBox<BeamDesignState>(beamBoxName);
    }
    if (!Hive.isBoxOpen(slabBoxName)) {
      await Hive.openBox<SlabDesignResult>(slabBoxName);
    }
    if (!Hive.isBoxOpen(footingBoxName)) {
      await Hive.openBox<FootingDesignState>(footingBoxName);
    }
  }

  // Column
  @override
  Future<void> saveColumn(ColumnDesignState state) async {
    if (state.projectId == null) {
      throw StateError('Cannot save calculation without a projectId');
    }
    final box = Hive.box<ColumnDesignState>(columnBoxName);
    await box.add(state);
  }

  @override
  List<ColumnDesignState> getColumnsForProject(String projectId) {
    if (!Hive.isBoxOpen(columnBoxName)) return [];
    return Hive.box<ColumnDesignState>(
      columnBoxName,
    ).values.where((e) => e.projectId == projectId).toList();
  }

  // Beam
  @override
  Future<void> saveBeam(BeamDesignState state) async {
    if (state.projectId == null) {
      throw StateError('Cannot save calculation without a projectId');
    }
    final box = Hive.box<BeamDesignState>(beamBoxName);
    await box.add(state);
  }

  @override
  List<BeamDesignState> getBeamsForProject(String projectId) {
    if (!Hive.isBoxOpen(beamBoxName)) return [];
    return Hive.box<BeamDesignState>(
      beamBoxName,
    ).values.where((e) => e.projectId == projectId).toList();
  }

  // Slab
  @override
  Future<void> saveSlab(SlabDesignResult state) async {
    if (state.projectId == null) {
      throw StateError('Cannot save calculation without a projectId');
    }
    final box = Hive.box<SlabDesignResult>(slabBoxName);
    await box.add(state);
  }

  @override
  List<SlabDesignResult> getSlabsForProject(String projectId) {
    if (!Hive.isBoxOpen(slabBoxName)) return [];
    return Hive.box<SlabDesignResult>(
      slabBoxName,
    ).values.where((e) => e.projectId == projectId).toList();
  }

  // Footing
  @override
  Future<void> saveFooting(FootingDesignState state) async {
    if (state.projectId == null) {
      throw StateError('Cannot save calculation without a projectId');
    }
    final box = Hive.box<FootingDesignState>(footingBoxName);
    await box.add(state);
  }

  @override
  List<FootingDesignState> getFootingsForProject(String projectId) {
    if (!Hive.isBoxOpen(footingBoxName)) return [];
    return Hive.box<FootingDesignState>(
      footingBoxName,
    ).values.where((e) => e.projectId == projectId).toList();
  }
}
