import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

/// Provider for the KnowledgeService.
final knowledgeServiceProvider = Provider<KnowledgeService>((ref) {
  return KnowledgeService();
});

/// Service responsible for loading and providing engineering knowledge from JSON.
class KnowledgeService {
  static final KnowledgeService _instance = KnowledgeService._internal();
  factory KnowledgeService() => _instance;
  KnowledgeService._internal();

  Map<String, KnowledgeTopic> _allTopics = {};
  List<KnowledgeTopic> _engineeringTerms = [];
  List<KnowledgeTopic> _constructionRules = [];
  List<KnowledgeTopic> _designGuidelines = [];
  List<KnowledgeTopic> _materialProperties = [];

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  /// Loads the knowledge base from assets.
  Future<void> loadKnowledge() async {
    if (_isLoaded) return;

    try {
      final String response = await rootBundle.loadString('assets/data/knowledge.json');
      final data = json.decode(response) as Map<String, dynamic>;

      _engineeringTerms = (data['engineering_terms'] as List)
          .map((e) => KnowledgeTopic.fromJson(e as Map<String, dynamic>))
          .toList();
      _constructionRules = (data['construction_rules'] as List)
          .map((e) => KnowledgeTopic.fromJson(e as Map<String, dynamic>))
          .toList();
      _designGuidelines = (data['design_guidelines'] as List)
          .map((e) => KnowledgeTopic.fromJson(e as Map<String, dynamic>))
          .toList();
      _materialProperties = (data['material_properties'] as List)
          .map((e) => KnowledgeTopic.fromJson(e as Map<String, dynamic>))
          .toList();

      _allTopics = {};
      final all = [
        ..._engineeringTerms,
        ..._constructionRules,
        ..._designGuidelines,
        ..._materialProperties
      ];

      for (var topic in all) {
        _allTopics[topic.id.toLowerCase()] = topic;
      }

      _isLoaded = true;
    } catch (e) {
      // In production, you might want to handle this more gracefully
      debugPrint('Error loading knowledge base: $e');

    }
  }

  /// Getters for categorized knowledge.
  List<KnowledgeTopic> getEngineeringTerms() => _engineeringTerms;
  List<KnowledgeTopic> getConstructionRules() => _constructionRules;
  List<KnowledgeTopic> getDesignGuidelines() => _designGuidelines;
  List<KnowledgeTopic> getMaterialProperties() => _materialProperties;

  /// Find a specific topic by query (replicates old KnowledgeBase logic).
  KnowledgeTopic? findTopic(String query) {
    if (query.isEmpty) return null;
    final normalized = query.toLowerCase().trim();

    // 1. Exact Match via ID
    if (_allTopics.containsKey(normalized)) {
      return _allTopics[normalized];
    }

    // 2. Exact Title Match
    for (final topic in _allTopics.values) {
      if (topic.title.toLowerCase() == normalized) return topic;
    }

    // 3. Keyword Match
    for (final topic in _allTopics.values) {
      if (topic.keywords.any(
        (kw) => kw.contains(normalized) || normalized.contains(kw),
      )) {
        return topic;
      }
    }

    return null;
  }
}



