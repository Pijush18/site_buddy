import 'dart:math' as math;
import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

class ColumnDesignEngine {
  const ColumnDesignEngine();

  /// METHOD: calculate
  /// Performs design pipeline for a column.
  ColumnDesignOutputs calculate(ColumnDesignInputs inputs) {
    // 1. Slenderness Check
    final isSlendernessSafe = _checkSlenderness(inputs);

    // 2. Capacity Check (Simplified P-M interaction)
    // Nominal Capacity Pn = 0.4 * fck * Ac + 0.67 * fy * Asc
    // Using dummy values for now to simulate the "Logic Migration"
    final interactionRatio =
        (inputs.pu * 1000) /
        (inputs.b * (inputs.d == 0 ? inputs.b : inputs.d) * 15);
    final isCapacitySafe = interactionRatio < 1.0;

    // 3. Reinforcement Detailing
    final reinforcement = _calculateReinforcement(inputs, interactionRatio);
    final ties = "8mm @ 200mm c/c (Lateral)";

    return ColumnDesignOutputs(
      reinforcement: reinforcement,
      ties: ties,
      interactionRatio: interactionRatio,
      isCapacitySafe: isCapacitySafe,
      isSlendernessSafe: isSlendernessSafe,
    );
  }

  bool _checkSlenderness(ColumnDesignInputs inputs) {
    // IS 456: Slenderness ratio = Lex / d < 12 (Short Column)
    // For simplicity, we just check the limit of 12.
    final effectiveLength = inputs.length * 0.8; // Rough approximation
    final minDim = inputs.type == ColumnType.circular
        ? inputs.b
        : math.min(inputs.b, inputs.d);
    return (effectiveLength / minDim) < 12;
  }

  String _calculateReinforcement(ColumnDesignInputs inputs, double ratio) {
    if (inputs.type == ColumnType.circular) {
      return "6 - 12mm Longitudinal";
    }
    if (ratio < 0.5) return "4 - 12mm Longitudinal";
    if (ratio < 0.8) return "4 - 16mm Longitudinal";
    return "6 - 16mm Longitudinal";
  }
}



