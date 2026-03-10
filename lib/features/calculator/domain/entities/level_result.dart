/// FILE HEADER
/// ----------------------------------------------
/// File: level_result.dart
/// Feature: calculator
/// Layer: domain/entities
///
/// PURPOSE:
/// Represents the output of a level comparison between two elevations.
///
/// RESPONSIBILITIES:
/// - Stores start and end elevation values.
/// - Calculates the difference, absolute difference, and direction.
///
/// DEPENDENCIES:
/// - LevelDirection enum defined below.
///
/// FUTURE IMPROVEMENTS:
/// - Add formatted string helpers or units support.
/// ----------------------------------------------
library;


/// Direction of level change between two points.
enum LevelDirection { rise, fall, flat }

/// Data model returned by the level calculation use case.
class LevelResult {
  final double startLevel;
  final double endLevel;
  final double difference;
  final double absoluteDifference;
  final LevelDirection direction;

  const LevelResult({
    required this.startLevel,
    required this.endLevel,
    required this.difference,
    required this.absoluteDifference,
    required this.direction,
  });
}
