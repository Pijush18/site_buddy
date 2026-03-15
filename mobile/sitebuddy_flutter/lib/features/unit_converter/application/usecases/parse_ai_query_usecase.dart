/// FILE HEADER
/// ----------------------------------------------
/// File: parse_ai_query_usecase.dart
/// Feature: unit_converter
/// Layer: application/usecases
///
/// PURPOSE:
/// Evaluates raw natural language input and extracts structured parameters.
///
/// RESPONSIBILITIES:
/// - RegEx pattern matching against common engineering shorthand syntax.
/// - Determines the intent: 'conversion' vs 'concrete'.
/// - Returns invalid AiQuery wrappers on parse failures.
///
/// DEPENDENCIES:
/// - `AiQuery` Domain model
/// - `ConcreteGrade`
///
/// FUTURE IMPROVEMENTS:
/// - Wire to an actual LLM endpoint for unbounded querying.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_query.dart';
import 'package:site_buddy/shared/domain/models/concrete_grade.dart';

/// CLASS: ParseAiQueryUseCase
/// PURPOSE: NLP RegEx parser returning strictly typed data.
class ParseAiQueryUseCase {
  const ParseAiQueryUseCase();

  AiQuery execute(String query) {
    final lower = query.toLowerCase().trim();

    // Strategy 1: Look for Concrete Estimation patterns. (e.g., 10x5x0.2 slab m20)
    // Matches: [num] x [num] x [num] (optional spaces around 'x' or '*')
    final dimsRegex = RegExp(
      r'([\d\.]+)\s*[x\*]\s*([\d\.]+)\s*[x\*]\s*([\d\.]+)',
    );
    final dimsMatch = dimsRegex.firstMatch(lower);

    if (dimsMatch != null) {
      final l = double.tryParse(dimsMatch.group(1)!);
      final w = double.tryParse(dimsMatch.group(2)!);
      final d = double.tryParse(dimsMatch.group(3)!);

      ConcreteGrade? grade;
      if (lower.contains('m15')) grade = ConcreteGrade.m15;
      if (lower.contains('m20')) grade = ConcreteGrade.m20;
      if (lower.contains('m25')) grade = ConcreteGrade.m25;

      // Defaulting grade to M20 if none specified but dimensions matched logic
      grade ??= ConcreteGrade.m20;

      return AiQuery(
        intent: 'concrete',
        length: l,
        width: w,
        depth: d,
        grade: grade,
      );
    }

    // Strategy 2: Look for Unit Conversions. (e.g., 10 ft to meter)
    // Matches: [num] [string] to [string]
    final convertRegex = RegExp(
      r'([\d\.]+)\s+([a-zA-Z23]+)\s+(?:to|in)\s+([a-zA-Z23]+)',
    );
    final convertMatch = convertRegex.firstMatch(lower);

    if (convertMatch != null) {
      final v = double.tryParse(convertMatch.group(1)!);
      final from = convertMatch.group(2);
      final to = convertMatch.group(3);

      return AiQuery(
        intent: 'conversion',
        value: v,
        fromUnit: from,
        toUnit: to,
      );
    }

    // Strategy 3: Loose conversion matching without "to"
    // (e.g. "100 mm cm") -> Convert 100mm to cm
    final looseRegex = RegExp(r'([\d\.]+)\s+([a-zA-Z23]+)\s+([a-zA-Z23]+)');
    final looseMatch = looseRegex.firstMatch(lower);

    if (looseMatch != null) {
      final v = double.tryParse(looseMatch.group(1)!);
      final from = looseMatch.group(2);
      final to = looseMatch.group(3);

      return AiQuery(
        intent: 'conversion',
        value: v,
        fromUnit: from,
        toUnit: to,
      );
    }

    // Unrecognized intent -> Fallback trigger
    return const AiQuery(
      intent: 'unknown',
      isValid: false,
      errorMessage: "Unable to understand input",
    );
  }
}
