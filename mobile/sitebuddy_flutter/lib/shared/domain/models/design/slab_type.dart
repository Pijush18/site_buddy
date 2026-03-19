// FILE HEADER
// ----------------------------------------------
// File: slab_type.dart
// Feature: design
// Layer: domain/enums
//
// PURPOSE:
// Strictly defines the architectural types of slabs supported for design.
// ----------------------------------------------
import 'package:hive/hive.dart';

part 'slab_type.g.dart';

/// ENUM: SlabType
/// Defines the structural orientation and support conditions for a slab.
@HiveType(typeId: 14)
enum SlabType {
  @HiveField(0)
  oneWay('One Way Slab'),
  @HiveField(1)
  twoWay('Two Way Slab'),
  @HiveField(2)
  continuous('Continuous Slab');

  final String label;
  const SlabType(this.label);
}
