/// FILE HEADER
/// ----------------------------------------------
/// File: process_ai_request_usecase.dart
/// Feature: ai_assistant
/// Layer: domain/usecases
///
/// PURPOSE:
/// Orchestrates the routing of a parsed query to the appropriate calculation or knowledge engine.
/// Adapted to parse thumb rule variables natively and compile extended knowledge responses safely.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/ai_response.dart';
import 'package:site_buddy/features/ai/domain/entities/parsed_ai_input.dart';
import 'package:site_buddy/features/ai/domain/usecases/get_knowledge_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_material_usecase.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/convert_unit_usecase.dart';

import 'package:site_buddy/core/enums/unit_system.dart';

/// CLASS: ProcessAiRequestUseCase
/// PURPOSE: Execute deterministic engineering logic based on parsed intent.
class ProcessAiRequestUseCase {
  final GetKnowledgeUseCase _getKnowledgeUseCase;
  final CalculateMaterialUseCase _calculateMaterialUseCase;
  final ConvertUnitUseCase _convertUnitUseCase;

  const ProcessAiRequestUseCase({
    required GetKnowledgeUseCase getKnowledgeUseCase,
    required CalculateMaterialUseCase calculateMaterialUseCase,
    required ConvertUnitUseCase convertUnitUseCase,
  }) : _getKnowledgeUseCase = getKnowledgeUseCase,
       _calculateMaterialUseCase = calculateMaterialUseCase,
       _convertUnitUseCase = convertUnitUseCase;

  AiResponse execute(ParsedAiInput parsed, {UnitSystem? unitSystem}) {
    switch (parsed.intent) {
      case AiIntent.knowledge:
        // Strip out question prefixes and intent keywords to isolate the raw structural noun
        var term = parsed.rawQuery.toLowerCase().trim();
        term = term.replaceAll('what is ', '');
        term = term.replaceAll('what is a ', '');
        term = term.replaceAll('define ', '');
        term = term.replaceAll('explain ', '');
        term = term.replaceAll('thickness ', '');
        term = term.replaceAll(' size ', ' ');
        term = term.replaceAll(' rule ', ' ');
        term = term.replaceAll('?', '');

        final topic = _getKnowledgeUseCase.execute(term.trim());

        if (topic != null) {
          // Identify if the query was specifically asking for thumb rules,
          // allowing the UI to flag or auto-scroll to the highlighted box if desired.
          // For now, returning the unified structured data packet is sufficient.
          return AiResponse(intent: AiIntent.knowledge, knowledge: topic);
        }

        // If we hit knowledge intent, but the term couldn't map, check if it's an unrecognized phrase.
        return AiResponse.unknown(
          "I couldn't find knowledge on '${parsed.rawQuery}'. Try searching for core elements like 'slab', 'footing', or 'beam size'.",
        );

      case AiIntent.conversion:
        final query = parsed.legacyQuery;
        if (query == null ||
            query.value == null ||
            query.fromUnit == null ||
            query.toUnit == null) {
          return AiResponse.unknown("Incomplete conversion details.");
        }

        try {
          final result = _convertUnitUseCase.execute(
            value: query.value!,
            fromUnit: query.fromUnit!,
            toUnit: query.toUnit!,
          );
          return AiResponse(intent: AiIntent.conversion, conversion: result);
        } catch (e) {
          return AiResponse.unknown(e.toString().replaceAll('Exception: ', ''));
        }

      case AiIntent.calculation:
        final query = parsed.legacyQuery;
        if (query == null ||
            query.length == null ||
            query.width == null ||
            query.depth == null ||
            query.grade == null) {
          return AiResponse.unknown("Incomplete calculation dimensions.");
        }

        try {
          var result = _calculateMaterialUseCase.execute(
            length: query.length!,
            width: query.width!,
            depth: query.depth!,
            grade: query.grade!,
          );

          // INTEGRATION: Imperial Override Logic
          if (unitSystem == UnitSystem.imperial) {
            final imperialVolume = _convertUnitUseCase.execute(
              value: result.volume,
              fromUnit: 'm3',
              toUnit: 'yd3',
            );

            final imperialDryVolume = _convertUnitUseCase.execute(
              value: result.dryVolume,
              fromUnit: 'm3',
              toUnit: 'yd3',
            );

            // Re-map the result to imperial labels for the AI response
            result = result.copyWith(
              volume: imperialVolume.mainValue,
              dryVolume: imperialDryVolume.mainValue,
              unit: 'yd³',
            );
          } else {
            result = result.copyWith(unit: 'm³');
          }

          return AiResponse(intent: AiIntent.calculation, calculation: result);
        } catch (e) {
          return AiResponse.unknown(e.toString().replaceAll('Exception: ', ''));
        }

      case AiIntent.unknown:
      case AiIntent.calculateConcrete:
      case AiIntent.createProject:
      case AiIntent.addToProject:
      case AiIntent.fetchProject:
      case AiIntent.leveling:
        return AiResponse.unknown(
          "Couldn't understand. Try asking 'What is a retaining wall?' or 'Beam size thumb rule'.",
        );
    }
  }
}
