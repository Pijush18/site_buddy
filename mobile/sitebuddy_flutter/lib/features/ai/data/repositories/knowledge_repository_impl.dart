import 'package:site_buddy/core/data/knowledge_base.dart';
import 'package:site_buddy/features/ai/domain/repositories/knowledge_repository.dart';
import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

/// REPOSITORY IMPLEMENTATION: KnowledgeRepositoryImpl
/// PURPOSE: Implements KnowledgeRepository using the core KnowledgeBase.
class KnowledgeRepositoryImpl implements KnowledgeRepository {
  @override
  KnowledgeTopic? findTopic(String query) {
    return KnowledgeBase.findTopic(query);
  }
}
