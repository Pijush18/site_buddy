import 'package:site_buddy/features/structural/column/domain/column_design_state.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';
import 'package:site_buddy/features/structural/slab/domain/slab_design_result.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_state.dart';

abstract class StructuralRepository {
  Future<void> init();

  // Column
  Future<void> saveColumn(ColumnDesignState state);
  List<ColumnDesignState> getColumnsForProject(String projectId);

  // Beam
  Future<void> saveBeam(BeamDesignState state);
  List<BeamDesignState> getBeamsForProject(String projectId);

  // Slab
  Future<void> saveSlab(SlabDesignResult state);
  List<SlabDesignResult> getSlabsForProject(String projectId);

  // Footing
  Future<void> saveFooting(FootingDesignState state);
  List<FootingDesignState> getFootingsForProject(String projectId);
}




