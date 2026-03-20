/// FILE HEADER
/// ----------------------------------------------
/// File: ai_chat.dart
/// Feature: ai_assistant
/// Layer: domain/entities
///
/// PURPOSE:
/// Represents a single AI interaction consisting of a user query and the corresponding AI response.
///
/// RESPONSIBILITIES:
/// - Holds the unique conversational data along with its creation timestamp.
/// - Tracks an optional projectId to indicate if this chat was saved/linked to a specific project.
///
/// FUTURE IMPROVEMENTS:
/// - Add a `tags` list for quick searching or categorization.
/// - Support offline multi-device sync via Supabase/Firebase.
/// ----------------------------------------------
library;


import 'package:equatable/equatable.dart';

import 'package:site_buddy/shared/domain/models/ai_response.dart';

/// CLASS: AiChat
/// PURPOSE: Entity representing an immutable record of an AI conversation.
class AiChat extends Equatable {
  /// Unique identifier of the chat interaction (UUID).
  final String id;

  /// The original raw natural language string inputted by the user.
  final String query;

  /// The resulting complex response payload resolved by the AI orchestrator.
  final AiResponse response;

  /// The exact date and time this interaction occurred.
  final DateTime timestamp;

  /// Optional ID linking this interaction to a specific `ProjectEntity`.
  /// Null implies the chat is only in the general history.
  final String? projectId;

  const AiChat({
    required this.id,
    required this.query,
    required this.response,
    required this.timestamp,
    this.projectId,
  });

  /// METHOD: copyWith
  /// PURPOSE: Standard immutable copy operation for updating properties (like attaching a projectId).
  AiChat copyWith({
    String? id,
    String? query,
    AiResponse? response,
    DateTime? timestamp,
    String? projectId,
  }) {
    return AiChat(
      id: id ?? this.id,
      query: query ?? this.query,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
      projectId: projectId ?? this.projectId,
    );
  }

  @override
  List<Object?> get props => [id, query, response, timestamp, projectId];
}



