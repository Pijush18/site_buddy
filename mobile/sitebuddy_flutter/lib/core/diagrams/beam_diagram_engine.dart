import 'dart:math';
import 'package:site_buddy/core/diagrams/diagram_models.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';

/// ENGINE: BeamDiagramEngine
/// PURPOSE: Generates geometry for RC Beam cross-sections.
class BeamDiagramEngine {
  static BeamDiagramGeom generate(BeamDesignState state, double width, double height) {
    final cx = width / 2;
    final cy = height / 2;
    final padding = 40.0;
    
    // Scale based on beam dimensions
    final scale = (min(width, height) - padding) / max(state.width, state.overallDepth);
    final beamWidth = state.width * scale;
    final beamHeight = state.overallDepth * scale;
    
    final outline = DiagramRect(
      cx - beamWidth / 2,
      cy - beamHeight / 2,
      beamWidth,
      beamHeight,
    );
    
    // Stirrup is inside the outline with scaled cover
    final stirrupPadding = 10.0; 
    final stirrup = DiagramRect(
      outline.x + stirrupPadding,
      outline.y + stirrupPadding,
      beamWidth - 2 * stirrupPadding,
      beamHeight - 2 * stirrupPadding,
    );
    
    final mainBars = <DiagramEllipse>[];
    final numBars = state.numBars;
    final barRadius = 4.0;
    
    // Bottom bars (Main Tension Reinforcement)
    final mainBarY = stirrup.y + stirrup.height - barRadius - 2;
    for (int i = 0; i < numBars; i++) {
        final t = numBars > 1 ? i / (numBars - 1) : 0.5;
        final barX = stirrup.x + barRadius + 2 + t * (stirrup.width - 2 * barRadius - 4);
        mainBars.add(DiagramEllipse(barX, mainBarY, barRadius, barRadius));
    }
    
    // Hanger bars (Top corners)
    final hangerBars = <DiagramEllipse>[
      DiagramEllipse(stirrup.x + barRadius + 2, stirrup.y + barRadius + 2, barRadius, barRadius),
      DiagramEllipse(stirrup.x + stirrup.width - barRadius - 2, stirrup.y + barRadius + 2, barRadius, barRadius),
    ];
    
    return BeamDiagramGeom(
      outline: outline,
      stirrup: stirrup,
      mainBars: mainBars,
      hangerBars: hangerBars,
    );
  }
}



