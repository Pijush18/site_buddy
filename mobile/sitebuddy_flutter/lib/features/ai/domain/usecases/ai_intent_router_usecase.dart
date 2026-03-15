/// Analyzes raw user NLP strings strictly to evaluate and route to a defined `AiIntent`.
/// Now enhanced with `QueryParameterParser` to extract numeric dimensions.
/// ----------------------------------------------
library;

import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/ai_intent_result.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:site_buddy/shared/domain/services/query_parameter_parser.dart';

class AiIntentRouterUseCase {
  final QueryParameterParser _parser = QueryParameterParser();

  /// METHOD: parse
  /// PURPOSE: Evaluates string queries against mapped functional keywords.
  /// RETURNS: `AiIntentResult` containing intent and optional parameters.
  AiIntentResult parse(String query) {
    final lower = query.toLowerCase().trim();
    final params = _parser.parse(query);
    final hasNumbers = params.values.isNotEmpty;

    // 1. Structural Design Modules (Design..., Reinforce...) - HIGHEST PRIORITY
    final isDesignQuery =
        lower.contains('design') ||
        lower.contains('reinforce') ||
        lower.contains('analysis');

    // Structural Design: Slab
    if (lower.contains('slab')) {
      if (isDesignQuery || !hasNumbers) {
        SlabDesignPrefillData? prefill;
        if (params.values.isNotEmpty) {
          prefill = SlabDesignPrefillData(
            lx: params.values.isNotEmpty ? params.values[0] : null,
            ly: params.values.length > 1 ? params.values[1] : null,
            depth: params.values.length > 2 ? params.values[2] : null,
          );
        }
        return AiIntentResult(intent: AiIntent.slabDesign, parameters: prefill);
      } else {
        // Fallback to calculation if numbers are present but not explicit design
        return const AiIntentResult(intent: AiIntent.calculation);
      }
    }

    // Structural Design: Beam
    if (lower.contains('beam')) {
      if (isDesignQuery || !hasNumbers) {
        BeamDesignPrefillData? prefill;
        if (params.values.isNotEmpty) {
          prefill = BeamDesignPrefillData(
            length: params.values.isNotEmpty ? params.values[0] : null,
            width: params.values.length > 1 ? params.values[1] : null,
            depth: params.values.length > 2 ? params.values[2] : null,
          );
        }
        return AiIntentResult(intent: AiIntent.beamDesign, parameters: prefill);
      }
      return const AiIntentResult(intent: AiIntent.calculation);
    }

    // Structural Design: Column
    if (lower.contains('column')) {
      ColumnDesignPrefillData? prefill;
      if (params.values.isNotEmpty) {
        prefill = ColumnDesignPrefillData(
          width: params.values.isNotEmpty ? params.values[0] : null,
          depth: params.values.length > 1 ? params.values[1] : null,
          height: params.values.length > 2 ? params.values[2] : null,
        );
      }
      return AiIntentResult(intent: AiIntent.columnDesign, parameters: prefill);
    }

    // Structural Design: Footing
    if (lower.contains('footing') || lower.contains('foundation')) {
      FootingDesignPrefillData? prefill;
      if (params.values.isNotEmpty) {
        prefill = FootingDesignPrefillData(
          length: params.values.isNotEmpty ? params.values[0] : null,
          width: params.values.length > 1 ? params.values[1] : null,
          depth: params.values.length > 2 ? params.values[2] : null,
        );
      }
      return AiIntentResult(intent: AiIntent.footingDesign, parameters: prefill);
    }

    // 2. Calculator / Quantity Check - SECOND PRIORITY
    // Concrete Quantity Tool (Calculators)
    if (lower.contains('concrete') || lower.contains('cement')) {
      ConcretePrefillData? prefill;
      if (params.values.isNotEmpty) {
        prefill = ConcretePrefillData(
          length: params.values.isNotEmpty ? params.values[0] : null,
          width: params.values.length > 1 ? params.values[1] : null,
          thickness: params.values.length > 2 ? params.values[2] : null,
        );
      }
      return AiIntentResult(
        intent: AiIntent.concreteQuantity,
        parameters: prefill,
      );
    }

    // Brick Quantity Tool
    if (lower.contains('brick') || lower.contains('masonry')) {
      BrickPrefillData? prefill;
      if (params.values.isNotEmpty) {
        prefill = BrickPrefillData(
          length: params.values.isNotEmpty ? params.values[0] : null,
          height: params.values.length > 1 ? params.values[1] : null,
          thickness: params.values.length > 2 ? params.values[2] : null,
        );
      }
      return AiIntentResult(intent: AiIntent.brickQuantity, parameters: prefill);
    }

    // Steel Weight Tool
    if (lower.contains('rebar') ||
        lower.contains('steel') ||
        lower.contains('weight')) {
      SteelWeightPrefillData? prefill;
      if (params.values.isNotEmpty) {
        prefill = SteelWeightPrefillData(
          length: params.values.isNotEmpty ? params.values[0] : null,
          diameter: params.values.length > 1 ? params.values[1] : null,
          spacing: params.values.length > 2 ? params.values[2] : null,
        );
      }
      return AiIntentResult(intent: AiIntent.steelWeight, parameters: prefill);
    }

    // Excavation Tool
    if (lower.contains('excavation') ||
        lower.contains('earthwork') ||
        lower.contains('pit')) {
      ExcavationPrefillData? prefill;
      if (params.values.isNotEmpty) {
        prefill = ExcavationPrefillData(
          length: params.values.isNotEmpty ? params.values[0] : null,
          width: params.values.length > 1 ? params.values[1] : null,
          depth: params.values.length > 2 ? params.values[2] : null,
        );
      }
      return AiIntentResult(
        intent: AiIntent.excavationVolume,
        parameters: prefill,
      );
    }

    // Shuttering Area Tool
    if (lower.contains('shuttering') ||
        lower.contains('formwork') ||
        lower.contains('centring')) {
      ShutteringPrefillData? prefill;
      if (params.values.isNotEmpty) {
        prefill = ShutteringPrefillData(
          length: params.values.isNotEmpty ? params.values[0] : null,
          width: params.values.length > 1 ? params.values[1] : null,
          depth: params.values.length > 2 ? params.values[2] : null,
        );
      }
      return AiIntentResult(
        intent: AiIntent.shutteringArea,
        parameters: prefill,
      );
    }

    // Explicit Calculation/Quantity Generic Check
    final isCalculationQuery =
        lower.contains('calc') ||
        lower.contains('quantity') ||
        lower.contains('estimate') ||
        lower.contains('how much') ||
        lower.contains('how many') ||
        lower.contains('total');

    if (hasNumbers && isCalculationQuery) {
      if (lower.contains('concrete') ||
          lower.contains('slab') ||
          lower.contains('beam')) {
        return const AiIntentResult(intent: AiIntent.calculation);
      }
    }

    // 3. Knowledge / Explicit Query Check - LOWEST PRIORITY
    if (lower.startsWith('what is') ||
        lower.startsWith('explain') ||
        lower.startsWith('tell me about')) {
      return const AiIntentResult(intent: AiIntent.knowledge);
    }

    final levelingRegex = RegExp(r'\b(rl|bs|fs|level)\b');
    if (levelingRegex.hasMatch(lower)) {
      return const AiIntentResult(intent: AiIntent.leveling);
    }

    // Final fallback: if there are numbers, try calculation
    if (params.values.length >= 2) {
      return const AiIntentResult(intent: AiIntent.calculation);
    }

    return const AiIntentResult(intent: AiIntent.unknown);
  }
}
