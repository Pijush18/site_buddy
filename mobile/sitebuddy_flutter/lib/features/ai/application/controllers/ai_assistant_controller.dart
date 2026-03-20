/// FILE HEADER
/// ----------------------------------------------
/// File: ai_controller.dart
/// Feature: ai_assistant
/// Layer: application/controllers
///
/// PURPOSE:
/// Connects the UI to the AI parsing and processing domain logic via Riverpod.
///
/// RESPONSIBILITIES:
/// - Maintains the `AiState`.
/// - Glues together the `ParseAiInputUseCase` and `ProcessAiRequestUseCase`.
/// - Provides async delay simulation to emulate "thinking" for premium UX.
/// ----------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/ai/application/controllers/ai_assistant_state.dart';
import 'package:site_buddy/features/ai/domain/usecases/parse_ai_input_usecase.dart';
import 'package:site_buddy/features/ai/domain/usecases/process_ai_request_usecase.dart';
import 'package:site_buddy/shared/domain/models/ai_chat.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/ai_response.dart';
import 'package:site_buddy/features/ai/domain/entities/assistant_response.dart';
import 'package:site_buddy/features/ai/domain/services/assistant_service.dart';
import 'package:site_buddy/shared/application/providers/active_project_provider.dart';
import 'package:site_buddy/core/branding/branding_provider.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';
import 'package:site_buddy/features/ai/application/usecase_providers.dart';
import 'package:site_buddy/features/reports/application/providers/report_usecase_providers.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/errors/error_handler.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/features/ai/application/controllers/ai_history_controller.dart';

/// Provider definition for the AI Controller.
final aiControllerProvider = NotifierProvider<AiController, AiState>(() {
  return AiController();
});

/// CLASS: AiController
/// PURPOSE: Notifier managing the interaction flow for the AI Smart Assistant.
class AiController extends Notifier<AiState> {
  late final ParseAiInputUseCase _parseUseCase;
  late final ProcessAiRequestUseCase _processUseCase;

  @override
  AiState build() {
    // Inject use cases via providers
    _parseUseCase = ref.watch(parseAiInputUseCaseProvider);
    _processUseCase = ref.watch(processAiRequestUseCaseProvider);

    return const AiState();
  }

  /// Retrieves the dynamically active project scope dynamically from the Riverpod graph.
  String get currentProjectName {
    final project = ref.read(activeProjectProvider);
    return project?.name ?? AppStrings.general;
  }

  /// Updates the query string as the user types.
  void updateInput(String newQuery) {
    state = state.copyWith(query: newQuery, clearError: true);
  }

  /// Updates the local visual search string for filtering knowledge topic content.
  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Triggers the full NLP parsing and processing sequence.
  Future<void> processInput(
    BuildContext? context, [
    String? initialInput,
  ]) async {
    if (initialInput != null && initialInput.isNotEmpty) {
      state = state.copyWith(query: initialInput, clearError: true);
    }

    final rawQuery = state.query.trim();
    debugPrint("AI INPUT RECEIVED: $rawQuery");
    if (rawQuery.isEmpty) return;

    // 1. Enter Loading State
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearResponse: true,
      clearAssistantResponse: true,
      breadcrumb: const [], // Reset breadcrumbs on fresh query
      searchQuery: '', // Reset local search
    );

    // Simulated short network/processing delay for premium "AI thinking" feel
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      debugPrint("AI PROCESS: Parsing Input...");
      // 2. Parse Intent
      final parsedInput = _parseUseCase.execute(rawQuery);

      debugPrint(
        "AI PROCESS: Executing Usecase for Intent - ${parsedInput.intent.name}",
      );
      // 3. Process Execution
      final unitSystem = ref.read(settingsProvider).unitSystem;
      final completeResponse = await _processUseCase.execute(
        parsedInput,
        unitSystem: unitSystem.name,
      );

      // Seed Breadcrumb if it is a knowledge hit
      List<String> newBreadcrumb = [];
      if (parsedInput.intent == AiIntent.knowledge &&
          completeResponse.knowledge != null) {
        newBreadcrumb = [completeResponse.knowledge!.title];
      }

      // 4. Update Success State
      state = state.copyWith(
        isLoading: false,
        response: completeResponse,
        breadcrumb: newBreadcrumb,
      );

