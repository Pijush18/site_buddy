import 'dart:math';
import 'package:site_buddy/core/diagrams/diagram_models.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';

/// ENGINE: SlabDiagramEngine
/// PURPOSE: Generates geometry for RC Slab sections (plan view representation).
class SlabDiagramEngine {
  static SlabDiagramGeom generate(SlabDesignState state, double width, double height) {
    final cx = width / 2;
    final cy = height / 2;
    final padding = 40.0;
    
    // Scale based on L Lx, Ly
    final scale = (min(width, height) - padding) / max(state.lx, state.ly);
    final slabW = state.lx * scale;
    final slabH = state.ly * scale;
    
    final outline = DiagramRect(
      cx - slabW / 2,
      cy - slabH / 2,
      slabW,
      slabH,
    );
    
    final mainRebars = <DiagramLine>[];
    final distRebars = <DiagramLine>[];
    
    // Generate some indicative lines for reinforcement
    // Short span (Lx) usually has main reinforcement
    final numMain = 8;
    for (int i = 0; i < numMain; i++) {
        final t = (i + 1) / (numMain + 1);
        final y = outline.y + t * outline.height;
        mainRebars.add(DiagramLine(outline.x + 5, y, outline.x + outline.width - 5, y));
    }
    
    final numDist = 6;
    for (int i = 0; i < numDist; i++) {
        final t = (i + 1) / (numDist + 1);
        final x = outline.x + t * outline.width;
        distRebars.add(DiagramLine(x, outline.y + 5, x, outline.y + outline.height - 5));
    }
    
    return SlabDiagramGeom(
      outline: outline,
      mainRebars: mainRebars,
      distributionRebars: distRebars,
    );
  }
}
