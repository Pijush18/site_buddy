/// FILE HEADER
/// ----------------------------------------------
/// File: ai_history_controller.dart
/// Feature: ai_assistant
/// Layer: application/controllers
///
/// PURPOSE:
/// Mediates loading and saving interactions from the `AiChatRepository` into local reactive state.
///
/// RESPONSIBILITIES:
/// - Riverpod `Notifier` orchestrating state transitions (`AiHistoryState`).
/// - Handles initialization fetch.
/// - Exposes commands: `loadChats`, `saveChat`, and `linkToProject`.
///
/// DEPENDENCIES:
/// - `flutter_riverpod`
/// - `AiChatRepository` (via DI provider)
///
/// FUTURE IMPROVEMENTS:
/// - Introduce dependency injection for `AiChatRepository` rather than instantiating the concrete
///   in-memory datasource directly within the provider (if scaling beyond prototype).
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/ai/data/local/datasources/ai_chat_local_datasource.dart';
import 'package:site_buddy/features/ai/data/repositories/ai_chat_repository_impl.dart';
import 'package:site_buddy/shared/domain/models/ai_chat.dart';
import 'package:site_buddy/features/ai/domain/repositories/ai_chat_repository.dart';
import 'package:site_buddy/features/ai/application/controllers/ai_history_state.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';

// -----------------------------------------------------------------------------
// DEPENDENCY INJECTION (Lightweight Prototype Setup)
// -----------------------------------------------------------------------------

/// Provider exposing the local datasource for AI chats as a singleton proxy.
final aiChatLocalDataSourceProvider = Provider<AiChatLocalDataSource>((ref) {
  return AiChatLocalDataSource();
});

/// Provider exposing the repository contract tied to the concrete implementation.
final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  final local = ref.watch(aiChatLocalDataSourceProvider);
  return AiChatRepositoryImpl(local);
});

/// Provider exposing the `AiHistoryController` state notifier logic.
final aiHistoryControllerProvider =
    NotifierProvider<AiHistoryController, AiHistoryState>(
      AiHistoryController.new,
    );

// -----------------------------------------------------------------------------
// CONTROLLER LOGIC
// -----------------------------------------------------------------------------

/// CLASS: AiHistoryController
/// PURPOSE: Riverpod state manager mapping UI interactions to repository commands.
class AiHistoryController extends Notifier<AiHistoryState> {
  late final AiChatRepository _repository;

  @override
  AiHistoryState build() {
    _repository = ref.watch(aiChatRepositoryProvider);

    // 1. Listen for Auth changes to clear history
    ref.listen(authStateProvider, (previous, next) {
      final user = next.value;
      final prevUser = previous?.value;

      if (user != null && prevUser == null) {
        // Logged in: Refresh chats
        loadChats();
      } else if (user == null && prevUser != null) {
        // Logged out: Clear chats immediately
        state = const AiHistoryState(chats: [], isLoading: false);
      }
    });

    // 2. Initial load
    Future.microtask(() => loadChats());
    return const AiHistoryState();
  }

  /// METHOD: loadChats
  /// PURPOSE: Retrieves all historical chats and updates the unified state.
  Future<void> loadChats() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final chats = await _repository.getAllChats();
      state = state.copyWith(isLoading: false, chats: chats);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to load chat history.",
      );
    }
  }

  /// METHOD: saveChat
  /// PURPOSE: Pushes a new chat entity into persistence and refreshes the state list.
  Future<void> saveChat(AiChat chat) async {
    // Avoid triggering a heavy loading spinner for background saves
    try {
      await _repository.saveChat(chat);
      // To keep it simple, we re-fetch to ensure sorting.
      // Alternatively, we could prepend to `state.chats` locally.
      await loadChats();
    } catch (e) {
      state = state.copyWith(error: "Failed to save the latest interaction.");
    }
  }

  /// METHOD: linkToProject
  /// PURPOSE: Edits an existing history record to attach a foreign project ID constraint.
  Future<void> linkToProject(String chatId, String projectId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _repository.linkChatToProject(chatId: chatId, projectId: projectId);
      // Reload logic
      await loadChats();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to link chat to project.",
      );
    }
  }
}



