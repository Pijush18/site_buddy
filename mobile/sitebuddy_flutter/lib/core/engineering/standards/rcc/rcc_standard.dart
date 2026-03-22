import 'package:site_buddy/core/engineering/units/unit_system.dart';

/// ABSTRACT CLASS: RccStandard
/// PURPOSE: Defines the interface for Reinforced Concrete Design standards (e.g., IS 456, ACI 318).
/// This allows the application to switch between different engineering codes seamlessly.
abstract class RccStandard {
  /// The unique identifier for the engineering code (e.g., "IS 456:2000").
  String get codeIdentifier;

  /// Partial safety factor for concrete.
  double get gammaConcrete;

  /// Partial safety factor for steel.
  double get gammaSteel;

  /// Minimum grade of concrete allowed by this standard for structural members.
  double get minConcreteGrade;

  /// Calculates the development length (Ld) for a reinforcing bar.
  ///
  /// Parameters:
  /// - [barDiameter]: Diameter of the bar in mm.
  /// - [yieldStrength]: Yield strength of steel (fy) in N/mm².
  /// - [concreteGrade]: Characteristic strength of concrete (fck) in N/mm².
  /// - [isCompression]: Whether the bar is in compression (affects bond stress).
  /// - [unitSystem]: The unit system to be used for calculation (defaults to metric).
  double developmentLength({
    required double barDiameter,
    required double yieldStrength,
    required double concreteGrade,
    bool isCompression = false,
    UnitSystem unitSystem = UnitSystem.metric,
  });
}
