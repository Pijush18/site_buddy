import 'dart:math' as math;
import 'package:site_buddy/features/gradient_tool/domain/models/gradient_calculator_input.dart';
import 'package:site_buddy/features/gradient_tool/domain/models/gradient_calculator_result.dart';

/// SERVICE: GradientCalculatorService
/// PURPOSE: Pure logic for slope and gradient calculations.
class GradientCalculatorService {
  const GradientCalculatorService();

  /// CALCULATE: Derives slope percentage, ratio (1:X), and angle from rise and run.
  /// 
  /// FORMULAS:
  /// 1. Slope % = (Rise / Run) * 100
  /// 2. Ratio = 1 : (Run / Rise)
  /// 3. Angle = atan(Rise / Run) in degrees
  /// 
  /// UNITS: Any consistent linear unit for Rise and Run.
  GradientCalculatorResult calculate(GradientCalculatorInput input) {
    _validate(input);

    if (input.run == 0) {
      return const GradientCalculatorResult(
        slopePercent: 100.0,
        ratio: '1 : 0 (Vertical)',
        angleDegrees: 90.0,
      );
    }

    final slope = input.rise / input.run;
    final slopePercent = slope * 100;
    
    String ratioText;
    if (input.rise == 0) {
      ratioText = '1 : Flat';
    } else {
      final ratioValue = input.run / input.rise;
      ratioText = '1 : ${ratioValue.toStringAsFixed(1)}';
    }

    final angleRad = math.atan(slope);
    final angleDeg = angleRad * (180 / math.pi);

    return GradientCalculatorResult(
      slopePercent: double.parse(slopePercent.toStringAsFixed(2)),
      ratio: ratioText,
      angleDegrees: double.parse(angleDeg.toStringAsFixed(2)),
    );
  }

  void _validate(GradientCalculatorInput input) {
    if (input.run < 0) {
      throw ArgumentError('Run (horizontal distance) cannot be negative');
    }
    if (input.rise < 0) {
      throw ArgumentError('Rise (vertical distance) cannot be negative');
    }
  }
}
