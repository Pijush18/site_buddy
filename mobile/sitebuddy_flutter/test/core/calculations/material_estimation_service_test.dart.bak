import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/core/engineering/standards/rcc/is_456_standard.dart';
import 'package:site_buddy/features/estimation/brick/domain/brick_design_service.dart';
import 'package:site_buddy/features/estimation/brick/domain/brick_models.dart';
import 'package:site_buddy/features/estimation/concrete/domain/concrete_design_service.dart';
import 'package:site_buddy/features/estimation/concrete/domain/concrete_models.dart';
import 'package:site_buddy/features/estimation/plaster/domain/plaster_design_service.dart';
import 'package:site_buddy/features/estimation/plaster/domain/plaster_models.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';

void main() {
  final standard = IS456Standard();
  late ConcreteDesignService concreteService;
  late BrickDesignService brickService;
  late PlasterDesignService plasterService;

  setUp(() {
    concreteService = ConcreteDesignService(standard);
    brickService = BrickDesignService(standard);
    plasterService = PlasterDesignService(standard);
  });

  group('Concrete Materials Calculation', () {
    test('Calculates M20 concrete for 1m3 volume correctly', () {
      final input = ConcreteInput(
        length: 1.0,
        width: 1.0,
        depth: 1.0,
        grade: ConcreteMixConstants.m20,
      );
      final result = concreteService.calculateMaterials(input);

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
  });

  group('Brick Wall Calculation', () {
    test('Calculates standard wall bricks correctly', () {
      final input = BrickInput(
        length: 4.0,
        height: 3.0,
        thickness: 0.23,
        mortarRatio: '1:6',
      );
      final result = brickService.calculateMaterials(input);

      // Wall volume = 4 * 3 * 0.23 = 2.76
      // Bricks per m3 ≈ 500
      expect(result.numberOfBricks, greaterThan(1400));
      expect(result.mortarVolume, greaterThan(0));
    });
  });

  group('Plaster Calculation', () {
    test('Calculates plastering materials correctly', () {
      final input = PlasterInput(
        area: 100.0,
        thickness: 0.012,
        mortarRatio: '1:4',
      );
      final result = plasterService.calculateMaterials(input);

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

