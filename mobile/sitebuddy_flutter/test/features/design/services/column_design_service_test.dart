import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/features/structural/column/domain/column_design_service.dart';
import 'package:site_buddy/features/structural/column/domain/column_models.dart';
import 'package:site_buddy/features/structural/column/domain/column_enums.dart';
import 'package:site_buddy/core/engineering/standards/rcc/is_456_standard.dart';

void main() {
  final service = ColumnDesignService(IS456Standard());

  group('ColumnDesignService Verification', () {
    test('Case 1: Short Axial Column - Pure Compression', () {
      const input = ColumnInput(
        type: ColumnType.rectangular,
        endCondition: EndCondition.fixed,
        b: 300,
        d: 300,
        length: 3000,
        pu: 1200, // 1200 kN factored
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
        steelPercentage: 1.0,
        cover: 40,
      );

      final result = service.designColumn(input);
      
      expect(result.isShort, true); 
      expect(result.interactionRatio, lessThan(1.0));
      expect(result.isCapacitySafe, true);
    });

    test('Case 2: Slender Column - Moment Magnification', () {
      const input = ColumnInput(
        type: ColumnType.rectangular,
        endCondition: EndCondition.pinned,
        length: 5000, 
        b: 300,
        d: 300,
        pu: 500,
        mx: 20,
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
        cover: 40,
      );

      final result = service.designColumn(input);
      
      expect(result.isShort, false);
      expect(result.magnifiedMx, greaterThan(20.0));
    });

    test('Case 3: Circular Column - Minimum Reinforcement', () {
      const input = ColumnInput(
        type: ColumnType.circular,
        endCondition: EndCondition.fixed,
        b: 400, // Diameter
        length: 3000,
        pu: 200,
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
        cover: 40,
        isAutoSteel: true,
      );

      final result = service.designColumn(input);
      expect(result.numBars, greaterThanOrEqualTo(6));
    });

    test('Case 4: Invalid Inputs - Near Zero Dimensions', () {
      const input = ColumnInput(
        type: ColumnType.rectangular,
        endCondition: EndCondition.fixed,
        b: 0.1, 
        d: 0.1,
        length: 3000,
        pu: 500,
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
        cover: 40,
      );
      
      final result = service.designColumn(input);
      expect(result.isCapacitySafe, false);
    });
  });
}
