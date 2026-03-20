/// FILE HEADER
/// ----------------------------------------------
/// File: ai_chat_local_datasource.dart
/// Feature: core
/// Layer: data/local
///
/// PURPOSE:
/// Serves as a mutable, singleton-like local data store for AI Chat history.
///
/// RESPONSIBILITIES:
/// - Provides synchronous CRUD-like access to the chat memory.
/// - Returns future-wrapped responses to simulate real async data layers (SQLite/Isar/Supabase).
///
/// FUTURE IMPROVEMENTS:
/// - Swap out `_chats` with an actual `Isar` collection or `sqflite` table logic.
/// - Implement pagination (offset/limit) on `getAllChats`.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_chat.dart';

/// CLASS: AiChatLocalDataSource
/// PURPOSE: Concrete local implementation for storing and fetching `AiChat` instances.
class AiChatLocalDataSource {
  /// In-memory storage of the chats.
  /// Simulating a NoSQL document store or SQL table.
  final List<AiChat> _chats = [];

  /// METHOD: saveChat
  /// PURPOSE: Mocks an asynchronous write to the local file system.
  Future<void> saveChat(AiChat chat) async {
    // Simulating IO delay
    await Future.delayed(const Duration(milliseconds: 50));
    _chats.add(chat);
  }

  /// METHOD: getAllChats
  /// PURPOSE: Retrieves all chats sorted by newest first.
  Future<List<AiChat>> getAllChats() async {
    await Future.delayed(const Duration(milliseconds: 50));
    final sorted = List<AiChat>.from(_chats)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  /// METHOD: getChatsByProject
  /// PURPOSE: Filters the in-memory store for a specific `projectId`.
  Future<List<AiChat>> getChatsByProject(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final filtered = _chats
        .where((chat) => chat.projectId == projectId)
        .toList();
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return filtered;
  }

  /// METHOD: linkChatToProject
  /// PURPOSE: Finds a chat by ID, creates an immutable copy with the new projectId,
  /// and updates the list. Throws an exception if not found.
  Future<void> linkChatToProject({
    required String chatId,
    required String projectId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) {
      throw Exception('Chat with ID $chatId not found locally.');
    }

    final updatedChat = _chats[index].copyWith(projectId: projectId);
    _chats[index] = updatedChat;
  }
}



