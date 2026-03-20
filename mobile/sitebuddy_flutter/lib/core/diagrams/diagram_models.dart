/// FILE: diagram_models.dart
/// PURPOSE: Common geometry models for structural design diagrams.
/// DESIGN: Pure Dart logic for canvas-independent geometry representation.
library;

/// Represents a single point in 2D space.
class DiagramPoint {
  final double x;
  final double y;
  const DiagramPoint(this.x, this.y);
}

/// Represents a rectangle defined by its top-left corner and dimensions.
class DiagramRect {
  final double x;
  final double y;
  final double width;
  final double height;
  const DiagramRect(this.x, this.y, this.width, this.height);
}

/// Represents an ellipse defined by its center and radii.
class DiagramEllipse {
  final double cx;
  final double cy;
  final double rx;
  final double ry;
  const DiagramEllipse(this.cx, this.cy, this.rx, this.ry);
}

/// Represents a line between two points.
class DiagramLine {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  
  DiagramPoint get start => DiagramPoint(x1, y1);
  DiagramPoint get end => DiagramPoint(x2, y2);

  const DiagramLine(this.x1, this.y1, this.x2, this.y2);
}

/// Geometry model for Column diagrams.
class ColumnDiagramGeom {
  final bool isCircular;
  final DiagramEllipse? circularOutline;
  final DiagramRect? rectangularOutline;
  final List<DiagramEllipse> rebars;

  const ColumnDiagramGeom({
    required this.isCircular,
    this.circularOutline,
    this.rectangularOutline,
    required this.rebars,
  });
}

/// Geometry model for Beam diagrams.
class BeamDiagramGeom {
  final DiagramRect outline;
  final DiagramRect stirrup;
  final List<DiagramEllipse> mainBars;
  final List<DiagramEllipse> hangerBars;

  const BeamDiagramGeom({
    required this.outline,
    required this.stirrup,
    required this.mainBars,
    required this.hangerBars,
  });
}

/// Geometry model for Slab diagrams.
class SlabDiagramGeom {
  final DiagramRect outline;
  final List<DiagramLine> mainRebars;
  final List<DiagramLine> distributionRebars;

  const SlabDiagramGeom({
    required this.outline,
    required this.mainRebars,
    required this.distributionRebars,
  });
}

/// Geometry model for Footing diagrams.
class FootingDiagramGeom {
  final DiagramRect footingOutline;
  final DiagramRect columnOutline;
  final List<DiagramLine> gridLines;

  const FootingDiagramGeom({
    required this.footingOutline,
    required this.columnOutline,
    required this.gridLines,
  });
}



