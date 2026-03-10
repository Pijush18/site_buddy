import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_result.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';

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
