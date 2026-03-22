import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';

class ColumnInsightService {
  static List<String> getSuggestions(ColumnDesignState state, AppLocalizations l10n) {
    final suggestions = <String>[];

    if (!state.isCapacitySafe) {
      if (state.interactionRatio > 1.5) {
        suggestions.add(l10n.msgSignificantOverStress);
      } else {
        suggestions.add(l10n.msgMinorOverStress);
      }
    }

    if (!state.isSlendernessSafe) {
      suggestions.add(l10n.msgColumnTooSlender);
    }

    if (state.steelPercentage < 0.8) {
      suggestions.add(l10n.msgSteelBelowMin);
    }

    if (state.steelPercentage > 4.0) {
      suggestions.add(l10n.msgSteelHighCongestion);
    }

    if (state.interactionRatio < 0.5 && state.isCapacitySafe) {
      suggestions.add(l10n.msgSectionOverDesigned);
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



