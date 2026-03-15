import 'package:hive/hive.dart';

part 'footing_type.g.dart';

/// ENUM: FootingType
/// PURPOSE: Defines the various types of footings supported by the module.
@HiveType(typeId: 12)
enum FootingType {
  @HiveField(0)
  isolated('Isolated Footing', 'Single column support, square or rectangular.'),
  @HiveField(1)
  combined('Combined Footing', 'Supports two or more columns.'),
  @HiveField(2)
  strap('Strap Footing', 'Two footings connected by a structural strap beam.'),
  @HiveField(3)
  strip(
    'Strip / Continuous',
    'Supports a load-bearing wall or row of columns.',
  ),
  @HiveField(4)
  raft('Raft / Mat', 'Large slab supporting the entire building area.'),
  @HiveField(5)
  pile('Pile Footing', 'Deep foundation for low-bearing soil conditions.');

  final String label;
  final String description;

  const FootingType(this.label, this.description);
}
