/// FILE HEADER
/// ----------------------------------------------
/// File: ai_result.dart
/// Feature: ai
/// Layer: domain
///
/// PURPOSE:
/// Unifies the expected NLP extraction into a structured domain entity recognizable by existing business rules.
///
/// RESPONSIBILITIES:
/// - Defines standard metrics.
/// - Determines overall structural validity of the NLP output.
///
/// DEPENDENCIES:
/// - ConcreteGrade enum from the `calculator` feature.
///
/// FUTURE IMPROVEMENTS:
/// - Expand struct to handle multi-tasking (e.g., leveling vs calculator inferences).
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/concrete_grade.dart';

/// CLASS: AiResult
/// PURPOSE: Holds the data parsed from messy natural language input.
/// WHY: Prevents the AI Service from deciding "what" these variables mean (Domain Logic boundary).
class AiResult {
  final double? length;
  final double? width;
  final double? depth;
  final ConcreteGrade? grade;
  final bool isValid;
  final String message;

  const AiResult({
    this.length,
    this.width,
    this.depth,
    this.grade,
    required this.isValid,
    required this.message,
  });
}



