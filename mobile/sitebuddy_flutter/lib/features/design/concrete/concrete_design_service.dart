import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';
import 'package:site_buddy/features/design/concrete/concrete_models.dart';
import 'package:site_buddy/shared/domain/models/concrete_material_result.dart';

/// SERVICE: ConcreteDesignService
/// PURPOSE: Encapsulates all formulas for concrete material estimation.
class ConcreteDesignService {
  final DesignStandard standard;

  ConcreteDesignService(this.standard);

  ConcreteMaterialResult calculateMaterials(ConcreteInput input) {
    final mix = input.grade ?? ConcreteMixConstants.m20;

    // 1. Volumes
    final double wetVolume = input.length * input.width * input.depth;
    final double dryVolume = wetVolume * standard.concreteDryVolumeFactor;
    final double totalParts = mix.totalParts;

    // 2. Cement
    final double cementVolumeM3 = dryVolume * (mix.cementRatio / totalParts);
    final double cementWeightKg = cementVolumeM3 * standard.cementBulkDensity;
    final double cementBags = (cementWeightKg / standard.cementBagWeight).ceilToDouble();
    final double actualCementWeightKg = cementBags * standard.cementBagWeight;

    // 3. Sand
    final double sandVolumeM3 = dryVolume * (mix.sandRatio / totalParts);

    // 4. Aggregate
    final double aggregateVolumeM3 = dryVolume * (mix.aggregateRatio / totalParts);

    // 5. Reinforcement (RCC)
    final double steelWeightKg = wetVolume * input.steelPercentage * standard.steelDensity;

    // 6. Binding wire (1%)
    final double bindingWireKg = steelWeightKg * 0.01;

    return ConcreteMaterialResult(
      concreteVolume: _round(wetVolume),
      cementBags: cementBags,
      cementWeight: _round(actualCementWeightKg),
      sandVolume: _round(sandVolumeM3),
      aggregateVolume: _round(aggregateVolumeM3),
      steelWeight: _round(steelWeightKg),
      bindingWire: _round(bindingWireKg),
      concreteGrade: mix.grade,
      dryVolumeFactor: standard.concreteDryVolumeFactor,
    );
  }

  double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}
