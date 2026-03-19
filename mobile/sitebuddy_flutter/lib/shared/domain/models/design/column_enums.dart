import 'package:hive/hive.dart';

part 'column_enums.g.dart';

/// ENUM: ColumnType
@HiveType(typeId: 3)
enum ColumnType {
  @HiveField(0)
  rectangular('Rectangular'),
  @HiveField(1)
  circular('Circular');

  final String label;
  const ColumnType(this.label);
}

/// ENUM: EndCondition
@HiveType(typeId: 4)
enum EndCondition {
  @HiveField(0)
  fixed('Fixed (Both ends)'),
  @HiveField(1)
  free('Free (One end)'),
  @HiveField(2)
  pinned('Pinned (Both)'),
  @HiveField(3)
  partial('Partial restraint');

  final String label;
  const EndCondition(this.label);
}

@HiveType(typeId: 5)
enum LoadType {
  @HiveField(0)
  axial('Axial only'),
  @HiveField(1)
  uniaxial('Uniaxial bending'),
  @HiveField(2)
  biaxial('Biaxial bending');

  final String label;
  const LoadType(this.label);
}

/// ENUM: DesignMethod
@HiveType(typeId: 6)
enum DesignMethod {
  @HiveField(0)
  analytical('Analytical (IS 456)'),
  @HiveField(1)
  chartBased('Chart-based (SP-16)');

  final String label;
  const DesignMethod(this.label);
}

/// ENUM: ColumnFailureMode
@HiveType(typeId: 7)
enum ColumnFailureMode {
  @HiveField(0)
  compression('Compression Failure'),
  @HiveField(1)
  tension('Tension Failure'),
  @HiveField(2)
  buckling('Buckling Failure'),
  @HiveField(3)
  axial('Axial Capacity Reached');

  final String label;
  const ColumnFailureMode(this.label);
}
