/// FILE HEADER
/// File: levelling_log.dart
/// Feature: levelling_log
/// Layer: models
///
/// PURPOSE:
/// Data model representing an entire levelling survey project payload.
library;

import 'package:site_buddy/features/levelling_log/domain/entities/levelling_entry.dart';

class LevellingLog {
  final String projectName;
  final double benchmarkRL;
  final List<LevellingEntry> entries;
  final double sumBS;
  final double sumFS;
  final bool isBalanced;

  const LevellingLog({
    required this.projectName,
    required this.benchmarkRL,
    required this.entries,
    required this.sumBS,
    required this.sumFS,
    required this.isBalanced,
  });

  LevellingLog copyWith({
    String? projectName,
    double? benchmarkRL,
    List<LevellingEntry>? entries,
    double? sumBS,
    double? sumFS,
    bool? isBalanced,
  }) {
    return LevellingLog(
      projectName: projectName ?? this.projectName,
      benchmarkRL: benchmarkRL ?? this.benchmarkRL,
      entries: entries ?? this.entries,
      sumBS: sumBS ?? this.sumBS,
      sumFS: sumFS ?? this.sumFS,
      isBalanced: isBalanced ?? this.isBalanced,
    );
  }
}
