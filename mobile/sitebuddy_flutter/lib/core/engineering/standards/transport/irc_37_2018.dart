import 'dart:math' as math;
import 'package:site_buddy/features/transport/road/domain/models/pavement_layer.dart';
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';

/// STANDARD: IRC:37-2018
/// Guidelines for the Design of Flexible Pavements.
class IRC37Standard extends RoadStandard {
  // IRC Constants
  static const double minBaseThickness = 225.0; // WMM
  static const double minSurfaceThickness = 40.0; // BC
  static const double poorSubgradeThreshold = 3.0; // CBR %
  static const double heavyTrafficThreshold = 30.0; // MSA
  static const double mediumTrafficThreshold = 10.0; // MSA

  @override
  String get codeIdentifier => 'IRC:37-2018';

  @override
  double get defaultVDF => 3.5; // Typical for NH/SH in India (IRC 37)

  @override
  Map<String, double> get growthRateLimits => {
    'min': 0.0,
    'max': 12.0, // 12% max growth rate as per realistic trends
    'default': 5.0,
  };

  @override
  double get minCBR => 5.0;

  @override
  double get safetyFactor => 1.0;

  @override
  double thicknessFromCBR({required double cbr, required double traffic}) {
    return designThickness(cbr, traffic);
  }

  @override
  double designThickness(double cbr, double msa) {
    // Realistic IRC Non-linear power law: H = 3432 * msa^0.116 * CBR^-0.6
    // Handling poor subgrade penalty
    final effectiveCbr = cbr < poorSubgradeThreshold ? cbr * 0.8 : cbr;
    
    // Base thickness calculation (H)
    final h = (3432 * math.pow(msa, 0.116)) / (math.pow(effectiveCbr, 0.6)) - 113;
    
    // Apply heavy traffic factor
    final trafficFactor = msa > heavyTrafficThreshold ? 1.1 : 1.0;
    
    return math.max(300.0, h * trafficFactor); 
  }

  @override
  String classifyTraffic(double msa) {
    if (msa > heavyTrafficThreshold) return 'HEAVY';
    if (msa > mediumTrafficThreshold) return 'MEDIUM';
    return 'LOW';
  }

  @override
  List<double> layerDistribution(double totalThickness) {
    // Pro-rata distribution based on IRC 37-2018 proportions
    // BC: 7%, DBM: 18%, WMM: 35%, GSB: 40%
    return [
      totalThickness * 0.07, // BC
      totalThickness * 0.18, // DBM
      totalThickness * 0.35, // WMM
      totalThickness * 0.40, // GSB
    ];
  }

  @override
  double calculateESAL({
    required double initialTraffic,
    required double growthRate,
    required int designLife,
    required double vdf,
    required double ldf,
  }) {
    final r = growthRate / 100.0;
    final n = designLife.toDouble();
    if (r == 0) return 365 * n * initialTraffic * ldf * vdf;
    final multiplier = (math.pow(1 + r, n) - 1) / r;
    return 365 * multiplier * initialTraffic * ldf * vdf;
  }

  @override
  double msaFromTraffic(double cumulativeTraffic) {
    return cumulativeTraffic / 1e6;
  }

  @override
  List<PavementLayer> designLayers({required double cbr, required double msa}) {
    final totalH = designThickness(cbr, msa);
    final dist = layerDistribution(totalH);

    return [
      PavementLayer(name: 'Bituminous Concrete (BC)', thickness: dist[0], materialType: 'Bituminous'),
      PavementLayer(name: 'Dense Bituminous Macadam (DBM)', thickness: dist[1], materialType: 'Bituminous'),
      PavementLayer(name: 'Wet Mix Macadam (WMM)', thickness: dist[2], materialType: 'Granular'),
      PavementLayer(name: 'Granular Sub-base (GSB)', thickness: dist[3], materialType: 'Granular'),
    ];
  }
}
