import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';

void main() {
  late MaterialEstimationService service;

  setUp(() {
    service = MaterialEstimationService();
  });

  group('Concrete Materials Calculation', () {
    test('Calculates M20 concrete for 1m3 volume correctly', () {
      final result = service.calculateConcreteMaterials(
        length: 1.0,
        width: 1.0,
        depth: 1.0,
        grade: ConcreteMixConstants.m20,
      );

      // Volume = 1.0
      expect(result.concreteVolume, equals(1.0));

      // Dry Volume = 1.54
      // Total parts = 1 + 1.5 + 3 = 5.5
      // Cement volume = 1.54 * 1 / 5.5 = 0.28
      // Cement weight = 0.28 * 1440 = 403.2
      // Cement bags = 403.2 / 50 = 8.064 -> 9 bags
      expect(result.cementBags, equals(9.0));
      expect(result.cementWeight, equals(450.0)); // 9 * 50
    });

    test('Throws error for negative dimensions', () {
      expect(
        () =>
            service.calculateConcreteMaterials(length: -1, width: 1, depth: 1),
        throwsArgumentError,
      );
    });
  });

  group('Brick Wall Calculation', () {
    test('Calculates standard wall bricks correctly', () {
      final result = service.calculateBrickWallMaterials(
        length: 4.0,
        height: 3.0,
        thickness: 0.23,
      );

      // Wall volume = 4 * 3 * 0.23 = 2.76
      // Bricks per m3 ≈ 500 (standard approximation)
      // Our formula: netBricks = (2.76 / 0.002) = 1380
      // Total bricks with wastage (1.05) = 1449
      expect(result.numberOfBricks, greaterThan(1400));
      expect(result.mortarVolume, greaterThan(0));
    });

    test('Throws error for invalid mortar ratio format', () {
      expect(
        () => service.calculateBrickWallMaterials(
          length: 1,
          height: 1,
          thickness: 1,
          mortarRatioString: 'invalid',
        ),
        throwsArgumentError,
      );
    });
  });

  group('Plaster Calculation', () {
    test('Calculates plastering materials correctly', () {
      final result = service.calculatePlasterMaterials(
        area: 100.0,
        thickness: 0.012,
        mortarRatioString: '1:4',
      );

      // Wet volume = 100 * 0.012 = 1.2
      // Dry volume = 1.2 * 1.3 = 1.56
      // Total parts = 1 + 4 = 5
      // Cement volume = 1.56 / 5 = 0.312
      // Cement weight = 0.312 * 1440 = 449.28
      // Cement bags = 449.28 / 50 = 8.98 -> 9 bags
      expect(result.cementBags, equals(9.0));
      expect(result.sandVolume, closeTo(1.248, 0.001));
    });
  });
}
