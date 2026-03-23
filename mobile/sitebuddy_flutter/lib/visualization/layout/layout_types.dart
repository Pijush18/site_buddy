import 'dart:ui';
import 'package:flutter/painting.dart';
import '../primitives/primitives.dart';

/// Layout algorithm types
enum LayoutType {
  flow,
  grid,
  tree,
  force,
  circular,
  hierarchical,
}

/// Layout constraint types
enum ConstraintType {
  fixed,
  proportional,
  aligned,
  grouped,
}

/// Layout constraint
class LayoutConstraint {
  final ConstraintType type;
  final String? targetId;
  final Offset offset;
  final Alignment? alignment;

  const LayoutConstraint({
    required this.type,
    this.targetId,
    this.offset = Offset.zero,
    this.alignment,
  });
}

/// Layout engine interface
abstract class LayoutEngine {
  /// Apply layout to primitives
  List<DiagramPrimitive> layout(List<DiagramPrimitive> primitives);

  /// Set constraints for specific primitives
  void setConstraint(String primitiveId, LayoutConstraint constraint);

  /// Remove constraint
  void removeConstraint(String primitiveId);

  /// Recalculate layout with current constraints
  void recalculate();
}
