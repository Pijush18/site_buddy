import 'package:site_buddy/core/optimization/optimization_option.dart';

/// MODEL: DesignAdvisorResult
/// PURPOSE: Holds the output of the Design Advisor's analysis of an optimization result.
class DesignAdvisorResult {
  final OptimizationOption? recommendedOption;
  final String explanation;
  final List<String> warnings;
  final List<String> suggestions;

  const DesignAdvisorResult({
    this.recommendedOption,
    required this.explanation,
    this.warnings = const [],
    this.suggestions = const [],
  });
}



