/// FILE HEADER
/// ----------------------------------------------
/// File: ai_response.dart
/// Feature: ai_assistant
/// Layer: domain/entities
///
/// PURPOSE:
/// The structured aggregate model summarizing the final outcome of the
/// AI assistant query processing pipeline.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';
import 'package:site_buddy/shared/domain/models/material_result.dart';
import 'package:site_buddy/shared/domain/models/conversion_result.dart';

/// Aggregates the evaluated result from the AI parser and downstream engines.
class AiResponse {
  /// The detected intent of the original query.
  final AiIntent intent;

  /// Hydrated if the intent was [AiIntent.knowledge].
  final KnowledgeTopic? knowledge;

  /// Hydrated if the intent was [AiIntent.conversion].
  final ConversionResult? conversion;

  /// Hydrated if the intent was [AiIntent.calculation].
  final MaterialResult? calculation;

  /// Holds the original 'from' representation for UI rendering.
  final String? conversionFromTitle;

  /// Holds the original 'to' representation for UI rendering.
  final String? conversionToTitle;

  /// Holds the original dimensions representation for UI rendering.
  final String? calculationTitle;

  /// Hydrated if an error occurred during parsing or calculation, or if unknown.
  final String? error;

  const AiResponse({
    required this.intent,
    this.knowledge,
    this.conversion,
    this.calculation,
    this.conversionFromTitle,
    this.conversionToTitle,
    this.calculationTitle,
    this.error,
  });

  /// Factory constructor for quickly generating an unknown/error response.
  factory AiResponse.unknown([String? message]) {
    return AiResponse(
      intent: AiIntent.unknown,
      error:
          message ??
          'I could not understand that query. Try asking "what is a slab" or "10 ft to m".',
    );
  }

  @override
  String toString() {
    if (error != null) return 'AiResponse Error: $error';
    final buffer = StringBuffer();
    buffer.write('AiResponse intent: ${intent.name}');
    if (knowledge != null) buffer.write(', knowledge: ${knowledge!.title}');
    if (conversion != null) {
      buffer.write(', conversion: ${conversion!.mainValue}');
    }
    if (calculation != null) {
      buffer.write(', calculation: ${calculation.toString()}');
    }
    return buffer.toString();
  }
}
