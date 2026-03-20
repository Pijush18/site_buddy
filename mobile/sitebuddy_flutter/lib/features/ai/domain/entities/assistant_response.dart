

/// FILE HEADER
/// ----------------------------------------------
/// File: assistant_response.dart
/// Feature: ai_assistant
/// Layer: domain/entities
///
/// PURPOSE:
/// Structured response model for the Smart Engineering Assistant.
/// ----------------------------------------------
library;

class AssistantResponse {
  final String title;
  final String message;
  final List<String> suggestions;
  final List<String> warnings;

  const AssistantResponse({
    required this.title,
    required this.message,
    this.suggestions = const [],
    this.warnings = const [],
  });
}



