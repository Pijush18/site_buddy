import 'package:hive/hive.dart';

part 'beam_type.g.dart';

/// ENUM: BeamType
/// PURPOSE: Defines various beam support conditions.
@HiveType(typeId: 8)
enum BeamType {
  @HiveField(0)
  simplySupported('Simply Supported'),
  @HiveField(1)
  continuous('Continuous'),
  @HiveField(2)
  cantilever('Cantilever');

  final String label;
  const BeamType(this.label);
}



