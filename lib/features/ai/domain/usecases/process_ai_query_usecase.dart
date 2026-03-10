/// FILE HEADER
/// ----------------------------------------------
/// File: process_ai_query_usecase.dart
/// Feature: ai
/// Layer: domain
///
/// PURPOSE:
/// The primary logic orchestrator matching detected AI intents to real feature domains.
///
/// RESPONSIBILITIES:
/// - Transforms strings into `AiIntent` pointers.
/// - Determines the required parameters for calculating logic.
/// - Returns a structured tuple combining the response text and the executed intent for downstream Riverpod state reactions.
///
/// DEPENDENCIES:
/// - `AiService` (mock JSON NLP parser)
/// - `CalculateMaterialUseCase` (deterministic fallback)
/// - `CalculateRlUseCase` (leveling metrics)
/// - `AiIntentRouterUseCase`
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/features/ai/domain/usecases/ai_intent_router_usecase.dart';
import 'package:site_buddy/features/ai/application/services/ai_service.dart';
import 'package:site_buddy/core/utils/ui_formatters.dart';
import 'package:site_buddy/shared/domain/models/concrete_grade.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_material_usecase.dart';
import 'package:site_buddy/features/levelling_log/domain/usecases/levelling_calculator.dart';
import 'package:site_buddy/features/levelling_log/domain/entities/levelling_entry.dart';

/// CLASS: ProcessAiQueryUseCase
/// PURPOSE: Core intelligence layer.
class ProcessAiQueryUseCase {
  final _aiService = AiService();
  final _calculatorUseCase = CalculateMaterialUseCase();
  final _levelingService = LevellingCalculator();
  final _routerUseCase = AiIntentRouterUseCase();

  /// METHOD: execute
  /// PURPOSE: Evaluates the raw user text input and processes the attached domain calculation.
  /// RETURNS:
  /// - A Record containing `(String text, AiIntent intent)` to dictate how the `AiController` must react.
  Future<({String text, AiIntent intent})> execute(String query) async {
    final intent = _routerUseCase.parse(query);

    switch (intent) {
      case AiIntent.calculateConcrete:
        return _handleConcrete(query);
      case AiIntent.leveling:
        return _handleLeveling(query);
      case AiIntent.createProject:
        return (
          text:
              "I've drafted a new project for you based on your request. Initiating creation sequence...",
          intent: intent,
        );
      case AiIntent.addToProject:
        return (
          text:
              "Linking your most recent calculations to the specified project timeline...",
          intent: intent,
        );
      case AiIntent.fetchProject:
        return (
          text: "Checking the database for your requested project details...",
          intent: intent,
        );
      case AiIntent.knowledge:
      case AiIntent.conversion:
      case AiIntent.calculation:
      case AiIntent.unknown:
        return (
          text:
              "I'm your Site Buddy assistant. Try something explicit like: '10x5 slab M20' or 'Create project Bridge A'. Real LLMs coming soon!",
          intent: intent,
        );
    }
  }

  Future<({String text, AiIntent intent})> _handleConcrete(String query) async {
    // Rely on existing mock JSON parse logic
    final result = await _aiService.parseInput(query);

    if (result.isValid &&
        result.length != null &&
        result.width != null &&
        result.depth != null) {
      // Execute rigid legacy calculator
      final calcResult = _calculatorUseCase.execute(
        length: result.length!,
        width: result.width!,
        depth: result.depth!,
        grade: result.grade ?? ConcreteGrade.m20,
      );

      final text =
          '''
**Concrete Calculation Verified**

Here are the specific material requirements for your ${result.length}x${result.width}x${result.depth}m pour (${result.grade?.label ?? 'M20'}):

• **Total Volume**: ${UiFormatters.decimal(calcResult.volume, fractionDigits: 2)} m³
• **Cement Count**: ${calcResult.cementBags} bags (50kg)

*Please ensure a 5% safety margin on cement ordering.*
'''
              .trim();
      return (text: text, intent: AiIntent.calculateConcrete);
    }

    return (
      text:
          "I detected a concrete/slab intent, but I need strict measurements. Try: '10x5 slab with 0.15m depth M20'",
      intent: AiIntent.unknown,
    );
  }

  Future<({String text, AiIntent intent})> _handleLeveling(String query) async {
    // Rudimentary mock regex extraction to demonstrate the architecture
    final rlRegex = RegExp(r'rl\s*(\d*\.?\d+)');
    final bsRegex = RegExp(r'bs\s*(\d*\.?\d+)');
    final fsRegex = RegExp(r'fs\s*(\d*\.?\d+)');

    final lower = query.toLowerCase();

    // We arbitrarily default RL to 100.0 if not provided just for demonstration purposes
    final rlMatch = rlRegex.firstMatch(lower);
    final bsMatch = bsRegex.firstMatch(lower);
    final fsMatch = fsRegex.firstMatch(lower);

    final currentRL = rlMatch != null ? double.parse(rlMatch.group(1)!) : 100.0;
    final bs = bsMatch != null ? double.parse(bsMatch.group(1)!) : null;
    final fs = fsMatch != null ? double.parse(fsMatch.group(1)!) : null;

    try {
      final res = _levelingService.calculate(
        benchmarkRL: currentRL,
        entries: [
          LevellingEntry(station: 'AI_Q1', bs: bs, fs: fs, isReading: 0.0),
        ],
      );
      final newRL = res.updatedEntries.last.rl ?? currentRL;

      final text =
          '''
**Leveling Computation Complete**

Using HI Surveying Method:
• **Base RL**: ${UiFormatters.decimal(currentRL, fractionDigits: 3)}
• **Backsight (BS)**: ${UiFormatters.decimal(bs, fractionDigits: 3, fallback: '0.000')}
• **Foresight (FS)**: ${UiFormatters.decimal(fs, fractionDigits: 3, fallback: '0.000')}

**Calculated New RL**: ${UiFormatters.decimal(newRL, fractionDigits: 3)}
'''
              .trim();

      return (text: text, intent: AiIntent.leveling);
    } catch (e) {
      return (
        text:
            "I detected a leveling request, but calculation failed. Try supplying strict arguments like: 'RL 100, BS 1.2, FS 0.8'.",
        intent: AiIntent.unknown,
      );
    }
  }
}
