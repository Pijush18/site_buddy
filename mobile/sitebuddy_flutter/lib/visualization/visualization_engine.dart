/// Visualization Engine - Core Exports
/// 
/// This is the main entry point for the engineering visualization engine.
/// Import this file to get access to all core functionality.

/// Config
export 'config/diagram_config.dart';

/// Core rendering
export 'core/diagram_renderer.dart';

/// Primitives (basic)
export 'primitives/primitives.dart';

/// Primitives (path-based with hatch support)
export 'primitives/path_primitives.dart';

/// Coordinate System
export 'coordinate_system/coordinate_mapper.dart';

/// Dimension helpers (uses HatchPattern from path_primitives)
export 'dimension/dimension_annotation.dart' show DimensionAnnotation, DimensionStyle;

// === STUB MODULES ===
// These provide interfaces for future expansion
// Using hide to avoid conflicts with implementations

/// Semantic Layer (stubs)
export 'semantic/semantic_types.dart';

/// Layout Engine (stubs)
export 'layout/layout_types.dart';

/// Transform (stubs)
export 'transform/transform_types.dart';

/// Dimension (stubs - use dimension_annotation for implementation)
export 'dimension/dimension_types.dart' show Dimension, DimensionType, DimensionRenderer;

/// Styling (stubs - use path_primitives HatchPattern for implementation)
export 'styling/style_types.dart' show LineStyle, FillStyle, TextStyle2D, StyleCatalog, StyleType;

/// Data Visualization (stubs)
export 'data_visualization/data_types.dart';

/// Charts (stubs)
export 'charts/chart_types.dart';

/// Parametric (stubs)
export 'parametric/parametric_types.dart';

/// Annotation (stubs)
export 'annotation/annotation_types.dart';

/// Multi-View (stubs)
export 'multi_view/multi_view_types.dart';

/// Performance (stubs)
export 'performance/performance_types.dart';

/// Validation (stubs)
export 'validation/validation_types.dart';

/// Export (stubs)
export 'export/export_types.dart';

/// Debug (stubs)
export 'debug/debug_types.dart';

/// Adapters for real-world diagrams
export 'adapters/road_pavement_diagram.dart';
export 'adapters/canal_cross_section_diagram.dart';
