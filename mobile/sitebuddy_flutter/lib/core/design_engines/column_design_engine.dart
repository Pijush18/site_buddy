import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/features/design/column/column_models.dart';
import 'package:site_buddy/features/design/column/column_design_service.dart';

/// ENGINE: ColumnDesignEngine
/// Pure orchestrator that delegates engineering logic to ColumnDesignService.
class ColumnDesignEngine {
  final ColumnDesignService service;

  ColumnDesignEngine(this.service);

  /// METHOD: calculate
  /// Orchestrates the design process for a column.
  ColumnDesignOutputs calculate(ColumnDesignInputs inputs) {
    // 1. Convert Inputs
    final input = ColumnInput(
      type: inputs.type,
      b: inputs.b,
      d: inputs.d,
      length: inputs.length,
      endCondition: inputs.endCondition,
      cover: inputs.cover,
      concreteGrade: inputs.concreteGrade,
      steelGrade: inputs.steelGrade,
      pu: inputs.pu,
      mx: inputs.mx,
      my: inputs.my,
    );

    // 2. Delegate to Service
    final result = service.designColumn(input);

    // 3. Return Outputs
    return ColumnDesignOutputs(
      reinforcement: result.reinforcement,
      ties: result.ties,
      interactionRatio: result.interactionRatio,
      isCapacitySafe: result.isCapacitySafe,
      isSlendernessSafe: result.isSlendernessSafe,
    );
  }
}



