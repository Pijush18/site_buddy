
enum CanalShape { rectangular, trapezoidal }

/// MODEL: CanalInput
/// PURPOSE: Captures input parameters for Manning's based canal design.
class CanalInput {
  final CanalShape shape;
  final double bedWidth;    // b (m)
  final double sideSlope;    // z (for trapezoidal, z:1)
  final double flowDepth;    // y (m)
  final double longitudinalSlope; // S (e.g. 0.001)
  final String material;     // e.g. "Concrete", "Earth"
  final bool isProUser;

  const CanalInput({
    required this.shape,
    required this.bedWidth,
    this.sideSlope = 0.0,
    required this.flowDepth,
    required this.longitudinalSlope,
    required this.material,
    this.isProUser = false,
  });

  Map<String, dynamic> toMap() => {
    'shape': shape.name,
    'bedWidth': bedWidth,
    'sideSlope': sideSlope,
    'flowDepth': flowDepth,
    'longitudinalSlope': longitudinalSlope,
    'material': material,
    'isProUser': isProUser,
  };
}
