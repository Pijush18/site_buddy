/// FILE HEADER
/// File: levelling_calculator_service.dart
/// Feature: levelling_log
/// Layer: services
///
/// PURPOSE:
/// Mathematical calculation engine that computes Height of Instrument (HI)
/// and Reduced Levels (RL) for an entire levelling log based on user inputs.
/// Re-balances whenever rows are inserted or edited.
library;

import 'package:site_buddy/features/levelling_log/domain/entities/levelling_entry.dart';

class LevellingCalculationResult {
  final List<LevellingEntry> updatedEntries;
  final double sumBS;
  final double sumFS;
  final bool isBalanced;

  const LevellingCalculationResult({
    required this.updatedEntries,
    required this.sumBS,
    required this.sumFS,
    required this.isBalanced,
  });
}

class LevellingCalculator {
  /// Computes the cascading HI and RL for all given entries.
  /// First entry starts at the global [benchmarkRL].
  LevellingCalculationResult calculate({
    required double benchmarkRL,
    required List<LevellingEntry> entries,
  }) {
    double sumBS = 0.0;
    double sumFS = 0.0;

    List<LevellingEntry> updated = [];
    double? currentHI;
    double? lastRL = benchmarkRL;
    double firstRL = benchmarkRL;

    for (int i = 0; i < entries.length; i++) {
      var entry = entries[i];

      double? entryRL;
      double? entryHI;

      if (i == 0) {
        // Station 1: Always starts at Benchmark RL
        entryRL = benchmarkRL;

        // If BS is provided, establish the first HI
        if (entry.bs != null) {
          entryHI = entryRL + entry.bs!;
          currentHI = entryHI;
          sumBS += entry.bs!;
        }
      } else {
        // Subsequent Stations: compute RL from the active HI
        if (currentHI != null) {
          if (entry.isReading != null) {
            entryRL = currentHI - entry.isReading!;
          } else if (entry.fs != null) {
            entryRL = currentHI - entry.fs!;
          }
        }

        // Apply RL
        if (entryRL != null) {
          lastRL = entryRL;

          // FS accumulation
          if (entry.fs != null) {
            sumFS += entry.fs!;
          }

          // Check for Change Point (CP) - both FS and BS taken
          if (entry.bs != null) {
            entryHI = entryRL + entry.bs!;
            currentHI = entryHI;
            sumBS += entry.bs!;
          }
        }
      }

      // Preserve the computed values back into the immutable model
      updated.add(
        entry.copyWith(
          rl: entryRL,
          nullifyRL: entryRL == null,
          hi: entryHI,
          nullifyHI: entryHI == null,
        ),
      );
    }

    // Mathematical error check (tolerance applied due to floating point math)
    // ΣBS − ΣFS = Last RL − First RL
    double bsFsDiff = sumBS - sumFS;
    double rlDiff = (lastRL ?? firstRL) - firstRL;
    bool isBalanced = (bsFsDiff - rlDiff).abs() < 0.005;

    // Edge case - if no readings exist, technically it is balanced.
    if (entries.every((e) => !e.hasReading)) {
      isBalanced = true;
    }

    return LevellingCalculationResult(
      updatedEntries: updated,
      sumBS: sumBS,
      sumFS: sumFS,
      isBalanced: isBalanced,
    );
  }
}
