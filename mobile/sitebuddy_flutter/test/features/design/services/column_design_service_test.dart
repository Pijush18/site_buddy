import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/features/design/application/services/column_design_service.dart';
import 'package:site_buddy/shared/domain/models/design/column_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

void main() {
  final service = ColumnDesignService();

  group('ColumnDesignService Verification', () {
    test('Case 1: Short Axial Column - Pure Compression', () {
      final state = ColumnDesignState(
        type: ColumnType.rectangular,
        loadType: LoadType.axial,
        length: 3000,
        b: 300,
        d: 300,
        pu: 1200, // 1200 kN factored
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
        steelPercentage: 1.0,
      );

      final slenderness = service.calculateSlenderness(state);
      expect(slenderness.isShort, true); // 3000/300 = 10 < 12

      final design = service.calculateDesign(slenderness);
      // Puz = (0.45 * 25 * Ac + 0.75 * fy * Asc)
      // Ag = 90000, Asc = 900, Ac = 89100
      // Puz = (0.45 * 25 * 89100 + 0.75 * 500 * 900) / 1000 = 1002.3 + 337.5 = 1339.8 kN
      expect(design.interactionRatio, lessThan(1.0));
      expect(design.isCapacitySafe, true);
    });

    test('Case 2: Slender Column - Moment Magnification', () {
      final state = ColumnDesignState(
        type: ColumnType.rectangular,
        length: 6000, // 6m (Slender)
        b: 300,
        d: 300,
        pu: 500,
        mx: 20,
        endCondition: EndCondition.pinned,
      );

      final slenderness = service.calculateSlenderness(state);
      expect(slenderness.isShort, false);
      expect(slenderness.magnifiedMx, greaterThan(20.0)); // Should be amplified
    });

    test('Case 3: Circular Column - Minimum Reinforcement', () {
      final state = ColumnDesignState(
        type: ColumnType.circular,
        b: 400, // Diameter
        astRequired: 100, // Very low req
      );

      final detailing = service.calculateDetailing(state);
      // IS 456 requires min 6 bars for circular column
      expect(detailing.numBars, greaterThanOrEqualTo(6));
    });

    test('Case 4: Invalid Inputs - Zero Dimensions', () {
      final state = ColumnDesignState(b: 0, d: 0, pu: 500);
      final design = service.calculateDesign(state);
      expect(design.ag, 0);
      expect(
        design.interactionRatio.isInfinite || design.interactionRatio.isNaN,
        true,
      );
    });
  });
}
