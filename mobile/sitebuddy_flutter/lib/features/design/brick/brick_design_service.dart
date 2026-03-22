import 'package:site_buddy/core/engineering/standards/rcc/design_standard.dart';
import 'package:site_buddy/features/design/brick/brick_models.dart';
import 'package:site_buddy/shared/domain/models/brick_wall_result.dart';

/// SERVICE: BrickDesignService
/// PURPOSE: Encapsulates all formulas for brick masonry estimation.
class BrickDesignService {
  final DesignStandard standard;

  BrickDesignService(this.standard);

  BrickWallResult calculateMaterials(BrickInput input) {
    // 1. Wall volume
    final double wallVolume = input.length * input.height * input.thickness;

    // 2. Volume per brick with joint
    final double brickWithJointVolume =
        (standard.standardBrickLength + standard.standardMortarJoint) *
        (standard.standardBrickWidth + standard.standardMortarJoint) *
        (standard.standardBrickHeight + standard.standardMortarJoint);

    // 3. Number of bricks
    final int netBricks = (wallVolume / brickWithJointVolume).ceil();
    final int totalBricks = (netBricks * standard.brickWastageFactor).ceil();

    // 4. Pure brick volume
    final double pureBrickVolume = standard.standardBrickLength * 
                                   standard.standardBrickWidth * 
                                   standard.standardBrickHeight;
    final double totalBrickVolume = netBricks * pureBrickVolume;

    // 5. Mortar quantities
    final double mortarVolume = wallVolume - totalBrickVolume;
    final double dryMortarVolume = mortarVolume * standard.mortarDryVolumeFactor;

    final (int cParts, int sParts) = _parseMortarRatio(input.mortarRatio);
    final int totalMortarParts = cParts + sParts;
    
    final double cementVolumeM3 = dryMortarVolume * cParts / totalMortarParts;
    final double cementWeightKg = cementVolumeM3 * standard.cementBulkDensity;
    final double cementBags = (cementWeightKg / standard.cementBagWeight).ceilToDouble();
    final double actualCementWeightKg = cementBags * standard.cementBagWeight;
    final double sandVolumeM3 = dryMortarVolume * sParts / totalMortarParts;

    return BrickWallResult(
      wallVolume: _round(wallVolume),
      numberOfBricks: totalBricks,
      brickVolume: _round(totalBrickVolume),
      mortarVolume: _round(mortarVolume),
      dryMortarVolume: _round(dryMortarVolume),
      cementBags: cementBags,
      cementWeight: _round(actualCementWeightKg),
      sandVolume: _round(sandVolumeM3),
      mortarRatio: input.mortarRatio,
    );
  }

  (int, int) _parseMortarRatio(String ratio) {
    final parts = ratio.trim().split(':');
    if (parts.length != 2) return (1, 6);
    final int? c = int.tryParse(parts[0].trim());
    final int? s = int.tryParse(parts[1].trim());
    return (c ?? 1, s ?? 6);
  }

  double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}
