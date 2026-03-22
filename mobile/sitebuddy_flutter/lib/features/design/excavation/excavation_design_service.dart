import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/excavation/excavation_models.dart';
import 'package:site_buddy/shared/domain/models/excavation_result.dart';

/// SERVICE: ExcavationDesignService
/// PURPOSE: Encapsulates all formulas for excavation estimation.
class ExcavationDesignService {
  final DesignStandard standard;

  ExcavationDesignService(this.standard);

  ExcavationResult calculateVolume(ExcavationInput input) {
    final effectiveLength = input.length + (2 * input.clearance);
    final effectiveWidth = input.width + (2 * input.clearance);
    final bankVolume = effectiveLength * effectiveWidth * input.depth;
    final looseVolume = bankVolume * input.swellFactor;

    return ExcavationResult(
      volumeM3: _round(looseVolume),
      length: input.length,
      width: input.width,
      depth: input.depth,
      clearance: input.clearance,
      swellFactor: input.swellFactor,
    );
  }

  double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}
