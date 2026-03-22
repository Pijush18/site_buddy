
/// SERVICE: CamberDesignService
/// PURPOSE: Designs road camber based on rainfall and surface type.
class CamberDesignService {
  
  /// Calculates recommended camber percentage.
  /// rainfall: 0 (Low), 1 (Heavy)
  /// surfaceType: 'Bituminous', 'Cement Concrete', 'Water Bound Macadam', 'Earthen'
  double calculateCamber(String surfaceType, int rainfall) {
    switch (surfaceType) {
      case 'Cement Concrete':
      case 'Bituminous':
        return rainfall == 1 ? 2.0 : 1.7;
      case 'Water Bound Macadam':
      case 'Gravel':
        return rainfall == 1 ? 3.0 : 2.5;
      case 'Earthen':
        return rainfall == 1 ? 4.0 : 3.0;
      default:
        return 2.0;
    }
  }

  double calculateCrownHeight(double roadWidth, double camberPercent) {
    return (roadWidth * (camberPercent / 100)) / 2;
  }
}
