/// Orchestrates the routing of a parsed query to the appropriate calculation or knowledge engine.
/// Updated to identify and return tool prefill data extracted from the query.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/ai/domain/entities/parsed_ai_input.dart';
import 'package:site_buddy/features/ai/domain/usecases/get_knowledge_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_material_usecase.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/convert_unit_usecase.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/ai_response.dart';
import 'package:site_buddy/shared/domain/models/concrete_grade.dart';
import 'package:site_buddy/core/utils/ui_formatters.dart';
import 'package:site_buddy/features/level_log/domain/usecases/level_calculation_service.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';

class ProcessAiRequestUseCase {
  final GetKnowledgeUseCase getKnowledgeUseCase;
  final CalculateMaterialUseCase calculateMaterialUseCase;
  final ConvertUnitUseCase convertUnitUseCase;
  final _levelingService = LevelCalculationService();

  ProcessAiRequestUseCase({
    required this.getKnowledgeUseCase,
    required this.calculateMaterialUseCase,
    required this.convertUnitUseCase,
  });

  Future<AiResponse> execute(ParsedAiInput parsed, {String? unitSystem}) async {
    // 1. Direct Specialized Tool Navigation (Calculators)
    if (_isQuantityToolIntent(parsed.intent)) {
      return AiResponse(
        intent: parsed.intent,
        text: _getToolMessage(parsed.intent),
        prefillData: parsed.prefillData,
      );
    }

    // 2. Handle Leveling Intent
    if (parsed.intent == AiIntent.leveling) {
      return _handleLeveling(parsed.rawQuery);
    }

    // 3. Delegate to legacy query handler for strict conversion/calculation
    if (parsed.intent == AiIntent.conversion || parsed.intent == AiIntent.calculation) {
      if (parsed.legacyQuery == null) {
        return AiResponse.unknown("Invalid query parameters detected.");
      }

      if (parsed.intent == AiIntent.conversion) {
        try {
          final res = convertUnitUseCase.execute(
            value: parsed.legacyQuery!.value ?? 0,
            fromUnit: parsed.legacyQuery!.fromUnit ?? '',
            toUnit: parsed.legacyQuery!.toUnit ?? '',
          );
          return AiResponse(
            intent: AiIntent.conversion,
            text: "Conversion processed successfully.",
            conversion: res,
            conversionFromTitle: parsed.legacyQuery!.fromUnit,
            conversionToTitle: parsed.legacyQuery!.toUnit,
          );
        } catch (e) {
          return AiResponse.unknown("Conversion error: ${e.toString()}");
        }
      } else if (parsed.intent == AiIntent.calculation) {
        var res = calculateMaterialUseCase.execute(
          length: parsed.legacyQuery!.length ?? 0,
          width: parsed.legacyQuery!.width ?? 0,
          depth: parsed.legacyQuery!.depth ?? 0,
          grade: parsed.legacyQuery!.grade ?? ConcreteGrade.m20,
        );

        if (unitSystem == 'imperial') {
          res = res.copyWith(
            volume: res.volume * 1.30795,
            dryVolume: res.dryVolume * 1.30795,
            unit: 'yd³',
          );
        }

        return AiResponse(
          intent: AiIntent.calculation,
          text: "Calculation processed successfully.",
          calculation: res,
          calculationTitle:
              "${parsed.legacyQuery!.length}x${parsed.legacyQuery!.width}x${parsed.legacyQuery!.depth}m",
        );
      }
    }

    // 4. Knowledge Base
    if (parsed.intent == AiIntent.knowledge) {
      final topic = getKnowledgeUseCase.execute(parsed.rawQuery);
      if (topic != null) {
        return AiResponse(
          intent: AiIntent.knowledge,
          text: "Knowledge base hit.",
          knowledge: topic,
        );
      } else {

        // Fallback for getting topic by title if direct search fails
        try {
          final topicByTitle = getKnowledgeUseCase.getTopicByTitle(parsed.rawQuery);
          return AiResponse(
            intent: AiIntent.knowledge,
            text: "Knowledge base hit.",
            knowledge: topicByTitle,
          );
        } catch (_) {}
      }
    }

    // 5. Fallback for other intents (projects)
    if (parsed.intent != AiIntent.unknown) {
      return AiResponse(
        intent: parsed.intent,
        text: "Request identified: ${parsed.intent.name}. Navigating to module...",
      );
    }

    return AiResponse.unknown();
  }

  bool _isQuantityToolIntent(AiIntent intent) {
    return intent == AiIntent.concreteQuantity ||
        intent == AiIntent.brickQuantity ||
        intent == AiIntent.steelWeight ||
        intent == AiIntent.excavationVolume ||
        intent == AiIntent.shutteringArea ||
        intent == AiIntent.slabDesign ||
        intent == AiIntent.beamDesign ||
        intent == AiIntent.columnDesign ||
        intent == AiIntent.footingDesign;
  }

  String _getToolMessage(AiIntent intent) {
    final name = _getToolName(intent);
    return "I detected a $name request. Would you like to launch the tool with the detected dimensions?";
  }

  String _getToolName(AiIntent intent) {
    switch (intent) {
      case AiIntent.concreteQuantity:
        return "Concrete Est.";
      case AiIntent.brickQuantity:
        return "Brick Masonry";
      case AiIntent.steelWeight:
        return "Steel Rebar";
      case AiIntent.excavationVolume:
        return "Excavation";
      case AiIntent.shutteringArea:
        return "Shuttering Area";
      case AiIntent.slabDesign:
        return "Slab Design";
      case AiIntent.beamDesign:
        return "Beam Design";
      case AiIntent.columnDesign:
        return "Column Design";
      case AiIntent.footingDesign:
        return "Footing Design";
      default:
        return "Quantity tool";
    }
  }

  Future<AiResponse> _handleLeveling(String query) async {
    final rlRegex = RegExp(r'rl\s*(\d*\.?\d+)');
    final bsRegex = RegExp(r'bs\s*(\d*\.?\d+)');
    final fsRegex = RegExp(r'fs\s*(\d*\.?\d+)');

    final lower = query.toLowerCase();

    final rlMatch = rlRegex.firstMatch(lower);
    final bsMatch = bsRegex.firstMatch(lower);
    final fsMatch = fsRegex.firstMatch(lower);

    final currentRL = rlMatch != null ? double.parse(rlMatch.group(1)!) : 100.0;
    final bs = bsMatch != null ? double.parse(bsMatch.group(1)!) : null;
    final fs = fsMatch != null ? double.parse(fsMatch.group(1)!) : null;

    try {
      final updatedEntries = _levelingService.calculateHISeries([
        LevelEntry(
          station: 'AI_Q1',
          bs: bs,
          fs: fs,
          rl: currentRL,
        ),
      ]);
      final newRL = updatedEntries.last.rl ?? currentRL;

      final text = '''
**Leveling Computation Complete**

Using HI Surveying Method:
• **Base RL**: ${UiFormatters.decimal(currentRL, fractionDigits: 3)}
• **Backsight (BS)**: ${UiFormatters.decimal(bs, fractionDigits: 3, fallback: '0.000')}
• **Foresight (FS)**: ${UiFormatters.decimal(fs, fractionDigits: 3, fallback: '0.000')}

**Calculated New RL**: ${UiFormatters.decimal(newRL, fractionDigits: 3)}
'''
          .trim();

      return AiResponse(text: text, intent: AiIntent.leveling);
    } catch (e) {
      return AiResponse.unknown(
        "I detected a leveling request, but calculation failed. Try supplying strict arguments like: 'RL 100, BS 1.2, FS 0.8'.",
      );
    }
  }
}
