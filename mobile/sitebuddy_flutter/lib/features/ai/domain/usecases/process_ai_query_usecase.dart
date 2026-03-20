// Pure logic orchestrator for AI chat interactions.
// ----------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/features/ai/domain/usecases/ai_intent_router_usecase.dart';
import 'package:site_buddy/core/utils/ui_formatters.dart';
import 'package:site_buddy/features/level_log/domain/usecases/level_calculation_service.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/features/ai/domain/repositories/assistant_repository.dart';
import 'package:site_buddy/features/ai/data/repositories/assistant_repository_impl.dart';

/// PROVIDER: processAiQueryUseCaseProvider
final processAiQueryUseCaseProvider = Provider<ProcessAiQueryUseCase>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  final assistantRepo = ref.watch(assistantRepositoryProvider);
  return ProcessAiQueryUseCase(connectivity, assistantRepo);
});

class ProcessAiQueryUseCase {
  final ConnectivityService _connectivity;
  final AssistantRepository _assistantRepo;
  final _levelingService = LevelCalculationService();
  final _routerUseCase = AiIntentRouterUseCase();

  ProcessAiQueryUseCase(this._connectivity, this._assistantRepo);

  Future<({String text, AiIntent intent})> execute(String query) async {
    // 1. Connectivity Check for Backend Hook
    if (await _connectivity.isOnline) {
      final backendResult = await _assistantRepo.query(query);
      if (backendResult != null) {
        return backendResult;
      }
      // Fallback to local logic on backend failure or null response
    }

    // 2. Local Intent Fallback
    final result = _routerUseCase.parse(query);
    final intent = result.intent;

    // Simple textual mapping for the legacy chat interface
    switch (intent) {
      case AiIntent.calculateConcrete:
      case AiIntent.concreteQuantity:
        return (
          text: "I can help you calculate concrete quantities! Would you like to open the Concrete Estimator tool?",
          intent: intent,
        );
      case AiIntent.brickQuantity:
        return (
          text: "I detected a request for brick masonry estimation. You can use our specialized Brick Wall Estimator for precise results.",
          intent: intent,
        );
      case AiIntent.steelWeight:
        return (
          text: "Need to calculate rebar weight? Our Steel Weight Estimator can handle standard diameters and spacing for you.",
          intent: intent,
        );
      case AiIntent.excavationVolume:
        return (
          text: "I can assist with excavation volume and swell factors. Shall we open the Excavation Estimator?",
          intent: intent,
        );
      case AiIntent.shutteringArea:
        return (
          text: "For formwork and shuttering area calculations, our dedicated tool is the best way to get accurate site numbers.",
          intent: intent,
        );
      case AiIntent.leveling:
        return _handleLeveling(query);
      case AiIntent.createProject:
        return (
          text: "I've drafted a new project for you based on your request. Initiating creation sequence...",
          intent: intent,
        );
      case AiIntent.addToProject:
        return (
          text: "Linking your most recent calculations to the specified project timeline...",
          intent: intent,
        );
      case AiIntent.fetchProject:
        return (
          text: "Checking the database for your requested project details...",
          intent: intent,
        );
      default:
        return (
          text: "I'm your Site Buddy assistant. Try asking about brick walls, concrete, or leveling.",
          intent: intent,
        );
    }
  }

  Future<({String text, AiIntent intent})> _handleLeveling(String query) async {
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

      return (text: text, intent: AiIntent.leveling);
    } catch (e) {
      return (
        text: "I detected a leveling request, but calculation failed. Try supplying strict arguments like: 'RL 100, BS 1.2, FS 0.8'.",
        intent: AiIntent.unknown,
      );
    }
  }
}



