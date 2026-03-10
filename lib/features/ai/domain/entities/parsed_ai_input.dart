/// FILE HEADER
/// ----------------------------------------------
/// File: parsed_ai_input.dart
/// Feature: ai_assistant
/// Layer: domain/entities
///
/// PURPOSE:
/// Intermediate model holding the extracted payload from the NLP parser
/// before it is routed to the processing engines.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/ai_query.dart';

class ParsedAiInput {
  final AiIntent intent;
  final String rawQuery;

  /// Holds conversion/calculation parsed parameters from the legacy parser.
  final AiQuery? legacyQuery;

  const ParsedAiInput({
    required this.intent,
    required this.rawQuery,
    this.legacyQuery,
  });
}
