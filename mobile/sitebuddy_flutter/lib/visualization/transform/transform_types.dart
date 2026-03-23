import 'dart:math';
import 'dart:ui';
import '../primitives/primitives.dart';

/// Transform types for primitives
enum TransformType {
  translate,
  rotate,
  scale,
  skew,
  matrix,
}

/// 2D Transform matrix (stored as row-major 6 values)
class Transform2D {
  final double a, b, c, d, e, f;

  const Transform2D.identity()
      : a = 1, b = 0, c = 0, d = 1, e = 0, f = 0;

  const Transform2D(this.a, this.b, this.c, this.d, this.e, this.f);

  /// Apply transform to point
  Offset apply(Offset point) {
    return Offset(
      a * point.dx + c * point.dy + e,
      b * point.dx + d * point.dy + f,
    );
  }

  /// Compose two transforms
  Transform2D multiply(Transform2D other) {
    return Transform2D(
      a * other.a + c * other.b,
      b * other.a + d * other.b,
      a * other.c + c * other.d,
      b * other.c + d * other.d,
      a * other.e + c * other.f + e,
      b * other.e + d * other.f + f,
    );
  }

  /// Create translation
  factory Transform2D.translation(Offset offset) {
    return Transform2D(1, 0, 0, 1, offset.dx, offset.dy);
  }

  /// Create rotation (radians, around origin)
  factory Transform2D.rotation(double angle) {
    return Transform2D(
      cos(angle), sin(angle),
      -sin(angle), cos(angle),
      0, 0,
    );
  }

  /// Create scale
  factory Transform2D.scale(double sx, double sy) {
    return Transform2D(sx, 0, 0, sy, 0, 0);
  }
}

/// Transform handler interface
abstract class TransformHandler {
  /// Apply transform to a list of primitives
  List<DiagramPrimitive> applyTransforms(List<DiagramPrimitive> primitives);

  /// Get transform for specific primitive
  Transform2D? getTransform(String primitiveId);

  /// Set transform for specific primitive
  void setTransform(String primitiveId, Transform2D transform);

  /// Remove transform (reset to identity)
  void clearTransform(String primitiveId);
}