      // 5. Fire-and-forget save to Chat History
      final chat = AiChat(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        query: rawQuery,
        response: completeResponse,
        timestamp: DateTime.now(),
      );
      ref.read(aiHistoryControllerProvider.notifier).saveChat(chat);
    } catch (e) {
      // 6. Update Error State via Central Handler
      if (context != null && !context.mounted) return;
      final appError = AppErrorHandler.handle(
        context,
        e,
        onRetry: () => processInput(context, initialInput),
      );
      state = state.copyWith(isLoading: false, error: appError.message);
    }
  }

  /// METHOD: explainDesign
  /// PURPOSE: Triggers deterministic engineering guidance for a specific design.
  Future<void> explainDesign(
    BuildContext? context, {
    required String moduleType,
    required Map<String, dynamic> inputData,
    required Map<String, dynamic> resultData,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearResponse: true,
      clearAssistantResponse: true,
    );

    // Simulated "AI thinking"
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final warnings = AssistantService.validateInputs(inputData);
      final explanation = AssistantService.explainResult(
        moduleType,
        resultData,
      );
      final suggestions = AssistantService.suggestImprovements(
        inputData,
        resultData,
      );

      final combinedResponse = AssistantResponse(
        title: explanation.title,
        message: explanation.message,
        suggestions: suggestions.suggestions,
        warnings: warnings,
      );

      state = state.copyWith(
        isLoading: false,
        assistantResponse: combinedResponse,
        query: '${AppStrings.examine} $moduleType ${AppStrings.design}',
      );
    } catch (e) {
      if (context != null && !context.mounted) return;
      final appError = AppErrorHandler.handle(context, e);
      state = state.copyWith(isLoading: false, error: appError.message);
    }
  }

  /// METHOD: generateReport
  /// WHY: Compiles the full history stream belonging strictly to the active context and forwards.
  SiteReport generateReport() {
    final historyState = ref.read(aiHistoryControllerProvider);
    final branding = ref.read(brandingProvider);
    final projectName = currentProjectName;

    // Filter chat history explicitly bounded to the active project graph scope natively.
    // Assuming project linking operates via ActiveProject id. If "General", we extract unlinked chats natively safely.
    final currentProjectId = ref.read(activeProjectProvider)?.id;
    final projectChats = historyState.chats.where((chat) {
      if (currentProjectId == null) return chat.projectId == null;
      return chat.projectId == currentProjectId;
    }).toList();

    final unitSystem = ref.read(settingsProvider).unitSystem;
    final generateUseCase = ref.read(generateSiteReportUseCaseProvider);
    return generateUseCase.execute(
      projectId: currentProjectId ?? 'general',
      projectName: projectName,
      branding: branding,
      projectChats: projectChats,
      unitSystem: unitSystem,
    );
  }

  /// METHOD: openKnowledgeTopic
  /// WHY: Initial mapping sequence. Resetting Breadcrumb cleanly on new initialTopic bindings.
  /// Bypasses all parsing and loading delays to snap the UI instantly to the requested Topic.
  void openKnowledgeTopic(BuildContext? context, String explicitTitle) {
    try {
      // Fetch strictly via the GetKnowledgeUseCase avoiding raw DB calls in Controller.
      final getKnowledge = ref.read(getKnowledgeUseCaseProvider);
      final topic = getKnowledge.getTopicByTitle(explicitTitle);

      // Mutate state immediately. No 'isLoading' cycle needed for local data.
      // Setup the base breadcrumb.
      state = state.copyWith(
        query: explicitTitle, // Synchronize the top search bar visually
        response: AiResponse(intent: AiIntent.knowledge, knowledge: topic),
        breadcrumb: [topic.title],
        searchQuery: '',
        clearError: true,
      );

      // Note: We deliberately DO NOT save these navigation hops into aiHistoryControllerProvider
      // history stream to prevent spamming the chat log with pure knowledge surfing.
    } catch (e) {
      final appError = AppErrorHandler.handle(context, e);
      state = state.copyWith(error: appError.message);
    }
  }

  /// METHOD: openTopic
  /// WHY: Navigate deeper into the knowledge tree, pushing a new topic onto the breadcrumb stack safely.
  void openTopic(BuildContext? context, String title) {
    try {
      final getKnowledge = ref.read(getKnowledgeUseCaseProvider);
      final topic = getKnowledge.getTopicByTitle(title);

      state = state.copyWith(
        response: AiResponse(intent: AiIntent.knowledge, knowledge: topic),
        breadcrumb: [...state.breadcrumb, topic.title],
        searchQuery: '', // Reset local search on deep nav
        clearError: true,
      );
    } catch (e) {
      final appError = AppErrorHandler.handle(context, e);
      state = state.copyWith(error: appError.message);
    }
  }

  /// METHOD: goBackTo
  /// WHY: Native backward navigation via Breadcrumb array slicing.
  void goBackTo(BuildContext? context, int index) {
    if (index >= state.breadcrumb.length || index < 0) return;

    try {
      final newTrail = state.breadcrumb.sublist(0, index + 1);
      final targetTitle = newTrail.last;

      final getKnowledge = ref.read(getKnowledgeUseCaseProvider);
      final topic = getKnowledge.getTopicByTitle(targetTitle);

      state = state.copyWith(
        breadcrumb: newTrail,
        response: AiResponse(intent: AiIntent.knowledge, knowledge: topic),
        searchQuery: '', // Reset local search on trace-back nav
        clearError: true,
      );
    } catch (e) {
      final appError = AppErrorHandler.handle(context, e);
      state = state.copyWith(error: appError.message);
    }
  }
}



