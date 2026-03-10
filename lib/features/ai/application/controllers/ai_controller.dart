/// FILE HEADER
/// ----------------------------------------------
/// File: ai_controller.dart
/// Feature: ai
/// Layer: application
///
/// PURPOSE:
/// Coordinates user NLP interactions with the AI parsing service and existing material calculator business logic.
///
/// RESPONSIBILITIES:
/// - Connects the `AiAssistantWidget` to the `AiService`.
/// - Pushes results from `AiService` downstream into `CalculateMaterialUseCase`.
/// - Manages loading bounds via `AiState`.
///
/// DEPENDENCIES:
/// - Riverpod NotifierProvider.
/// - AiState, AiService, CalculateMaterialUseCase.
///
/// FUTURE IMPROVEMENTS:
/// - Inject `AiService` as an interface to swap Mock and Real endpoints smoothly based on `Flavor` builds.
/// ----------------------------------------------
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:site_buddy/features/ai/application/controllers/ai_state.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/features/ai/domain/entities/ai_message.dart';
import 'package:site_buddy/features/ai/domain/usecases/process_ai_query_usecase.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

/// PROVIDER: aiProvider
/// PURPOSE: Primary consumer access point for the Chat Assistant session.
final aiProvider = NotifierProvider<AiController, AiState>(AiController.new);

/// CLASS: AiController
/// PURPOSE: Orchestrates continuous user messaging with background NLP parsing.
class AiController extends Notifier<AiState> {
  final _queryProcessor = ProcessAiQueryUseCase();
  final _uuid = const Uuid();

  @override
  AiState build() {
    return AiState.initial();
  }

  /// METHOD: sendMessage
  /// PURPOSE: Core pipeline injecting users text into history and awaiting background LLM results.
  /// PARAMETERS:
  /// - `text`: String value directly from the Chat input bar.
  /// RETURNS: `Future<void>`
  Future<void> sendMessage(String text) async {
    final queryText = text.trim();
    if (queryText.isEmpty) return;

    // 1. Immediately inject user's message into history and lock UI
    final userMessage = AiMessage(
      id: _uuid.v4(),
      text: queryText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      isLoading: true,
      messages: [...state.messages, userMessage],
    );

    // 2. Delegate deep evaluation to domain logic (Network/Calculation delay simulation)
    // Small arbitrary delay injected to simulate real network/typing latency for UX polish.
    await Future.delayed(const Duration(milliseconds: 600));
    final responsePayload = await _queryProcessor.execute(queryText);

    // 3. Handle Application Side Effects based on resolved Intent
    _handleIntentSideEffect(responsePayload.intent, queryText);

    // 4. Inject AI response back into history and unlock UI
    final aiMessage = AiMessage(
      id: _uuid.v4(),
      text: responsePayload.text,
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      isLoading: false,
      messages: [...state.messages, aiMessage],
    );
  }

  /// METHOD: _handleIntentSideEffect
  /// PURPOSE: Triggers cross-feature provider mutations (e.g. creating a Project).
  void _handleIntentSideEffect(AiIntent intent, String rawQuery) {
    if (intent == AiIntent.createProject) {
      // Very basic substring extraction for project name demo
      String projectName = "AI Generated Project";
      final lower = rawQuery.toLowerCase();
      if (lower.contains('create project')) {
        final split = rawQuery
            .substring(rawQuery.toLowerCase().indexOf('create project') + 14)
            .trim();
        if (split.isNotEmpty) {
          projectName = split;
        }
      }

      // Note: project logic handled via active project provider
      ref
          .read(projectControllerProvider.notifier)
          .createProject(
            name: projectName,
            location: "Determined via AI Chat",
            status: ProjectStatus.planning,
            description: "Auto-generated from Site Buddy AI Intent system.",
          );
    }
  }
}
