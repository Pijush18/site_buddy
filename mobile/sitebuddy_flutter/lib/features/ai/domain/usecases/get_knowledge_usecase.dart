/// FILE HEADER
/// ----------------------------------------------
/// File: get_knowledge_usecase.dart
/// Feature: ai_assistant
/// Layer: domain/usecases
///
/// PURPOSE:
/// Encapsulates the logic to retrieve the correct civil engineering topic.
/// ----------------------------------------------
library;

import 'package:site_buddy/features/ai/domain/repositories/knowledge_repository.dart';
import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

/// CLASS: GetKnowledgeUseCase
/// PURPOSE: Queries the KnowledgeRepository for civil engineering topics.
class GetKnowledgeUseCase {
  final KnowledgeRepository repository;
  const GetKnowledgeUseCase(this.repository);

  /// Retrieves a topic from the repository via explicit or fuzzy matching, returning null if not found.
  KnowledgeTopic? execute(String normalizedQuery) {
    if (normalizedQuery.isEmpty) return null;
    return repository.findTopic(normalizedQuery);
  }

  /// STRICT FETCH: Used for explicit UI navigation where the title MUST exist.
  KnowledgeTopic getTopicByTitle(String exactTitle) {
    final topic = repository.findTopic(exactTitle);
    if (topic == null) {
      throw StateError(
        'Knowledge System Navigation Failure: Topic "$exactTitle" is not mapped in the Database.',
      );
    }
    return topic;
  }
}
