/// Engineering Handbook knowledge base.
library;


/// FILE HEADER
/// ----------------------------------------------
/// File: knowledge_base.dart
/// Feature: core
/// Layer: data
///
/// PURPOSE:
/// A static, hardcoded repository of civil engineering foundational knowledge.
/// Expanded into a full Engineering Handbook with 50+ precise topics, rules of thumb,
/// and interactive sub-routing mapped directly to exact String IDs.
/// ----------------------------------------------
import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';
import 'package:site_buddy/core/data/knowledge_data/structural_data.dart';
import 'package:site_buddy/core/data/knowledge_data/material_data.dart';
import 'package:site_buddy/core/data/knowledge_data/site_data.dart';

class KnowledgeBase {
  /// Simulates a database query by normalizing the search term and looking up the map.
  /// Falls back to keyword matching if exact ID fails.
  static KnowledgeTopic? findTopic(String query) {
    if (query.isEmpty) return null;
    final normalized = query.toLowerCase().trim();

    // 1. Exact Match via ID
    if (_data.containsKey(normalized)) {
      return _data[normalized];
    }

    // 2. Exact Title Match
    for (final topic in _data.values) {
      if (topic.title.toLowerCase() == normalized) return topic;
    }

    // 3. Keyword Match
    for (final topic in _data.values) {
      if (topic.keywords.any(
        (kw) => kw.contains(normalized) || normalized.contains(kw),
      )) {
        return topic;
      }
    }

    return null;
  }

  // Aggregate modular data
  static final Map<String, KnowledgeTopic> _data = {
    ...structuralKnowledge,
    ...materialKnowledge,
    ...siteKnowledge,
  };
}
