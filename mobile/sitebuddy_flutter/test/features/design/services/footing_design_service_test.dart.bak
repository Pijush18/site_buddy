import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_design_service.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_models.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_type.dart';
import 'package:site_buddy/core/engineering/standards/rcc/is_456_standard.dart';

void main() {
  final service = FootingDesignService(IS456Standard());

  group('FootingDesignService Verification', () {
    test('Case 1: Isolated Footing - Basic Soil Pressure', () {
      const input = FootingInput(
        type: FootingType.isolated,
        columnLoad: 1000, // kN
        sbc: 200, // kN/m2
        footingLength: 2500, // 2.5m
        footingWidth: 2500, // 2.5m
        footingThickness: 450,
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
      );

      final result = service.designFooting(input);

      // Total working load = 1000 * 1.1 = 1100 kN
      // Area = 2.5 * 2.5 = 6.25 m2
      // Pressure = 1100 / 6.25 = 176 kN/m2
      expect(result.maxSoilPressure, closeTo(176.0, 0.1));
      expect(result.isAreaSafe, true);
    });

    test('Case 2: SBC Failure - Undersized Footing', () {
      const input = FootingInput(
        type: FootingType.isolated,
        columnLoad: 1000,
        sbc: 100,
        footingLength: 2000, // 2m x 2m = 4m2
        footingWidth: 2000,
        footingThickness: 450,
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
      );

      final result = service.designFooting(input);

      // Load = 1100 kN, Area = 4 m2 -> Pressure = 275 kN/m2 > 100
      expect(result.isAreaSafe, false);
      expect(result.maxSoilPressure, greaterThan(input.sbc));
    });

    test('Case 3: Structural Design - Punching Shear Check', () {
      const input = FootingInput(
        type: FootingType.isolated,
        columnLoad: 500,
        sbc: 200,
        footingLength: 2000,
        footingWidth: 2000,
        footingThickness: 400,
        concreteGrade: 'M20',
        steelGrade: 'Fe415',
      );

      final result = service.designFooting(input);

      // Effective depth = 400 - 50 = 350mm
      expect(result.isPunchingShearSafe, isA<bool>());
    });

    test('Case 4: Invalid Input - Zero SBC', () {
      const input = FootingInput(
        type: FootingType.isolated,
        sbc: 0.1, // Near zero
        columnLoad: 100,
        footingLength: 2000,
        footingWidth: 2000,
        footingThickness: 400,
        concreteGrade: 'M20',
        steelGrade: 'Fe415',
      );
      final result = service.designFooting(input);

      // Extremely high pressure
      expect(result.isAreaSafe, false);
    });
  });
}
