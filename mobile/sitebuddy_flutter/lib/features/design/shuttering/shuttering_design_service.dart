import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/shuttering/shuttering_models.dart';
import 'package:site_buddy/shared/domain/models/shuttering_result.dart';

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
    );
  }

  double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}
