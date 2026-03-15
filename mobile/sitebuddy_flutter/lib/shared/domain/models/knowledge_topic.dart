/// FILE HEADER
/// ----------------------------------------------
/// File: knowledge_topic.dart
/// Feature: ai_assistant
/// Layer: domain/entities
///
/// PURPOSE:
/// Data model for civil engineering topics exposed by the knowledge engine.
/// Expanded to support Handbook features like structural Thumb Rules and direct IDs.
/// ----------------------------------------------
library;


/// Represents a distinct piece of civil engineering knowledge.
class KnowledgeTopic {
  /// Unique identifier map key for precise routing and deep-linking.
  final String id;

  /// Primary title of the topic (e.g. "Slab").
  final String title;

  /// Core definition or explanation.
  final String definition;

  /// Bullet points detailing critical specifications or rules.
  final List<String> keyPoints;

  /// Notable variations or categories for this topic.
  final List<String> types;

  /// Engineering rule-of-thumb quick calculation factors.
  final List<String> thumbRules;

  /// Explicitly mapped sub-topics available for deep interactive navigation.
  final List<String> relatedTopics;

  /// Keywords used to match local search queries.
  final List<String> keywords;

  /// Practical advice or best practice for on-site implementation.
  final String siteTip;

  const KnowledgeTopic({
    required this.id,
    required this.title,
    required this.definition,
    required this.keyPoints,
    required this.types,
    required this.thumbRules,
    required this.relatedTopics,
    required this.keywords,
    required this.siteTip,
  });

  factory KnowledgeTopic.fromJson(Map<String, dynamic> json) {

    return KnowledgeTopic(
      id: json['id'] as String,
      title: json['title'] as String,
      definition: json['definition'] as String,
      keyPoints: List<String>.from(json['keyPoints'] as List),
      types: List<String>.from(json['types'] as List),
      thumbRules: List<String>.from(json['thumbRules'] as List),
      relatedTopics: List<String>.from(json['relatedTopics'] as List),
      keywords: List<String>.from(json['keywords'] as List),
      siteTip: json['siteTip'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'definition': definition,
      'keyPoints': keyPoints,
      'types': types,
      'thumbRules': thumbRules,
      'relatedTopics': relatedTopics,
      'keywords': keywords,
      'siteTip': siteTip,
    };
  }
}

