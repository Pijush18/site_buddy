import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

/// REPOSITORY: KnowledgeRepository
/// PURPOSE: Interface for retrieving civil engineering knowledge.
abstract class KnowledgeRepository {
  /// Finds a topic by query (supports fuzzy matching).
  KnowledgeTopic? findTopic(String query);
}



