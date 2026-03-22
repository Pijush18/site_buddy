/// lib/core/engineering/standards/transport/road_standard.dart
///
/// Abstract interface defining the standard requirements for Road pavement design.
/// This is isolated from Structural (RCC) standards to maintain domain separation.
abstract class RoadStandard {
  /// Unique identifier for the design code (e.g., "IRC:37-2018").
  String get codeIdentifier;

  /// Minimum allowable California Bearing Ratio (CBR) percentage for subgrade.
  double get minCBR;

  /// Default safety factor applied to traffic estimates.
  double get safetyFactor;

  /// Calculates total pavement thickness (in mm) based on CBR and traffic.
  /// 
  /// [cbr]: California Bearing Ratio percentage of the subgrade soil.
  /// [traffic]: Cumulative traffic in million standard axles (msa).
  double thicknessFromCBR({required double cbr, required double traffic});
}
