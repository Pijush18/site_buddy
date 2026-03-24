import 'package:site_buddy/visualization/primitives/primitives.dart';

/// Validation severity
enum ValidationSeverity {
  info,
  warning,
  error,
}

/// Validation issue
class ValidationIssue {
  final String id;
  final String message;
  final ValidationSeverity severity;
  final String? primitiveId;
  final String? suggestion;

  const ValidationIssue({
    required this.id,
    required this.message,
    required this.severity,
    this.primitiveId,
    this.suggestion,
  });
}

/// Validation result
class ValidationResult {
  final List<ValidationIssue> issues;
  bool get isValid => issues.isEmpty;

  const ValidationResult({
    required this.issues,
  });

  /// Filter by severity
  List<ValidationIssue> filterBySeverity(ValidationSeverity severity) {
    return issues.where((i) => i.severity == severity).toList();
  }
}

/// Validator interface
abstract class DiagramValidator {
  /// Validate primitives
  ValidationResult validate(List<DiagramPrimitive> primitives);

  /// Check for overlapping primitives
  List<ValidationIssue> checkOverlaps(List<DiagramPrimitive> primitives);

  /// Check for disconnected elements
  List<ValidationIssue> checkConnectivity(List<DiagramPrimitive> primitives);

  /// Check boundary constraints
  List<ValidationIssue> checkBounds(
    List<DiagramPrimitive> primitives,
    double width,
    double height,
  );
}
