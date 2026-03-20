import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/features/design/domain/services/beam_design_domain_service.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:flutter/foundation.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';

void main() {
  final service = BeamDesignDomainService();

  group('BeamDesignService Shear Fix Verification', () {
    test(
      'Stirrup spacing should change when steel grade changes (Fe415 vs Fe500)',
      () {
        // 1. Setup a state where tv > tc (shear reinforcement required)
        // Beam: 230x450, M25, 3m span, High loads to force shear reinforcement
        final initialState = BeamDesignState(
          type: BeamType.simplySupported,
          span: 2000,
          width: 230,
          overallDepth: 400,
          cover: 25,
          concreteGrade: 'M25',
          deadLoad: 40, // kN/m
          liveLoad: 20, // kN/m
          mainBarDia: 16,
          stirrupDia: 8,
          stirrupLegs: 2,
        );

        // 2. Perform analysis to get Vu
        final analyzedState = service.calculateAnalysis(initialState);

        // 3. Calculate reinforcement with Fe415
        final stateFe415 = service.calculateReinforcement(
          analyzedState.copyWith(
            steelGrade: 'Fe415',
            astProvided: 603,
          ), // 3 bars of 16mm
        );

        // 4. Calculate reinforcement with Fe500
        final stateFe500 = service.calculateReinforcement(
          analyzedState.copyWith(steelGrade: 'Fe500', astProvided: 603),
        );

        debugPrint(
          'DEBUG Test 1: Vu=${analyzedState.vu}, tv=${stateFe415.tv}, tc=${stateFe415.tc}, tcMax=${stateFe415.tcMax}',
        );
        debugPrint('Fe415 fy: ${service.getGradeValue(stateFe415.steelGrade)}');
        debugPrint('Fe415 Spacing: ${stateFe415.stirrupSpacing}');
        debugPrint('Fe500 fy: ${service.getGradeValue(stateFe500.steelGrade)}');
        debugPrint('Fe500 Spacing: ${stateFe500.stirrupSpacing}');

        // Verification:
        // Spacing formula: s = (0.87 * fy * asv * d) / vus
        // Fe500 (500) > Fe415 (415), so spacing for Fe500 should be LARGER than Fe415
        // (Unless capped by min spacing of 300mm or 0.75d)

        expect(
          stateFe500.stirrupSpacing,
          greaterThan(stateFe415.stirrupSpacing),
        );
      },
    );

    test('Minimum shear reinforcement should also respect steel grade', () {
      // Setup a state where tv < tc (minimum shear reinforcement required)
      final initialState = BeamDesignState(
        type: BeamType.simplySupported,
        span: 2000,
        width: 230,
        overallDepth: 500,
        concreteGrade: 'M25',
        deadLoad: 5,
        liveLoad: 5,
        astProvided: 500,
        stirrupDia: 6,
      );

      final analyzedState = service.calculateAnalysis(initialState);

      final stateFe415 = service.calculateReinforcement(
        analyzedState.copyWith(steelGrade: 'Fe415'),
      );

      final stateFe500 = service.calculateReinforcement(
        analyzedState.copyWith(steelGrade: 'Fe500'),
      );

      debugPrint('DEBUG Test 2: tv=${stateFe415.tv}, tc=${stateFe415.tc}');
      debugPrint('Min Shear Spacing Fe415: ${stateFe415.stirrupSpacing}');
      debugPrint('Min Shear Spacing Fe500: ${stateFe500.stirrupSpacing}');

      // Formula: s = (asv * 0.87 * fy) / (0.4 * b)
      // Fe500 should have LARGER spacing than Fe415 for minimum reinforcement
      expect(stateFe500.stirrupSpacing, greaterThan(stateFe415.stirrupSpacing));
    });
  });
}
