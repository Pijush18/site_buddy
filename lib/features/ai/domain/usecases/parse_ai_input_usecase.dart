/// FILE HEADER
/// ----------------------------------------------
/// File: parse_ai_input_usecase.dart
/// Feature: ai_assistant
/// Layer: domain/usecases
///
/// PURPOSE:
/// Detects the intent of the user's natural language input.
/// Expanded to aggressively detect thumb rule queries ("size", "rule", "thickness").
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/features/ai/domain/entities/parsed_ai_input.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/parse_ai_query_usecase.dart';
import 'package:site_buddy/core/data/knowledge_base.dart';

/// CLASS: ParseAiInputUseCase
/// PURPOSE: Root NLP parser for the Smart Assistant.
class ParseAiInputUseCase {
  final ParseAiQueryUseCase _legacyParser;

  const ParseAiInputUseCase(this._legacyParser);

  ParsedAiInput execute(String query) {
    if (query.trim().isEmpty) {
      return ParsedAiInput(intent: AiIntent.unknown, rawQuery: query);
    }

    final lower = query.toLowerCase().trim();

    // 1. Delegate to legacy parser first for strict engineering patterns (dimensions/conversions)
    final legacyResult = _legacyParser.execute(query);

    if (legacyResult.isValid) {
      if (legacyResult.intent == 'conversion') {
        return ParsedAiInput(
          intent: AiIntent.conversion,
          rawQuery: query,
          legacyQuery: legacyResult,
        );
      } else if (legacyResult.intent == 'concrete') {
        return ParsedAiInput(
          intent: AiIntent.calculation,
          rawQuery: query,
          legacyQuery: legacyResult,
        );
      }
    }

    // 2. Detect Knowledge Intent if no strict engineering match found
    if (lower.startsWith('what is') ||
        lower.startsWith('define') ||
        lower.startsWith('explain') ||
        lower.startsWith('tell me about') ||
        lower.contains('rule') ||
        lower.contains('size') ||
        lower.contains('thickness') ||
        KnowledgeBase.findTopic(lower) != null) {
      return ParsedAiInput(intent: AiIntent.knowledge, rawQuery: query);
    }

    // 3. Fallback unknown
    return ParsedAiInput(intent: AiIntent.unknown, rawQuery: query);
  }
}
