/// FILE HEADER
/// ----------------------------------------------
/// File: calculate_level_usecase.dart
/// Feature: calculator
/// Layer: domain/usecases
///
/// PURPOSE:
/// Performs simple level difference calculations and returns a [LevelResult].
///
/// RESPONSIBILITIES:
/// - Validate that input values are not null.
/// - Compute raw difference and absolute difference.
/// - Determine direction (rise, fall, flat).
///
/// NOTE:
/// This class contains pure Dart logic with no Flutter imports or side effects.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/surveying/level/domain/level_result.dart';

/// Use case which calculates the relationship between two elevation points.
class CalculateLevelUseCase {
  const CalculateLevelUseCase();

  /// Executes the calculation.
  ///
  /// Throws [ArgumentError] if either input is NaN.
  LevelResult execute({required double startLevel, required double endLevel}) {
    if (startLevel.isNaN || endLevel.isNaN) {
      throw ArgumentError('Levels must be valid numbers.');
    }

    final diff = endLevel - startLevel;
    final absDiff = diff.abs();

    LevelDirection direction;
    if (diff > 0) {
      direction = LevelDirection.rise;
    } else if (diff < 0) {
      direction = LevelDirection.fall;
    } else {
      direction = LevelDirection.flat;
    }

    return LevelResult(
      startLevel: startLevel,
      endLevel: endLevel,
      difference: diff,
      absoluteDifference: absDiff,
      direction: direction,
    );
  }
}




