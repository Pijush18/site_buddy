import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';

/// SERVICE: LevelCalculationService
/// PURPOSE: Handles surveying calculations for Level Log entries.
/// DESIGN: Pure logic service with support for HI and Rise/Fall methods.
class LevelCalculationService {
  /// Calculates Height of Instrument (HI) and Reduced Levels (RL) for a series of entries.
  /// HI = RL + BS
  /// RL = HI - reading (IS or FS)
  List<LevelEntry> calculateHISeries(List<LevelEntry> entries) {
    if (entries.isEmpty) return [];

    List<LevelEntry> results = [];
    double? currentHi;
    double? lastRl;

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      double? calculatedRl = entry.rl;
      double? calculatedHi = entry.hi;

      // Rule 1: Bench Mark (First row or row with provided RL and BS)
      if (entry.bs != null && calculatedRl != null) {
        calculatedHi = calculatedRl + entry.bs!;
      }
      // Rule 2: Calculate RL from existing HI
      else if (currentHi != null) {
        final reading = entry.isReading ?? entry.fs;
        if (reading != null) {
          calculatedRl = currentHi - reading;
        }

        // Rule 3: Change Point (if current row has FS and then a new BS)
        if (entry.bs != null && calculatedRl != null) {
          calculatedHi = calculatedRl + entry.bs!;
        }
      }

      final updatedEntry = entry.copyWith(rl: calculatedRl, hi: calculatedHi);

      results.add(updatedEntry);
      currentHi = calculatedHi ?? currentHi;
      lastRl = calculatedRl ?? lastRl;
    }

    return results;
  }

  /// Calculates Rise, Fall, and Reduced Levels for a series of entries.
  /// Rise = previous reading - current reading (if positive)
  /// Fall = current reading - previous reading (if positive)
  /// RL = previous RL + Rise - Fall
  List<LevelEntry> calculateRiseFallSeries(List<LevelEntry> entries) {
    if (entries.isEmpty) return [];

    List<LevelEntry> results = [];
    double? lastReading; // Can be BS or IS from previous row
    double? lastRl;

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      double? calculatedRise;
      double? calculatedFall;
      double? calculatedRl = entry.rl;

      if (i > 0 && lastReading != null) {
        final currentReading = entry.isReading ?? entry.fs;
        if (currentReading != null) {
          final diff = lastReading - currentReading;
          if (diff > 0) {
            calculatedRise = diff;
          } else {
            calculatedFall = -diff;
          }

          if (lastRl != null) {
            calculatedRl =
                lastRl + (calculatedRise ?? 0) - (calculatedFall ?? 0);
          }
        }
      }

      final updatedEntry = entry.copyWith(
        rise: calculatedRise,
        fall: calculatedFall,
        rl: calculatedRl,
      );

      results.add(updatedEntry);

      // For the next iteration, lastReading is the BS (if CP) or IS (if no BS)
      lastReading = entry.bs ?? entry.isReading;
      lastRl = calculatedRl ?? lastRl;
    }

    return results;
  }

  /// Verifies the arithmetic closure of the level book.
  /// ΣBS − ΣFS = Last RL − First RL
  /// Also checks Rise/Fall closure: ΣRise − ΣFall = Last RL − First RL
  Map<String, double> verifyLevelClosure(List<LevelEntry> entries) {
    if (entries.isEmpty) return {};

    double sumBs = 0;
    double sumFs = 0;
    double sumRise = 0;
    double sumFall = 0;

    for (var entry in entries) {
      sumBs += entry.bs ?? 0;
      sumFs += entry.fs ?? 0;
      sumRise += entry.rise ?? 0;
      sumFall += entry.fall ?? 0;
    }

    final firstRl = entries.first.rl ?? 0;
    final lastRl = entries.last.rl ?? 0;

    final bsFsDiff = sumBs - sumFs;
    final riseFallDiff = sumRise - sumFall;
    final rlDiff = lastRl - firstRl;

    return {
      'sumBS': sumBs,
      'sumFS': sumFs,
      'sumRise': sumRise,
      'sumFall': sumFall,
      'bsFsDiff': bsFsDiff,
      'riseFallDiff': riseFallDiff,
      'rlDiff': rlDiff,
      'error': rlDiff - bsFsDiff, // Should be close to zero
    };
  }

  /// Parses chainage string (e.g., "1+200" or "1200") to double meters.
  double? parseChainage(String input) {
    if (input.isEmpty) return null;
    if (input.contains('+')) {
      final parts = input.split('+');
      if (parts.length != 2) return double.tryParse(input);
      final km = double.tryParse(parts[0]) ?? 0.0;
      final m = double.tryParse(parts[1]) ?? 0.0;
      return (km * 1000) + m;
    }
    return double.tryParse(input);
  }

  /// Calculates slopes between consecutive valid entries.
  /// Slope % = ((RL2 - RL1) / (Chainage2 - Chainage1)) * 100
  List<double?> calculateSlopes(List<LevelEntry> entries) {
    List<double?> slopes = [];
    for (int i = 0; i < entries.length; i++) {
      if (i == 0) {
        slopes.add(null);
        continue;
      }

      final current = entries[i];
      final previous = entries[i - 1];

      if (current.rl != null &&
          previous.rl != null &&
          current.chainage != null &&
          previous.chainage != null) {
        final dist = current.chainage! - previous.chainage!;
        // Handle identical chainage specifically to prevent division by zero
        if (dist.abs() < 0.0001) {
          slopes.add(null);
        } else {
          final slope = ((current.rl! - previous.rl!) / dist) * 100;
          slopes.add(slope);
        }
      } else {
        slopes.add(null);
      }
    }
    return slopes;
  }
}
