import 'dart:math';
import 'package:site_buddy/core/diagrams/diagram_models.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';

/// ENGINE: FootingDiagramEngine
/// PURPOSE: Generates geometry for RC Footing (Isolated) plan view.
class FootingDiagramEngine {
  static FootingDiagramGeom generate(FootingDesignState state, double width, double height) {
    final cx = width / 2;
    final cy = height / 2;
    final padding = 40.0;
    
    // Scale based on footing dimensions
    final scale = (min(width, height) - padding) / max(state.footingLength, state.footingWidth);
    final fW = state.footingWidth * scale; // B
    final fL = state.footingLength * scale; // L
    
    final footingOutline = DiagramRect(
      cx - fW / 2,
      cy - fL / 2,
      fW,
      fL,
    );
    
    final columnOutline = DiagramRect(
      cx - (state.colB * scale) / 2,
      cy - (state.colA * scale) / 2,
      state.colB * scale,
      state.colA * scale,
    );

    
    final gridLines = <DiagramLine>[];
    
    // X-Grid
    final numX = 8;
    for (int i = 0; i < numX; i++) {
        final t = (i + 1) / (numX + 1);
        final x = footingOutline.x + t * footingOutline.width;
        gridLines.add(DiagramLine(x, footingOutline.y + 5, x, footingOutline.y + footingOutline.height - 5));
    }
    
    // Y-Grid
    final numY = 8;
    for (int i = 0; i < numY; i++) {
        final t = (i + 1) / (numY + 1);
        final y = footingOutline.y + t * footingOutline.height;
        gridLines.add(DiagramLine(footingOutline.x + 5, y, footingOutline.x + footingOutline.width - 5, y));
    }
    
    return FootingDiagramGeom(
      footingOutline: footingOutline,
      columnOutline: columnOutline,
      gridLines: gridLines,
    );
  }
}
