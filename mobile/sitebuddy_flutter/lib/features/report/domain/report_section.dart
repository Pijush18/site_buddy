
/// MODEL: ReportSection
/// PURPOSE: Represents a logical block in an engineering report (e.g., "Inputs", "Calculations").
class ReportSection {
  final String title;
  final Map<String, String> content; // Label -> Value
  final List<String>? steps; // Step-by-step calculations (Pro only)
  final bool isProOnly;

  const ReportSection({
    required this.title,
    required this.content,
    this.steps,
    this.isProOnly = false,
  });
}
