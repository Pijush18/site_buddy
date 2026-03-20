/// FILE HEADER
/// ----------------------------------------------
/// File: ai_message.dart
/// Feature: ai
/// Layer: domain
///
/// PURPOSE:
/// The core entity representing a single chat bubble (user or system) in the AI feature.
///
/// RESPONSIBILITIES:
/// - Immutable strict data structure mapping who said what and when.
///
library;

/// - Add source trace IDs to link responses heavily back to specific calculation rules.
/// - Implement attachment links (images, voice notes).
/// ----------------------------------------------


/// CLASS: AiMessage
/// PURPOSE: Encapsulates text and metadata for the Chat UI flow.
class AiMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  /// METHOD: copyWith
  /// PURPOSE: Standard immutable state duplication.
  AiMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return AiMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}



