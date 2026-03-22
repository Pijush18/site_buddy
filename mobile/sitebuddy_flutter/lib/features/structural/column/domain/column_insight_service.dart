
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_state.dart';

/// SERVICE: ColumnInsightService
/// PURPOSE: Provides intelligent engineering suggestions based on design state.
class ColumnInsightService {
  static List<String> getSuggestions(ColumnDesignState state, AppLocalizations l10n) {
    final List<String> suggestions = [];

    // 1. Interaction Ratio Insights
    if (state.interactionRatio > 0.95 && state.interactionRatio <= 1.0) {
      suggestions.add(state.interactionRatio > 1.1 ? l10n.msgSignificantOverStress : l10n.msgMinorOverStress);
    } else if (state.interactionRatio < 0.5) {
      suggestions.add(l10n.msgSectionOverDesigned);
    }

    // 2. Reinforcement Insights
    if (state.steelPercentage < 0.8) {
      suggestions.add(l10n.msgSteelBelowMin);
    } else if (state.steelPercentage > 4.0) {
      suggestions.add(l10n.msgSteelHighCongestion);
    }

    // 3. Slenderness Insights
    if (!state.isShort) {
      suggestions.add(l10n.msgColumnTooSlender);
    }

    // Default if empty
    if (suggestions.isEmpty) {
      suggestions.add(l10n.labelDesignSafe);
    }

    return suggestions;
  }
}

