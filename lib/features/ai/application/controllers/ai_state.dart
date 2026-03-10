/// FILE HEADER
/// ----------------------------------------------
/// File: ai_state.dart
/// Feature: ai
/// Layer: application
///
/// PURPOSE:
/// Represents the presentation data required for the Smart Assistant widget.
///
/// RESPONSIBILITIES:
/// - Tracks asynchronous loading boundaries.
/// - Stores immediate calculation results from the AI pipeline.
///
/// DEPENDENCIES:
/// - MaterialResult from the existing `calculator` domain.
///
/// FUTURE IMPROVEMENTS:
/// - Integrate multiple result bounds if we add multi-domain intents.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/ai/domain/entities/ai_message.dart';

/// CLASS: AiState
/// PURPOSE: Immutable state record for the AI Chat continuous session.
class AiState {
  final bool isLoading;
  final List<AiMessage> messages;

  const AiState({this.isLoading = false, this.messages = const []});

  /// METHOD: initial
  /// PURPOSE: Empty defaults for mounting a new chat instance.
  factory AiState.initial() {
    return const AiState(messages: []);
  }

  /// METHOD: copyWith
  /// PURPOSE: Standard state duplication pattern strictly controlling history lists.
  AiState copyWith({bool? isLoading, List<AiMessage>? messages}) {
    return AiState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
    );
  }
}
