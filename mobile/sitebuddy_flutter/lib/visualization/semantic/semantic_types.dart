
/// Semantic layer interface for domain-specific meaning
/// Allows primitives to carry engineering/structural semantics
library;

/// Semantic type categories
enum SemanticType {
  structural,
  architectural,
  mechanical,
  electrical,
  plumbing,
  annotation,
  dimension,
  grid,
}

/// Semantic metadata for primitives
class SemanticMetadata {
  final SemanticType type;
  final String? category;
  final Map<String, dynamic> properties;
  final String? tooltip;

  const SemanticMetadata({
    required this.type,
    this.category,
    this.properties = const {},
    this.tooltip,
  });
}

/// Semantic layer interface
abstract class SemanticLayer {
  /// Get semantic metadata for a primitive
  SemanticMetadata? getMetadata(String primitiveId);

  /// Add semantic information to a primitive
  void annotate(String primitiveId, SemanticMetadata metadata);

  /// Query primitives by semantic type
  List<String> queryByType(SemanticType type);

  /// Query primitives by custom predicate
  List<String> query(bool Function(SemanticMetadata) predicate);
}
