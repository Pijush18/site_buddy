/// FILE HEADER
/// ----------------------------------------------
/// File: ai_query.dart
/// Feature: unit_converter
/// Layer: domain/entities
///
/// PURPOSE:
/// Represents the structured data extracted from a natural language query.
///
/// RESPONSIBILITIES:
/// - Holds loosely coupled nullable values parsed from NLP.
/// - Determines the user intent (conversion vs concrete estimation).
/// - Declares if the AI parse was successful or failed.
///
/// DEPENDENCIES:
/// - ConcreteGrade (calculator feature)
///
/// FUTURE IMPROVEMENTS:
/// - Add probability scoring for intent.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/concrete_grade.dart';

/// CLASS: AiQuery
/// PURPOSE: Data wrapper separating raw string intent into structured computable arguments.
class AiQuery {
  final double? value;
  final String? fromUnit;
  final String? toUnit;

  final double? length;
  final double? width;
  final double? depth;
  final ConcreteGrade? grade;

  /// "conversion" or "concrete"
  final String intent;

  /// Indicates if the Natural Language Engine understood the prompt.
  final bool isValid;

  /// Human-readable explanation if `isValid` is false.
  final String? errorMessage;

  const AiQuery({
    this.value,
    this.fromUnit,
    this.toUnit,
    this.length,
    this.width,
    this.depth,
    this.grade,
    required this.intent,
    this.isValid = true,
    this.errorMessage,
  });

  /// Helpful getter for checking complete concrete bounds
  bool get hasValidDimensions =>
      length != null && width != null && depth != null;
}



