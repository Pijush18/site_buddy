

import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';

/// VALIDATOR: FootingValidator
/// PURPOSE: Ensures valid inputs for footing design calculations.
class FootingValidator {
  static String? validate(FootingDesignState state) {
    if (state.columnLoad <= 0) return 'Column load must be greater than 0.';
    if (state.sbc <= 0) return 'SBC must be greater than 0.';
    if (state.footingLength <= 0 || state.footingWidth <= 0) {
      return 'Footing dimensions must be greater than 0.';
    }
    if (state.footingThickness <= 0) return 'Thickness must be greater than 0.';
    if (state.colA <= 0 || state.colB <= 0) {
      return 'Column dimensions must be greater than 0.';
    }
    return null;
  }
}
