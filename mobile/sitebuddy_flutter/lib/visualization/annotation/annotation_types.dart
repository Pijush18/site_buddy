import 'dart:ui';
import '../primitives/primitives.dart';

/// Annotation anchor point
enum AnchorPoint {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Leader line style
enum LeaderStyle {
  straight,
  angled,
  curved,
}

/// Annotation entity
class Annotation {
  final String id;
  final String text;
  final Offset position;
  final AnchorPoint anchor;
  final Offset? leaderEnd;
  final LeaderStyle leaderStyle;
  final Color color;
  final double fontSize;

  const Annotation({
    required this.id,
    required this.text,
    required this.position,
    this.anchor = AnchorPoint.bottomLeft,
    this.leaderEnd,
    this.leaderStyle = LeaderStyle.straight,
    this.color = const Color(0xFF000000),
    this.fontSize = 12.0,
  });
}

/// Annotation layer interface
abstract class AnnotationLayer {
  /// Add annotation
  void add(Annotation annotation);

  /// Remove annotation
  void remove(String id);

  /// Update annotation
  void update(Annotation annotation);

  /// Get annotation by id
  Annotation? get(String id);

  /// Get all annotations
  List<Annotation> getAll();

  /// Query annotations by filter
  List<Annotation> query(bool Function(Annotation) filter);
}
