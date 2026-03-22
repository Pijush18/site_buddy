/// CLASS: GoldenTestCase
/// PURPOSE: Root model for deterministic QA validation.
class GoldenTestCase<TInput, TOutput> {
  final String id;
  final String description;
  final TInput input;
  final TOutput expected;
  final double tolerance; // Percentage (e.g., 1.0 for 1%)

  const GoldenTestCase({
    required this.id,
    required this.description,
    required this.input,
    required this.expected,
    this.tolerance = 1.0, 
  });
}
