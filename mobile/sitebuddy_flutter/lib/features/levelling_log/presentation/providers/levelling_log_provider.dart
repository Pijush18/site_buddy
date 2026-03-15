/// FILE HEADER
/// File: levelling_log_provider.dart
/// Feature: levelling_log
/// Layer: providers
///
/// PURPOSE:
/// State management bridge connecting the UI and the calculation service.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/levelling_log/domain/entities/levelling_log.dart';
import 'package:site_buddy/features/levelling_log/domain/entities/levelling_entry.dart';
import 'package:site_buddy/features/levelling_log/domain/usecases/levelling_calculator.dart';

final levellingCalculatorServiceProvider = Provider<LevellingCalculator>((ref) {
  return LevellingCalculator();
});

class LevellingLogNotifier extends StateNotifier<LevellingLog> {
  final LevellingCalculator _calculatorService;

  LevellingLogNotifier(this._calculatorService)
    : super(
        const LevellingLog(
          projectName: '',
          benchmarkRL: 100.000,
          entries: [],
          sumBS: 0.0,
          sumFS: 0.0,
          isBalanced: true,
        ),
      ) {
    // Initialize with one default row
    addEntry();
  }

  void updateProjectName(String name) {
    state = state.copyWith(projectName: name);
  }

  void updateBenchmarkRL(double rl) {
    state = state.copyWith(benchmarkRL: rl);
    _recalculate();
  }

  void addQuickEntry({
    required String station,
    double? bs,
    double? isReading,
    double? fs,
  }) {
    // Determine if we should overwrite the initial dummy row or append
    final List<LevellingEntry> current = List.from(state.entries);

    final newEntry = LevellingEntry(
      station: station,
      bs: bs,
      isReading: isReading,
      fs: fs,
    );

    if (current.length == 1 &&
        !current.first.hasReading &&
        current.first.station == 'STN 1') {
      current[0] = newEntry;
    } else {
      current.add(newEntry);
    }

    state = state.copyWith(entries: current);
    _recalculate();
  }

  void addEntry() {
    final newEntry = LevellingEntry(station: 'STN ${state.entries.length + 1}');
    state = state.copyWith(entries: [...state.entries, newEntry]);
    _recalculate();
  }

  void updateEntry(int index, LevellingEntry entry) {
    final newEntries = List<LevellingEntry>.from(state.entries);
    newEntries[index] = entry;
    state = state.copyWith(entries: newEntries);
    _recalculate();
  }

  void removeEntry(int index) {
    if (state.entries.length <= 1) return; // Prevent deleting the last row

    final newEntries = List<LevellingEntry>.from(state.entries);
    newEntries.removeAt(index);
    state = state.copyWith(entries: newEntries);
    _recalculate();
  }

  /// Triggers the core computation engine to recalculate HIs and RLs down the chain.
  void _recalculate() {
    final result = _calculatorService.calculate(
      benchmarkRL: state.benchmarkRL,
      entries: state.entries,
    );

    state = state.copyWith(
      entries: result.updatedEntries,
      sumBS: result.sumBS,
      sumFS: result.sumFS,
      isBalanced: result.isBalanced,
    );
  }
}

final levellingLogProvider =
    StateNotifierProvider<LevellingLogNotifier, LevellingLog>((ref) {
      final calculator = ref.watch(levellingCalculatorServiceProvider);
      return LevellingLogNotifier(calculator);
    });
