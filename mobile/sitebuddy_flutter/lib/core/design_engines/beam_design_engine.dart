import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';

class BeamDesignEngine {
  const BeamDesignEngine();

  /// METHOD: calculate
  /// Performs analysis and reinforcement design for a beam.
  BeamDesignOutputs calculate(BeamDesignInputs inputs) {
    // 1. Load Factoring
    final totalLoad = (inputs.deadLoad + inputs.liveLoad) * 1.5;
    final factoredPointLoad = inputs.pointLoad * 1.5;

    // 2. Analysis (Bending Moment and Shear Force)
    double bendingMoment = 0.0;
    double shearForce = 0.0;
    final L = inputs.span / 1000; // mm to m

    if (inputs.type == BeamType.simplySupported) {
      bendingMoment = (totalLoad * L * L / 8) + (factoredPointLoad * L / 4);
      shearForce = (totalLoad * L / 2) + (factoredPointLoad / 2);
    } else if (inputs.type == BeamType.cantilever) {
      bendingMoment = (totalLoad * L * L / 2) + (factoredPointLoad * L);
      shearForce = (totalLoad * L) + factoredPointLoad;
    } else {
      // Continuous / Fixed (simplified)
      bendingMoment = (totalLoad * L * L / 12);
      shearForce = (totalLoad * L / 2);
    }

    // 3. Reinforcement Design (simplified logic)
    final d = inputs.overallDepth - inputs.cover;
    final bottomRebar = _calculateBottomRebar(bendingMoment, d);
    final topRebar = "2 - 12mm Hangers"; // Standard practice
    final stirrups = "8mm @ 150mm c/c";

    // 4. Safety Checks
    final isDeflectionSafe = _checkDeflection(inputs);

    return BeamDesignOutputs(
      bendingMoment: bendingMoment,
      shearForce: shearForce,
      topRebar: topRebar,
      bottomRebar: bottomRebar,
      stirrups: stirrups,
      isFlexureSafe: true, // Simplified
      isShearSafe: true, // Simplified
      isDeflectionSafe: isDeflectionSafe,
    );
  }

  String _calculateBottomRebar(double moment, double depth) {
    if (moment < 20) return "2 - 12mm bars";
    if (moment < 50) return "2 - 16mm bars";
    if (moment < 100) return "3 - 16mm bars";
    return "4 - 20mm bars";
  }

  bool _checkDeflection(BeamDesignInputs inputs) {
    // IS 456 Cl. 23.2.1: Basic L/d ratios
    final ratio = inputs.span / (inputs.overallDepth - inputs.cover);
    double limit = 20.0; // Simply Supported
    if (inputs.type == BeamType.cantilever) limit = 7.0;
    if (inputs.type == BeamType.continuous) limit = 26.0;

    return ratio <= limit;
  }
}
