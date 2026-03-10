import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/models/design_advisor_result.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/optimization/optimization_result.dart';

/// PROVIDER: designAdvisorServiceProvider
final designAdvisorServiceProvider = Provider((ref) => DesignAdvisorService());

/// SERVICE: DesignAdvisorService
/// PURPOSE: Analyzes optimization results and provides engineering explanations and warnings.
class DesignAdvisorService {
  /// METHOD: advise
  /// Analyzes an optimization result and returns an advisory report for the best option.
  DesignAdvisorResult advise({
    required String category, // 'column', 'beam', 'slab', 'footing'
    required OptimizationResult optimizationResult,
  }) {
    if (optimizationResult.options.isEmpty) {
      throw Exception('No optimization options to advise on.');
    }

    // Usually we advise on the first (best) option
    final best = optimizationResult.options.first;

    final warnings = <String>[];
    final suggestions = <String>[];
    String explanation = '';

    switch (category.toLowerCase()) {
      case 'column':
        _analyzeColumn(best, warnings, suggestions);
        explanation = _getExplanation(
          best,
          'Economical column design balancing section size and steel requirement.',
        );
        break;
      case 'beam':
        _analyzeBeam(best, warnings, suggestions);
        explanation = _getExplanation(
          best,
          'Optimized beam section depth to control deflection and minimize steel.',
        );
        break;
      case 'slab':
        _analyzeSlab(best, warnings, suggestions);
        explanation = _getExplanation(
          best,
          'Minimum safe thickness providing required stiffness and reinforcement economy.',
        );
        break;
      case 'footing':
        _analyzeFooting(best, warnings, suggestions);
        explanation = _getExplanation(
          best,
          'Optimized foundation area to distribute loads within safe bearing capacity.',
        );
        break;
    }

    // Global checks
    if (best.utilization > 0.9) {
      warnings.add(
        'High utilization ratio (> 0.9). Consider a slightly larger section for better safety margin.',
      );
    }

    return DesignAdvisorResult(
      recommendedOption: best,
      explanation: explanation,
      warnings: warnings,
      suggestions: suggestions,
    );
  }

  void _analyzeColumn(
    OptimizationOption opt,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final b = opt.parameters['b'] as double? ?? 0;
    final d = opt.parameters['d'] as double? ?? 0;
    final asc = opt.parameters['asc'] as double? ?? 0;
    final ag = b * d;
    final pt = (asc / ag) * 100;

    if (pt > 4.0) {
      warnings.add(
        'Steel ratio is very high (> 4%). This may lead to reinforcement congestion and difficult concrete casting.',
      );
      suggestions.add(
        'Increase column dimensions (b x d) to reduce the required steel percentage.',
      );
    } else if (pt < 0.8) {
      // Should not happen with valid design but good to check
      warnings.add('Steel ratio is below minimum (0.8%).');
    }

    if (d / b > 3) {
      warnings.add(
        'Slender section ratio (D/B > 3). Risk of lateral instability.',
      );
      suggestions.add('Consider a more square-proportioned section.');
    }
  }

  void _analyzeBeam(
    OptimizationOption opt,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final width = opt.parameters['width'] as double? ?? 0;
    final depth = opt.parameters['depth'] as double? ?? 0;

    if (depth / width > 3) {
      warnings.add(
        'Deep beam proportions. Check for lateral torsional buckling.',
      );
      suggestions.add(
        'Increase beam width or reduce depth if deflection allows.',
      );
    }

    if (opt.utilization > 0.85) {
      suggestions.add(
        'Increase beam depth to improve moment capacity and reduce steel consumption.',
      );
    }
  }

  void _analyzeSlab(
    OptimizationOption opt,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final thickness = opt.parameters['thickness'] as double? ?? 0;

    if (thickness < 125) {
      warnings.add(
        'Relatively thin slab. Ensure proper cover is maintained for durability.',
      );
    }

    if (opt.utilization > 0.9) {
      suggestions.add(
        'Increase slab thickness to reduce reinforcement density.',
      );
    }
  }

  void _analyzeFooting(
    OptimizationOption opt,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final t = opt.parameters['thickness'] as double? ?? 0;

    if (t < 300) {
      warnings.add(
        'Footing thickness is minimal. Check for punching shear sensitive zones.',
      );
      suggestions.add(
        'Increase thickness to avoid excessive shear reinforcement.',
      );
    }

    if (opt.utilization < 0.5) {
      suggestions.add(
        'Section is oversized for the given load. Consider reducing area to save cost.',
      );
    }
  }

  String _getExplanation(OptimizationOption opt, String base) {
    if (opt.utilization < 0.7) {
      return '$base This option prioritizes high safety over absolute material economy.';
    } else if (opt.utilization > 0.85) {
      return '$base This is a highly efficient design with maximized material utilization.';
    }
    return base;
  }
}
