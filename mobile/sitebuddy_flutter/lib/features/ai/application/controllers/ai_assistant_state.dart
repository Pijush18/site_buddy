/// FILE HEADER
/// ----------------------------------------------
/// File: ai_state.dart
/// Feature: ai_assistant
/// Layer: application/state
///
/// PURPOSE:
/// Represents the reactive state of the AI Assistant chat interface.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_response.dart';
import 'package:site_buddy/features/ai/domain/entities/assistant_response.dart';

/// CLASS: AiState
/// PURPOSE: Immutable state container for the AI Assistant's current interaction.
class AiState {
  /// The current input being typed or processed.
  final String query;

  /// Whether the AI engine is actively parsing or processing.
  final bool isLoading;

  /// The final structured result from the process engine.
  final AiResponse? response;

  /// The structured guidance from the Smart Assistant.
  final AssistantResponse? assistantResponse;

  /// Any global fatal error during processing.
  final String? error;

  /// The ID of the currently tracked chat interaction for this session.
  final String? latestChatId;

  /// The hierarchical breadcrumb trail of knowledge topics navigated.
  final List<String> breadcrumb;

  /// The active local search query for filtering within a knowledge topic.
  final String searchQuery;

  const AiState({
    this.query = '',
    this.isLoading = false,
    this.response,
    this.assistantResponse,
    this.error,
    this.latestChatId,
    this.breadcrumb = const [],
    this.searchQuery = '',
  });

  /// standard copyWith for atomic state mutation.
  AiState copyWith({
    String? query,
    bool? isLoading,
    AiResponse? response,
    AssistantResponse? assistantResponse,
    String? error,
    String? latestChatId,
    List<String>? breadcrumb,
    String? searchQuery,
    bool clearResponse = false,
    bool clearAssistantResponse = false,
    bool clearError = false,
  }) {
    return AiState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      response: clearResponse ? null : (response ?? this.response),
      assistantResponse: clearAssistantResponse
          ? null
          : (assistantResponse ?? this.assistantResponse),
      error: clearError ? null : (error ?? this.error),
      latestChatId: latestChatId ?? this.latestChatId,
      breadcrumb: breadcrumb ?? this.breadcrumb,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
