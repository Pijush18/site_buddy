
/// MODEL: EngineeringInsight
class EngineeringInsight {
  final String message;
  final bool isWarning;

  EngineeringInsight({required this.message, this.isWarning = false});
}

/// MODEL: ShearResult
class ShearResult {
  final double tv;
  final double tc;
  final bool isSafe;
  final List<EngineeringInsight> insights;

  ShearResult({
    required this.tv,
    required this.tc,
    required this.isSafe,
    required this.insights,
  });
}

/// MODEL: DeflectionResult
class DeflectionResult {
  final double actualRatio;
  final double allowableRatio;
  final bool isSafe;
  final List<EngineeringInsight> insights;

  DeflectionResult({
    required this.actualRatio,
    required this.allowableRatio,
    required this.isSafe,
    required this.insights,
  });
}

/// MODEL: CrackingResult
class CrackingResult {
  final double crackWidth;
  final bool isSafe;
  final List<EngineeringInsight> insights;

  CrackingResult({
    required this.crackWidth,
    required this.isSafe,
    required this.insights,
  });
}
