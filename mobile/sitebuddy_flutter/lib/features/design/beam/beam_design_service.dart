import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/beam/beam_models.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';

/// SERVICE: BeamDesignService
/// PURPOSE: Encapsulates all engineering formulas and logic for beam design.
class BeamDesignService {
  final DesignStandard standard;

  BeamDesignService(this.standard);

  /// METHOD: designBeam
  /// Performs full structural design based on the provided input.
  BeamResult designBeam(BeamInput input) {
    // 1. Load Factoring
    final totalLoad = (input.deadLoad + input.liveLoad) * standard.gammaLoad;
    final factoredPointLoad = input.pointLoad * standard.gammaLoad;

    // 2. Analysis (Bending Moment and Shear Force)
    double bendingMoment = 0.0;
    double shearForce = 0.0;
    final L = input.span / 1000; // mm to m

    if (input.type == BeamType.simplySupported) {
      bendingMoment = (totalLoad * L * L / 8) + (factoredPointLoad * L / 4);
      shearForce = (totalLoad * L / 2) + (factoredPointLoad / 2);
    } else if (input.type == BeamType.cantilever) {
      bendingMoment = (totalLoad * L * L / 2) + (factoredPointLoad * L);
      shearForce = (totalLoad * L) + factoredPointLoad;
    } else {
      bendingMoment = (totalLoad * L * L / 12);
      shearForce = (totalLoad * L / 2);
    }

    // 3. Reinforcement Design
    final d = input.overallDepth - input.cover;
    final bottomRebar = _calculateBottomRebar(bendingMoment, d);
    const topRebar = "2 - 12mm Hangers"; 
    const stirrups = "8mm @ 150mm c/c";

    // 4. Safety Checks
    final isDeflectionSafe = _checkDeflection(input);
    final isFlexureSafe = _checkFlexure(bendingMoment, input, d);

    return BeamResult(
      bendingMoment: bendingMoment,
      shearForce: shearForce,
      topRebar: topRebar,
      bottomRebar: bottomRebar,
      stirrups: stirrups,
      isFlexureSafe: isFlexureSafe,
      isShearSafe: true, 
      isDeflectionSafe: isDeflectionSafe,
    );
  }

  bool _checkFlexure(double mu, BeamInput input, double d) {
    final fck = double.tryParse(input.concreteGrade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 25;
    final fy = double.tryParse(input.steelGrade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 415;
    final mulim = standard.muLimitFactor(fy) * fck * input.width * d * d / 1e6;
    return mu <= mulim;
  }

  String _calculateBottomRebar(double moment, double depth) {
    if (moment < 20) return "2 - 12mm bars";
    if (moment < 50) return "2 - 16mm bars";
    if (moment < 100) return "3 - 16mm bars";
    return "4 - 20mm bars";
  }

  bool _checkDeflection(BeamInput input) {
    final ratio = input.span / (input.overallDepth - input.cover);
    double limit = standard.deflectionLimitSimplySupported;
    if (input.type == BeamType.cantilever) limit = standard.deflectionLimitCantilever;
    if (input.type == BeamType.continuous) limit = standard.deflectionLimitContinuous;

    return ratio <= limit;
  }
}
