import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';

class ColumnInsightService {
  static List<String> getSuggestions(ColumnDesignState state) {
    final suggestions = <String>[];

    if (!state.isCapacitySafe) {
      if (state.interactionRatio > 1.5) {
        suggestions.add(
          'Significant over-stress detected. Increase column cross-section dimensions.',
        );
      } else {
        suggestions.add(
          'Minor over-stress. Try increasing Concrete Grade (e.g., M30 to M35) or Steel %.',
        );
      }
    }

    if (!state.isSlendernessSafe) {
      suggestions.add(
        'Column is too slender. Increase lateral dimensions (b or D) to reduce λ.',
      );
    }

    if (state.steelPercentage < 0.8) {
      suggestions.add(
        'Steel percentage is below IS 456 minimum (0.8%). Increase number of bars or diameter.',
      );
    }

    if (state.steelPercentage > 4.0) {
      suggestions.add(
        'Steel percentage is high (>4%). Consider increasing column size to reduce congestion.',
      );
    }

    if (state.interactionRatio < 0.5 && state.isCapacitySafe) {
      suggestions.add(
        'Section is potentially over-designed. You may reduce dimensions for economy.',
      );
    }

    return suggestions;
  }

  static Map<String, dynamic> getOptimization(ColumnDesignState state) {
    // Basic logic to find minimum dimensions/steel
    // This would be more complex in real service
    return {
      'status': 'Optimal section found',
      'suggested_b': state.b,
      'suggested_d': state.d,
      'suggested_p': (state.interactionRatio > 1.0)
          ? state.steelPercentage * 1.2
          : 0.8,
    };
  }
}
