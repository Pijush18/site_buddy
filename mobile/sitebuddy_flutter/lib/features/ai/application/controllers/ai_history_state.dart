/// FILE HEADER
/// ----------------------------------------------
/// File: ai_history_state.dart
/// Feature: ai_assistant
/// Layer: application/state
///
/// PURPOSE:
/// Represents the reactive state of the AI Chat History feature.
///
/// RESPONSIBILITIES:
/// - Holds the list of [AiChat] records.
/// - Tracks loading and error boundaries for the history view.
///
/// FUTURE IMPROVEMENTS:
/// - Add pagination cursors for immense lists.
/// - Add query filters for searching history.
/// ----------------------------------------------
library;


import 'package:equatable/equatable.dart';

import 'package:site_buddy/shared/domain/models/ai_chat.dart';

/// CLASS: AiHistoryState
/// PURPOSE: Immutable state payload exclusively for presenting or interacting with the AI chat history.
class AiHistoryState extends Equatable {
  /// The collection of loaded AI interactions.
  final List<AiChat> chats;

  /// Indicates if an async fetch or persistence operation is running.
  final bool isLoading;

  /// Holds the text representation of any operational failure.
  final String? error;

  const AiHistoryState({
    this.chats = const [],
    this.isLoading = false,
    this.error,
  });

  /// METHOD: copyWith
  /// PURPOSE: Immutably mutate specific properties of the state without losing untouched values.
  AiHistoryState copyWith({
    List<AiChat>? chats,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AiHistoryState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [chats, isLoading, error];
}
