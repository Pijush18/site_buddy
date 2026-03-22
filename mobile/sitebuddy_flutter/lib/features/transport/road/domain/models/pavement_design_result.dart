
import 'package:site_buddy/features/transport/road/domain/models/pavement_layer.dart';

/// MODEL: PavementDesignResult
/// PURPOSE: Final output for flexible pavement design.
class PavementDesignResult {
  final double totalThickness;
  final List<PavementLayer> layers;
  final String safetyClassification; // "SAFE", "CRITICAL", etc.
  final bool isProUser;
  final double cbrProvided;
  final double msaDesign;

  const PavementDesignResult({
    required this.totalThickness,
    required this.layers,
    required this.safetyClassification,
    required this.isProUser,
    required this.cbrProvided,
    required this.msaDesign,
  });

  Map<String, dynamic> toMap() => {
    'totalThickness': totalThickness,
    'layers': layers.map((l) => l.toMap()).toList(),
    'safetyClassification': safetyClassification,
    'isProUser': isProUser,
    'cbrProvided': cbrProvided,
    'msaDesign': msaDesign,
  };
}
