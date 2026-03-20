import 'package:site_buddy/core/services/knowledge_service.dart';
import 'package:site_buddy/features/ai/domain/repositories/knowledge_repository.dart';
import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

/// REPOSITORY IMPLEMENTATION: KnowledgeRepositoryImpl
/// PURPOSE: Implements KnowledgeRepository using the core KnowledgeService.
class KnowledgeRepositoryImpl implements KnowledgeRepository {
  final KnowledgeService _knowledgeService;

  KnowledgeRepositoryImpl(this._knowledgeService);

  @override
  KnowledgeTopic? findTopic(String query) {
    return _knowledgeService.findTopic(query);
  }
}




