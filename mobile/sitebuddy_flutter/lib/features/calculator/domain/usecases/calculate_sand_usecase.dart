import 'package:site_buddy/features/calculator/domain/entities/sand_result.dart';

class CalculateSandUseCase {
  static const double _dryFactor = 1.33;
  static const double _m3ToCft = 35.3147;

  const CalculateSandUseCase();

  SandResult execute({
    required double length,
    required double width,
    required double depth,
    double? ratePerCubicMeter,
  }) {
    if (length <= 0) {
      throw ArgumentError.value(length, 'length', 'Length must be > 0');
    }
    if (width <= 0) {
      throw ArgumentError.value(width, 'width', 'Width must be > 0');
    }
    if (depth <= 0) {
      throw ArgumentError.value(depth, 'depth', 'Depth must be > 0');
    }

    final wetVolume = length * width * depth;
    final dryVolume = wetVolume * _dryFactor;
    final cubicFeet = dryVolume * _m3ToCft;
    final totalCost = ratePerCubicMeter != null
        ? dryVolume * ratePerCubicMeter
        : null;

    return SandResult(
      wetVolume: wetVolume,
      dryVolume: dryVolume,
      cubicFeet: cubicFeet,
      totalCost: totalCost,
    );
  }
}



