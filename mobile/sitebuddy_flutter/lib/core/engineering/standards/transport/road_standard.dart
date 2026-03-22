// Abstract interface defining the standard requirements for Road pavement design.
// This is isolated from Structural (RCC) standards to maintain domain separation.
import 'package:site_buddy/features/transport/road/domain/models/pavement_layer.dart';

abstract class RoadStandard {
  /// Unique identifier for the design code (e.g., "IRC:37-2018").
  String get codeIdentifier;

  /// Minimum allowable California Bearing Ratio (CBR) percentage for subgrade.
  double get minCBR;

  /// Default Vehicle Damage Factor (VDF) for this standard.
  double get defaultVDF;

  /// Min/Max growth rate limits as per code.
  Map<String, double> get growthRateLimits;

  /// Default safety factor applied to traffic estimates.
  double get safetyFactor;

  /// Calculates total pavement thickness (in mm) based on CBR and traffic.
  double thicknessFromCBR({required double cbr, required double traffic});

  /// Calculates cumulative Equivalent Single Axle Load (ESAL).
  double calculateESAL({
    required double initialTraffic,
    required double growthRate,
    required int designLife,
    required double vdf,
    required double ldf,
  });

  /// Converts traffic count to Million Standard Axles (MSA).
  double msaFromTraffic(double cumulativeTraffic);

  /// Designs pavement layers based on subgrade CBR and design traffic.
  List<PavementLayer> designLayers({required double cbr, required double msa});

  /// Classifies traffic based on MSA (Million Standard Axles).
  String classifyTraffic(double msa);

  /// Realistic non-linear thickness calculation based on IRC charts.
  double designThickness(double cbr, double msa);

  /// Returns raw layer breakup as a list of thicknesses.
  List<double> layerDistribution(double totalThickness);
}
