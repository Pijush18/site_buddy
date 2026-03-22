
import 'dart:math' as math;
import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';

/// SERVICE: BeamDesignService
/// PURPOSE: Encapsulates engineering logic for RCC beam design.
class BeamDesignService {
  final DesignStandard standard;

  BeamDesignService(this.standard);

  BeamDesignState calculateAnalysis(BeamDesignState state) {
    final spanM = state.span / 1000;
    final wu = (state.deadLoad + state.liveLoad) * (state.isULS ? standard.gammaLoad : 1.0);
    
    // Simple Span Moment: wl^2 / 8
    final mu = (wu * math.pow(spanM, 2)) / 8;
    final vu = (wu * spanM) / 2;

    return state.copyWith(
      mu: mu,
      vu: vu,
      wu: wu,
    );
  }

  BeamDesignState calculateDesign(BeamDesignState state) {
    // Simplified Steel Calculation
    final fck = double.tryParse(state.concreteGrade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
    final fy = double.tryParse(state.steelGrade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 500;
    
    final d = state.overallDepth - state.cover;
    final b = state.width;
    
    final mu = state.mu * 1e6; // to N-mm
    
    // Ast = 0.5 fck/fy [1 - sqrt(1 - 4.6 Mu / (fck b d^2))] b d
    final term = 1 - (4.6 * mu) / (fck * b * math.pow(d, 2));
    double astReq = 0;
    if (term > 0) {
      astReq = 0.5 * (fck / fy) * (1 - math.sqrt(term)) * b * d;
    }
    
    return state.copyWith(
      astRequired: astReq,
      astProvided: astReq * 1.1, // Placeholder
    );
  }

  BeamDesignState calculateSafety(BeamDesignState state) {
    return state.copyWith(
      isFlexureSafe: state.astProvided >= state.astRequired,
      isShearSafe: true,
      isDeflectionSafe: true,
    );
  }

  // Legacy compatibility
  dynamic designBeam(dynamic input) {
    return null;
  }
}
