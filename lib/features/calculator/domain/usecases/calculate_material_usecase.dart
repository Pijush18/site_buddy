/// FILE HEADER
/// ----------------------------------------------
/// File: calculate_material_usecase.dart
/// Feature: calculator
/// Layer: domain
///
/// PURPOSE:
/// Encapsulates the core engineering math for volume and cement calculations.
///
/// RESPONSIBILITIES:
/// - Takes input dimensions and calculates wet concrete volume.
/// - Applies the dry volume factor.
/// - Calculates required cement bags based on concrete grade.
///
/// DEPENDENCIES:
/// - Custom ConcreteGrade enum and MaterialResult entity.
///
/// FUTURE IMPROVEMENTS:
/// - Support calculating sand and aggregates.
///
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/concrete_grade.dart';
import 'package:site_buddy/shared/domain/models/material_result.dart';

/// CLASS: CalculateMaterialUseCase
/// PURPOSE: A stateless service class to perform standard site engineering calculations.
/// WHY: Separates complex mathematical rules from the UI and state management controllers.
class CalculateMaterialUseCase {
  /// A standard engineering constant. Wet concrete shrinks when setting.
  /// To get 1 cubic meter of wet concrete, you need roughly 1.54 cubic meters of dry materials.
  static const double _dryVolumeFactor = 1.54;

  /// The volume of one standard bag of cement in cubic meters (assuming 50kg bag at 1440 kg/m3 density).
  /// Calculation: 50 kg / 1440 kg/m3 = ~0.03472 m3.
  /// Standard bags per cubic meter of cement = 1 / 0.03472 = 28.8 bags.
  static const double _bagsPerCubicMeterOfCement = 28.8;

  /// METHOD: execute
  /// PURPOSE: Calculates required concrete mix materials given basic slab dimensions.
  /// PARAMETERS:
  /// - length: Double value in meters.
  /// - width: Double value in meters.
  /// - depth: Double value in meters.
  /// - grade: The [ConcreteGrade] chosen by the user.
  /// RETURNS:
  /// - [MaterialResult] object containing the volume, dry volume, and required cement bags.
  /// LOGIC:
  /// - 1. Calculate base volume (L * W * D)
  /// - 2. Calculate dry volume by applying the 1.54 constant.
  /// - 3. Determine the proportion of cement in the total mix based on the grade's ratio sum.
  /// - 4. Convert the required cement volume into standard bags.
  MaterialResult execute({
    required double length,
    required double width,
    required double depth,
    required ConcreteGrade grade,
  }) {
    // 1. Base geometric volume
    final volume = length * width * depth;

    // Quick exit if dimensions are 0
    if (volume <= 0) {
      return MaterialResult.empty();
    }

    // 2. Adjust for dry materials shrinkage
    final dryVolume = volume * _dryVolumeFactor;

    // 3. Find cement volume portion.
    // Eg. M20 is 1:1.5:3. Total parts = 5.5. Cement part = 1.
    // Cement Required (m3) = (1 / Total Parts) * Dry Volume
    final cementVolume = dryVolume * (1 / grade.customRatioSum);

    // 4. Convert volume to bags (ceil to ensure we don't buy slightly less than needed)
    final cementBags = (cementVolume * _bagsPerCubicMeterOfCement).ceil();

    return MaterialResult(
      volume: volume,
      dryVolume: dryVolume,
      cementBags: cementBags,
    );
  }
}
