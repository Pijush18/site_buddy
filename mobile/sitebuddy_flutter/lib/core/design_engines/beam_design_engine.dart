import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_models.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_service.dart';

/// ENGINE: BeamDesignEngine
/// Pure orchestrator that delegates engineering logic to BeamDesignService.
class BeamDesignEngine {
  final BeamDesignService service;

  BeamDesignEngine(this.service);

  /// METHOD: calculate
  /// Orchestrates the design process for a beam.
  BeamDesignOutputs calculate(BeamDesignInputs inputs) {
    // 1. Convert Inputs (Strongly typed domain models)
    final input = BeamInput(
      type: inputs.type,
      span: inputs.span,
      width: inputs.width,
      overallDepth: inputs.overallDepth,
      cover: inputs.cover,
      concreteGrade: inputs.concreteGrade,
      steelGrade: inputs.steelGrade,
      deadLoad: inputs.deadLoad,
      liveLoad: inputs.liveLoad,
      pointLoad: inputs.pointLoad,
    );

    // 2. Delegate to Service
    final result = service.designBeam(input);

    // 3. Return Outputs
    return BeamDesignOutputs(
      bendingMoment: result.bendingMoment,
      shearForce: result.shearForce,
      topRebar: result.topRebar,
      bottomRebar: result.bottomRebar,
      stirrups: result.stirrups,
      isFlexureSafe: result.isFlexureSafe,
      isShearSafe: result.isShearSafe,
      isDeflectionSafe: result.isDeflectionSafe,
    );
  }
}




