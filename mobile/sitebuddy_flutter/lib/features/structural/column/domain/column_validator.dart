
import 'package:site_buddy/features/structural/column/domain/column_design_state.dart';

/// SERVICE: ColumnValidator
/// PURPOSE: Validates column design inputs before calculation.
class ColumnValidator {
  String? validateInputs(ColumnDesignState state) {
    if (state.b <= 0 || state.d <= 0) {
      return 'Column dimensions must be greater than zero.';
    }
    if (state.length <= 0) {
      return 'Column length must be greater than zero.';
    }
    if (state.pu < 0) {
      return 'Axial load cannot be negative.';
    }
    return null;
  }
}
