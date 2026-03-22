import 'package:site_buddy/features/shuttering_estimator/domain/models/shuttering_estimator_input.dart';
import 'package:site_buddy/features/shuttering_estimator/domain/models/shuttering_estimator_result.dart';

/// SERVICE: ShutteringEstimatorService
/// PURPOSE: Pure logic for shuttering area calculation.
class ShutteringEstimatorService {
  const ShutteringEstimatorService();

  /// CALCULATE: Determines contact area for formwork/shuttering.
  /// 
  /// LOGIC:
  /// 1. Slab: Length * Width (One face)
  /// 2. Beam: Bottom + 2 Sides (U-shape) -> (W*L) + (2*H*L)
  /// 3. Column: Full perimeter -> 2*(W+H)*L
  /// 
  /// UNITS: Square Meters (m2).
  ShutteringEstimatorResult calculate(ShutteringEstimatorInput input) {
    _validate(input);

    double area = 0;
    
    // CASE 1: Slab (Only horizontal area)
    if (input.width > 0 && input.height == 0) {
      area = input.length * input.width;
    } 
    // CASE 2: Beam (Bottom + 2 Sides usually)
    else if (input.width > 0 && input.height > 0 && input.numberOfSides == 2) {
      // Bottom area + Side areas
      area = (input.width * input.length) + (2 * input.height * input.length);
    }
    // CASE 3: Column or generic perimeter based
    else {
      final w = input.width > 0 ? input.width : 0.0;
      final h = input.height > 0 ? input.height : 0.0;
      
      if (input.numberOfSides >= 4) {
        // Full perimeter (Column)
        area = 2 * (w + h) * input.length;
      } else {
        // Partial perimeter or generic side calculation
        final dimension = w > h ? w : h;
        area = dimension * input.length * input.numberOfSides;
      }
    }

    return ShutteringEstimatorResult(
      area: double.parse(area.toStringAsFixed(2)),
    );
  }

  void _validate(ShutteringEstimatorInput input) {
    if (input.length <= 0) {
      throw ArgumentError('Length must be positive');
    }
    if (input.numberOfSides < 1 && input.height > 0) {
      throw ArgumentError('Number of sides must be specified for depth-based items');
    }
  }
}
