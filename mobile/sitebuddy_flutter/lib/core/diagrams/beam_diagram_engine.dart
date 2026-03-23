import 'dart:math';
import 'package:site_buddy/core/diagrams/diagram_models.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';

/// ENGINE: BeamDiagramEngine
/// PURPOSE: Generates geometry for RC Beam cross-sections.
class BeamDiagramEngine {
  static BeamDiagramGeom generate(BeamDesignState state, double width, double height) {
    final cx = width / 2;
    final cy = height / 2;
    final padding = 40.0;
    
    // Guard against zero or negative dimensions
    final maxDim = max(state.width, state.overallDepth);
    final availableSpace = min(width, height) - padding;
    
    if (maxDim <= 0 || availableSpace <= 0) {
      // Return minimal valid geometry for invalid input
      return BeamDiagramGeom(
        outline: DiagramRect(cx - 20, cy - 20, 40, 40),
        stirrup: DiagramRect(cx - 15, cy - 15, 30, 30),
        mainBars: [],
        hangerBars: [],
      );
    }
    
    // Scale based on beam dimensions
    final scale = availableSpace / maxDim;
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
    
    // Guard against zero bars
    if (numBars <= 0) {
      return BeamDiagramGeom(
        outline: outline,
        stirrup: stirrup,
        mainBars: [],
        hangerBars: [],
      );
    }
    
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




