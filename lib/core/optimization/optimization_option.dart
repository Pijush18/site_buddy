/// MODEL: OptimizationOption
/// Represents a single structural design candidate with its efficiency and parameters.
class OptimizationOption {
  final String title;
  final String description;
  final double steelArea;
  final double utilization;
  final Map<String, dynamic> parameters;

  const OptimizationOption({
    required this.title,
    required this.description,
    required this.steelArea,
    required this.utilization,
    required this.parameters,
  });
}
