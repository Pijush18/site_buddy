/// Detects the intent of the user's natural language input.
/// Enhanced to identify specialized quantity tools with prefill parameters.
/// ----------------------------------------------
library;

import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/features/ai/domain/entities/parsed_ai_input.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/parse_ai_query_usecase.dart';
import 'package:site_buddy/core/services/knowledge_service.dart';
import 'package:site_buddy/features/ai/domain/usecases/ai_intent_router_usecase.dart';

class ParseAiInputUseCase {
  final ParseAiQueryUseCase _legacyParser;
  final KnowledgeService _knowledgeService;
  final AiIntentRouterUseCase _router = AiIntentRouterUseCase();

  ParseAiInputUseCase(this._legacyParser, this._knowledgeService);



  ParsedAiInput execute(String query) {
    if (query.trim().isEmpty) {
      return ParsedAiInput(intent: AiIntent.unknown, rawQuery: query);
    }

    final lower = query.toLowerCase().trim();

    // 1. Check for Specialized Quantity Tools & Design Modules (Tools with Navigation + Prefill)
    // Priority 1: Specific tools
    final routerResult = _router.parse(query);
    if (routerResult.intent != AiIntent.unknown &&
        routerResult.intent != AiIntent.createProject &&
        routerResult.intent != AiIntent.addToProject &&
        routerResult.intent != AiIntent.fetchProject &&
        routerResult.intent != AiIntent.leveling &&
        routerResult.intent != AiIntent.knowledge && // Skip if router explicitly said knowledge (unlikely but safe)
        routerResult.intent != AiIntent.calculation) { // New: let router handle calculation if it found dimensions + keywords
      return ParsedAiInput(
        intent: routerResult.intent,
        rawQuery: query,
        prefillData: routerResult.parameters,
      );
    }
    
    // Check if router *explicitly* said it's a calculation (logic added recently to AiIntentRouterUseCase)
    if (routerResult.intent == AiIntent.calculation) {
       // We'll still check legacy parser below for better pattern matching, 
       // but router can flag it as calculation if it has 'calculate' keyword.
    }

    // 2. Delegate to legacy parser for strict engineering patterns (dimensions/conversions)
    // Priority 2: Precise math
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

    // 3. Detect Knowledge Intent (After trying specific tools/math)
    // Priority 3: General information
    if (lower.startsWith('what is') ||
        lower.startsWith('define') ||
        lower.startsWith('explain') ||
        lower.startsWith('meaning of') ||
        lower.startsWith('tell me about') ||
        lower.contains('rule') ||
        _knowledgeService.findTopic(lower) != null) {
      return ParsedAiInput(intent: AiIntent.knowledge, rawQuery: query);
    }


    // 4. Handle other router intents (projects, leveling) if they match
    if (routerResult.intent != AiIntent.unknown && routerResult.intent != AiIntent.calculation) {
      return ParsedAiInput(
        intent: routerResult.intent,
        rawQuery: query,
        prefillData: routerResult.parameters,
      );
    }

    // 5. Fallback unknown
    return ParsedAiInput(intent: AiIntent.unknown, rawQuery: query);
  }
}



