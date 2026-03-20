import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

/// CLASS: ColumnValidator
/// PURPOSE: Validates engineering constraints as per IS 456:2000 for Columns.
class ColumnValidator {
  /// Entry point for validating the entire design state.
  String? validateInputs(ColumnDesignState state) {
    // 1. Geometry
    final geoError = _validateGeometry(
      b: state.b,
      d: state.d,
      length: state.length,
      cover: state.cover,
    );
    if (geoError != null) return geoError;

    // 2. Loads
    if (state.pu <= 0) return 'Axial load (Pu) must be positive.';

    // 3. Reinforcement (if not in auto-mode)
    if (!state.isAutoSteel) {
      final rebarError = _validateReinforcement(
        barDia: state.mainBarDia,
        numBars: state.numBars,
        isCircular: state.type == ColumnType.circular,
      );
      if (rebarError != null) return rebarError;
    }

    return null;
  }

  /// Validates column geometry.
  String? _validateGeometry({
    required double b,
    required double d,
    required double length,
    required double cover,
  }) {
    if (b < 200) return 'Minimum width should be 200mm.';
    if (d < 200) return 'Minimum depth should be 200mm.';
    if (length < 1000) return 'Unsupported length is too small.';
    if (cover < 40) return 'Clear cover for columns must be at least 40mm.';
    return null;
  }

  /// Validates reinforcement rules.
  String? _validateReinforcement({
    required double barDia,
    required int numBars,
    required bool isCircular,
  }) {
    if (barDia < 12) return 'Minimum longitudinal bar diameter is 12mm.';
    if (isCircular && numBars < 6) {
      return 'Circular columns require at least 6 bars.';
    }
    if (!isCircular && numBars < 4) {
      return 'Rectangular columns require at least 4 bars.';
    }
    return null;
  }
}



