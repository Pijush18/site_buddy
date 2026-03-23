import 'dart:math';
import 'package:site_buddy/core/diagrams/diagram_models.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_state.dart';
import 'package:site_buddy/features/structural/column/domain/column_enums.dart';

/// ENGINE: ColumnDiagramEngine
/// PURPOSE: Generates geometry for RC Column cross-sections.
class ColumnDiagramEngine {
  static ColumnDiagramGeom generate(ColumnDesignState state, double width, double height) {
    final cx = width / 2;
    final cy = height / 2;
    final padding = 40.0;
    
    // Guard against zero or negative dimensions
    final availableSpace = min(width, height) - padding;
    if (availableSpace <= 0) {
      return ColumnDiagramGeom(
        isCircular: false,
        rectangularOutline: DiagramRect(cx - 20, cy - 20, 40, 40),
        rebars: [],
      );
    }
    
    final isCircular = state.type == ColumnType.circular;
    
    if (isCircular) {
      final radius = availableSpace / 2;
      final outline = DiagramEllipse(cx, cy, radius, radius);
      
      final rebars = <DiagramEllipse>[];
      final numBars = state.numBars;
      
      // Guard against zero or negative rebar radius
      final rebarRadius = radius - 30;
      if (rebarRadius > 0 && numBars > 0) {
        for (int i = 0; i < numBars; i++) {
          final angle = (2 * pi * i) / numBars;
          final rx = cx + rebarRadius * cos(angle);
          final ry = cy + rebarRadius * sin(angle);
          rebars.add(DiagramEllipse(rx, ry, 5, 5));
        }
      }
      
      return ColumnDiagramGeom(
        isCircular: true,
        circularOutline: outline,
        rebars: rebars,
      );
    } else {
      // Rectangular
      final maxDim = max(state.b, state.d);
      if (maxDim <= 0) {
        return ColumnDiagramGeom(
          isCircular: false,
          rectangularOutline: DiagramRect(cx - 20, cy - 20, 40, 40),
          rebars: [],
        );
      }
      
      final scale = availableSpace / maxDim;
      final rectWidth = state.b * scale;
      final rectHeight = state.d * scale;
      
      final outline = DiagramRect(
        cx - rectWidth / 2,
        cy - rectHeight / 2,
        rectWidth,
        rectHeight,
      );
      
      final rebars = <DiagramEllipse>[];
      final numBars = state.numBars;
      
      // Guard against insufficient dimensions for rebars
      if (rectWidth > 30 && rectHeight > 30 && numBars > 0) {
        // Indicative rebar placement for rectangular columns
        // For simplicity, we place them at corners and along the sides
        final margin = 15.0; // scaled cover + stirrup
        final rebarXStart = outline.x + margin;
        final rebarYStart = outline.y + margin;
        final rebarXEnd = outline.x + rectWidth - margin;
        final rebarYEnd = outline.y + rectHeight - margin;
        
        if (numBars >= 4) {
          rebars.add(DiagramEllipse(rebarXStart, rebarYStart, 5, 5));
          rebars.add(DiagramEllipse(rebarXEnd, rebarYStart, 5, 5));
          rebars.add(DiagramEllipse(rebarXStart, rebarYEnd, 5, 5));
          rebars.add(DiagramEllipse(rebarXEnd, rebarYEnd, 5, 5));
          
          int remaining = numBars - 4;
          if (remaining > 0) {
            // Simplistic distribution for the rest
            // In a real app, this would be more precise based on b and d ratio
            for (int i = 0; i < remaining; i++) {
               // Just some dummy distribution
               final t = (i + 1) / (remaining + 1);
               rebars.add(DiagramEllipse(rebarXStart + (rebarXEnd - rebarXStart) * t, rebarYStart, 5, 5));
            }
          }
        }
      }
      
      return ColumnDiagramGeom(
        isCircular: false,
        rectangularOutline: outline,
        rebars: rebars,
      );
    }
  }
}





