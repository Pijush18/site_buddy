import 'package:site_buddy/core/constants/concrete_mix_constants.dart';

/// MODEL: ConcreteInput
/// PURPOSE: Strong-typed input for concrete material estimation.
class ConcreteInput {
  final double length;
  final double width;
  final double depth;
  final ConcreteMix? grade;
  final double steelPercentage;

  ConcreteInput({
    required this.length,
    required this.width,
    required this.depth,
    this.grade,
    this.steelPercentage = 0.01,
  });
}
