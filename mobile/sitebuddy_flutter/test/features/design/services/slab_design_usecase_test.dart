import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/features/design/domain/usecases/slab_design_usecase.dart';
import 'package:site_buddy/shared/domain/models/design/slab_type.dart';

void main() {
  final useCase = SlabDesignUseCase();

  group('SlabDesignUseCase Verification', () {
    test('Case 1: One-Way Slab Moment Calculation', () {
      final result = useCase.execute(
        type: SlabType.oneWay,
        lx: 3.0,
        ly: 7.0,
        d: 150,
        deadLoad: 4.0, // kN/m2
        liveLoad: 2.0, // kN/m2
      );

      // Factored load = (4 + 2) * 1.5 = 9.0 kN/m2
      // Mu = (w * lx^2) / 8 = (9 * 9) / 8 = 10.125 kNm
      expect(result.bendingMoment, closeTo(10.125, 0.01));
      expect(result.mainRebar, contains('8mm'));
    });

    test('Case 2: Two-Way Slab (Simplified) Moment', () {
      final result = useCase.execute(
        type: SlabType.twoWay,
        lx: 4.0,
        ly: 5.0,
        d: 150,
        deadLoad: 3.0,
        liveLoad: 3.0,
      );

      // Factored load = (3 + 3) * 1.5 = 9.0 kN/m2
      // Mu = (w * lx^2) / 10 = (9 * 16) / 10 = 14.4 kNm
      expect(result.bendingMoment, closeTo(14.4, 0.01));
    });

    test('Case 3: Heavy Load - Rebar Scaling', () {
      final result = useCase.execute(
        type: SlabType.oneWay,
        lx: 5.0,
        ly: 10.0,
        d: 200,
        deadLoad: 10.0,
        liveLoad: 10.0,
      );

      // Resulting moment will be high, should suggest larger rebar
      expect(result.bendingMoment, greaterThan(30));
      expect(result.mainRebar, contains('12mm'));
    });

    test('Case 4: Zero LX - Boundary Handling', () {
      final result = useCase.execute(
        type: SlabType.oneWay,
        lx: 0,
        ly: 0,
        d: 150,
        deadLoad: 5,
        liveLoad: 5,
      );

      expect(result.bendingMoment, 0);
    });
  });
}
