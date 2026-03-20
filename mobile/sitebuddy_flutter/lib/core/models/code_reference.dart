/// MODEL: CodeReference
/// PURPOSE: Represents a specific engineering code clause Reference.
class CodeReference {
  final String code; // e.g., IS 456:2000
  final String clause; // e.g., 26.5.3.1
  final String title; // e.g., Minimum Reinforcement
  final String description; // Explanation of the clause
  final String? formula; // Optional formula string (LaTeX style or plain text)

  const CodeReference({
    required this.code,
    required this.clause,
    required this.title,
    required this.description,
    this.formula,
  });
}



