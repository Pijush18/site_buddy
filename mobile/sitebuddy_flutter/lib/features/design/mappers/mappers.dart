// FILE HEADER
// ----------------------------------------------
// File: mappers.dart
// Feature: design
// Layer: application/mappers
//
// PURPOSE:
// Barrel export file for all design-to-diagram mappers.
//
// This module provides the transformation layer between
// domain models (BeamDesignState, ColumnDesignState, etc.)
// and diagram primitives for rendering.
//
// Usage:
//   import 'package:site_buddy/features/design/mappers/mappers.dart';
//
//   // Get diagram primitives from beam state
//   final primitives = BeamToDiagramMapper.mapCrossSection(state);
//
// ----------------------------------------------

export 'beam_to_diagram_mapper.dart';
export 'column_to_diagram_mapper.dart';
export 'footing_to_diagram_mapper.dart';
export 'slab_to_diagram_mapper.dart';
