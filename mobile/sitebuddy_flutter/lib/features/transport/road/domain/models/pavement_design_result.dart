
import 'package:site_buddy/features/transport/road/domain/models/pavement_layer.dart';

/// MODEL: PavementDesignResult
/// PURPOSE: Final output for flexible pavement design.
/// 
/// DOMAIN PURITY: This model contains ONLY computed engineering results.
/// No user plan or subscription information is stored here.
/// Policy decisions are handled in the Application layer.
class PavementDesignResult {
  final double totalThickness;
  final List<PavementLayer> layers;
  final String safetyClassification; // "SAFE", "CRITICAL", etc.
  final double cbrProvided;
  final double msaDesign;
  final double? suggestedOptimization; // Pro feature - computed always, shown conditionally

  const PavementDesignResult({
    required this.totalThickness,
    required this.layers,
    required this.safetyClassification,
    required this.cbrProvided,
    required this.msaDesign,
    this.suggestedOptimization,
  });

  Map<String, dynamic> toMap() => {
    'totalThickness': totalThickness,
    'layers': layers.map((l) => l.toMap()).toList(),
    'safetyClassification': safetyClassification,
    'cbrProvided': cbrProvided,
    'msaDesign': msaDesign,
    'suggestedOptimization': suggestedOptimization,
  };
}
