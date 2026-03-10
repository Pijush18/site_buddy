import 'package:flutter_test/flutter_test.dart';
import 'package:site_buddy/features/design/domain/services/beam_design_domain_service.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';

void main() {
  final service = BeamDesignDomainService();

  group('BeamDesignService Verification', () {
    test('Case 1: Simply Supported Beam - Standard Design', () {
      final state = BeamDesignState(
        type: BeamType.simplySupported,
        span: 4000, // 4m
        width: 230,
        overallDepth: 450,
        cover: 25,
        concreteGrade: 'M25',
        steelGrade: 'Fe500',
        deadLoad: 15,
        liveLoad: 10,
        mainBarDia: 16,
      );

      // Analysis
      final analyzed = service.calculateAnalysis(state);

      // Wu = (15 + 10) * 1.5 = 37.5 kN/m
      // Mu = (37.5 * 4^2) / 8 = 75.0 kNm
      // Vu = (37.5 * 4) / 2 = 75.0 kN
      expect(analyzed.mu, closeTo(75.0, 0.1));
      expect(analyzed.vu, closeTo(75.0, 0.1));

      // Reinforcement
      final designed = service.calculateReinforcement(analyzed);
      expect(designed.isFlexureSafe, true);
      expect(designed.astRequired, greaterThan(400)); // ~460 mm2 for 75kNm
      expect(designed.numBars, greaterThan(2));
    });

    test('Case 2: Cantilever Beam - Point Load Analysis', () {
      final state = BeamDesignState(
        type: BeamType.cantilever,
        span: 2000, // 2m
        width: 230,
        overallDepth: 400,
        concreteGrade: 'M20',
        steelGrade: 'Fe415',
        deadLoad: 5,
        pointLoad: 20,
        mainBarDia: 20,
      );

      final analyzed = service.calculateAnalysis(state);

      // Factored loads: wu = 7.5 kN/m, pl = 30 kN
      // Mu = (7.5 * 2^2 / 2) + (30 * 2) = 15 + 60 = 75 kNm
      // Vu = (7.5 * 2) + 30 = 45 kN
      expect(analyzed.mu, closeTo(75.0, 0.1));
      expect(analyzed.vu, closeTo(45.0, 0.1));

      final designed = service.calculateReinforcement(analyzed);
      expect(designed.isFlexureSafe, true);
      expect(designed.astRequired, greaterThan(500));
    });

    test('Case 3: Over-reinforced Section - Invalid/Unsafe Handling', () {
      final state = BeamDesignState(
        type: BeamType.simplySupported,
        span: 6000,
        width: 150, // Very narrow
        overallDepth: 200, // Very shallow
        deadLoad: 50, // Massive load
        liveLoad: 50,
      );

      final analyzed = service.calculateAnalysis(state);
      final designed = service.calculateReinforcement(analyzed);

      expect(designed.isFlexureSafe, false);
      expect(designed.errorMessage, isNotEmpty);
    });

    test('Case 4: Invalid Inputs - Zero Span', () {
      final state = BeamDesignState(span: 0, deadLoad: 10);

      final analyzed = service.calculateAnalysis(state);
      expect(analyzed.mu, 0);
      expect(analyzed.vu, 0);
    });
  });
}
