/// FILE HEADER
/// ----------------------------------------------
/// File: ai_chat_repository_impl.dart
/// Feature: core
/// Layer: data/repositories
///
/// PURPOSE:
/// Concrete implementation of the `AiChatRepository` interface.
///
/// RESPONSIBILITIES:
/// - Connects the domain layer requirements to the concrete `AiChatLocalDataSource`.
/// - Allows easy swapping to a remote or complex hybrid datasource later.
///
/// DEPENDENCIES:
/// - `AiChatLocalDataSource`
///
/// FUTURE IMPROVEMENTS:
/// - Add `AiChatRemoteDataSource` and handle sync logic between local/remote.
/// - Implement Error tracking (e.g., Sentry) in the catch blocks.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_chat.dart';
import 'package:site_buddy/features/ai/domain/repositories/ai_chat_repository.dart';
import 'package:site_buddy/features/ai/data/local/datasources/ai_chat_local_datasource.dart';

/// CLASS: AiChatRepositoryImpl
/// PURPOSE: Connects the domain contract (`AiChatRepository`) to the concrete local fetcher.
class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatLocalDataSource _localDataSource;

  AiChatRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveChat(AiChat chat) async {
    try {
      await _localDataSource.saveChat(chat);
    } catch (e) {
      // Future logging extension
      rethrow;
    }
  }

  @override
  Future<List<AiChat>> getAllChats() async {
    try {
      return await _localDataSource.getAllChats();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AiChat>> getChatsByProject(String projectId) async {
    try {
      return await _localDataSource.getChatsByProject(projectId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> linkChatToProject({
    required String chatId,
    required String projectId,
  }) async {
    try {
      await _localDataSource.linkChatToProject(
        chatId: chatId,
        projectId: projectId,
      );
    } catch (e) {
      rethrow;
    }
  }
}



