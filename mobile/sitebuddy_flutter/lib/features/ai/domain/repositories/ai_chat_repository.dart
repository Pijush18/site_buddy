/// FILE HEADER
/// ----------------------------------------------
/// File: ai_chat_repository.dart
/// Feature: ai
/// Layer: domain/repositories
///
/// PURPOSE:
/// Abstract contract defining how AI chat interactions are persisted and retrieved.
/// ----------------------------------------------
library;

import 'package:site_buddy/shared/domain/models/ai_chat.dart';

/// ABSTRACT CLASS: AiChatRepository
/// PURPOSE: Contract for managing AI interaction history.
abstract class AiChatRepository {
  /// Persists a single chat interaction.
  Future<void> saveChat(AiChat chat);

  /// Retrieves the sorted continuous stream of all chat interactions.
  Future<List<AiChat>> getAllChats();

  /// Retrieves only the interactions contextually bounded to a specific site project.
  Future<List<AiChat>> getChatsByProject(String projectId);

  /// Hard links a historically amorphous chat interaction to a specific project stream.
  Future<void> linkChatToProject({
    required String chatId,
    required String projectId,
  });
}



