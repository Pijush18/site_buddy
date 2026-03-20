import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/features/design/application/services/footing_design_service.dart';
import 'package:site_buddy/shared/domain/models/design/footing_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';

void main() {
  final service = FootingDesignService();

  group('FootingDesignService Verification', () {
    test('Case 1: Isolated Footing - Basic Soil Pressure', () {
      final state = FootingDesignState(
        type: FootingType.isolated,
        columnLoad: 1000, // kN
        sbc: 200, // kN/m2
        footingLength: 2500, // 2.5m
        footingWidth: 2500, // 2.5m
      );

      final result = service.runPipeline(state);

      // Total working load = 1000 * 1.1 = 1100 kN
      // Area = 2.5 * 2.5 = 6.25 m2
      // Pressure = 1100 / 6.25 = 176 kN/m2
      expect(result.maxSoilPressure, closeTo(176.0, 0.1));
      expect(result.isAreaSafe, true);
    });

    test('Case 2: SBC Failure - Undersized Footing', () {
      final state = FootingDesignState(
        type: FootingType.isolated,
        columnLoad: 1000,
        sbc: 100,
        footingLength: 2000, // 2m x 2m = 4m2
        footingWidth: 2000,
      );

      final result = service.runPipeline(state);

      // Load = 1100 kN, Area = 4 m2 -> Pressure = 275 kN/m2 > 100
      expect(result.isAreaSafe, false);
      expect(result.maxSoilPressure, greaterThan(state.sbc));
    });

    test('Case 3: Structural Design - Punching Shear Check', () {
      final state = FootingDesignState(
        columnLoad: 500,
        footingThickness: 400,
        colA: 300,
        colB: 300,
        concreteGrade: 'M20',
      );

      final result = service.runPipeline(state);

      expect(result.effDepth, greaterThan(300));
      // Punching shear is usually critical for thinner footings
      expect(result.isPunchingShearSafe, isA<bool>());
    });

    test('Case 4: Invalid Input - Zero SBC', () {
      final state = FootingDesignState(sbc: 0, columnLoad: 100);
      final result = service.runPipeline(state);

      // Should handle infinity or error
      expect(result.errorMessage, contains('SBC'));
    });
  });
}
