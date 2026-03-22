
import 'package:hive/hive.dart';
import 'package:site_buddy/features/structural/shared/domain/repositories/structural_repository.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_state.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_design_result.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_state.dart';

class HiveStructuralRepository implements StructuralRepository {
  late Box<ColumnDesignState> _columnBox;
  late Box<BeamDesignState> _beamBox;
  late Box<SlabDesignResult> _slabBox;
  late Box<FootingDesignState> _footingBox;

  @override
  Future<void> init() async {
    _columnBox = await Hive.openBox<ColumnDesignState>('column_designs');
    _beamBox = await Hive.openBox<BeamDesignState>('beam_designs');
    _slabBox = await Hive.openBox<SlabDesignResult>('slab_designs');
    _footingBox = await Hive.openBox<FootingDesignState>('footing_designs');
  }

  // Column
  @override
  Future<void> saveColumn(ColumnDesignState state) async {
    await _columnBox.put(state.projectId ?? 'default', state);
  }

  @override
  List<ColumnDesignState> getColumnsForProject(String projectId) {
    return _columnBox.values.where((s) => s.projectId == projectId).toList();
  }

  // Beam
  @override
  Future<void> saveBeam(BeamDesignState state) async {
    await _beamBox.put(state.projectId ?? 'default', state);
  }

  @override
  List<BeamDesignState> getBeamsForProject(String projectId) {
    return _beamBox.values.where((s) => s.projectId == projectId).toList();
  }

  // Slab
  @override
  Future<void> saveSlab(SlabDesignResult state) async {
    // Note: SlabDesignResult might not have projectId yet, using default
    await _slabBox.put('default', state);
  }

  @override
  List<SlabDesignResult> getSlabsForProject(String projectId) {
    return _slabBox.values.toList();
  }

  // Footing
  @override
  Future<void> saveFooting(FootingDesignState state) async {
    await _footingBox.put(state.projectId ?? 'default', state);
  }

  @override
  List<FootingDesignState> getFootingsForProject(String projectId) {
    return _footingBox.values.where((s) => s.projectId == projectId).toList();
  }
}
