/// FILE HEADER
/// ----------------------------------------------
/// File: ai_intent_router_usecase.dart
/// Feature: ai
/// Layer: domain
///
/// PURPOSE:
/// Analyzes raw user NLP strings strictly to evaluate and route to a defined `AiIntent`.
///
/// RESPONSIBILITIES:
/// - Uses keyword extraction mapping directly to application feature endpoints.
/// - Keeps complex string comparison blocks out of the controller logic.
///
/// DEPENDENCIES:
/// - `AiIntent` (Domain Enum)
///
library;

/// - Replace the RegEx/Rule-Based parser with a true LLM parameter classification pipeline (Gemini/OpenAI).
/// ----------------------------------------------


import 'package:site_buddy/shared/domain/models/ai_intent.dart';

/// CLASS: AiIntentRouterUseCase
/// PURPOSE: Natural language parser designating execution flow.
class AiIntentRouterUseCase {
  /// METHOD: parse
  /// PURPOSE: Evaluates string queries against mapped functional keywords.
  /// PARAMETERS:
  /// - `query`: Raw user string
  /// RETURNS:
  /// - `AiIntent`: Bound functional pointer.
  /// LOGIC:
  /// - Normalizes input to lowercase.
  /// - Sequentially tests RegEx structures (e.g., precise "create project" logic vs general "project").
  AiIntent parse(String query) {
    final lower = query.toLowerCase().trim();

    // Context bounds must be checked explicitly.
    // E.g. "Create project" must hit before just "project" matches `fetchProject`.
    if (lower.contains('create') && lower.contains('project')) {
      return AiIntent.createProject;
    }

    if (lower.contains('add') &&
        (lower.contains('to') || lower.contains('project'))) {
      return AiIntent.addToProject;
    }

    if (lower.contains('show') && lower.contains('project')) {
      return AiIntent.fetchProject;
    }

    if (lower.contains('slab') ||
        lower.contains('concrete') ||
        lower.contains('cement')) {
      return AiIntent.calculateConcrete;
    }

    // RegEx checking exact surveying bounds: \b prevents "girl" from triggering "rl".
    final levelingRegex = RegExp(r'\b(rl|bs|fs|level)\b');
    if (levelingRegex.hasMatch(lower)) {
      return AiIntent.leveling;
    }

    // Unrecognized intent routes to helpful conversational fallback text.
    return AiIntent.unknown;
  }
}
