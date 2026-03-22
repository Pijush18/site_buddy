import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/estimation/shuttering/domain/shuttering_models.dart';

/// SERVICE: ShutteringDesignService
/// PURPOSE: Encapsulates all formulas for shuttering area estimation.
class ShutteringDesignService {
  final DesignStandard standard;

  ShutteringDesignService(this.standard);

  ShutteringResult calculateArea(ShutteringInput input) {
    final sideArea = 2 * (input.length + input.width) * input.depth;
    final bottomArea = input.includeBottom ? (input.length * input.width) : 0.0;
    final totalArea = sideArea + bottomArea;

    return ShutteringResult(
      areaM2: _round(totalArea),
      length: input.length,
      width: input.width,
      depth: input.depth,
      breakdown: {
        'side_area': _round(sideArea),
        'bottom_area': _round(bottomArea),
      },
    );
  }

  double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}

