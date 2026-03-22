import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/plaster/plaster_models.dart';
import 'package:site_buddy/shared/domain/models/plaster_material_result.dart';

/// SERVICE: PlasterDesignService
/// PURPOSE: Encapsulates all formulas for plastering estimation.
class PlasterDesignService {
  final DesignStandard standard;

  PlasterDesignService(this.standard);

  PlasterMaterialResult calculateMaterials(PlasterInput input) {
    // 1. Volume
    final double wetVolume = input.area * input.thickness;
    final double dryVolume = wetVolume * standard.mortarDryVolumeFactor;

    // 2. Parse ratio
    final (int cParts, int sParts) = _parseMortarRatio(input.mortarRatio);
    final int totalParts = cParts + sParts;

    // 3. Quantities
    final double cementVolumeM3 = dryVolume * cParts / totalParts;
    final double cementWeightKg = cementVolumeM3 * standard.cementBulkDensity;
    final double cementBags = (cementWeightKg / standard.cementBagWeight).ceilToDouble();
    final double actualCementWeightKg = cementBags * standard.cementBagWeight;
    final double sandVolumeM3 = dryVolume * sParts / totalParts;

    return PlasterMaterialResult(
      plasterArea: _round(input.area),
      thickness: input.thickness,
      wetVolume: _round(wetVolume),
      dryVolume: _round(dryVolume),
      cementBags: cementBags,
      cementWeight: _round(actualCementWeightKg),
      sandVolume: _round(sandVolumeM3),
      mortarRatio: input.mortarRatio,
      dryVolumeFactor: standard.mortarDryVolumeFactor,
    );
  }

  (int, int) _parseMortarRatio(String ratio) {
    final parts = ratio.trim().split(':');
    if (parts.length != 2) return (1, 4);
    final int? c = int.tryParse(parts[0].trim());
    final int? s = int.tryParse(parts[1].trim());
    return (c ?? 1, s ?? 4);
  }

  double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}
