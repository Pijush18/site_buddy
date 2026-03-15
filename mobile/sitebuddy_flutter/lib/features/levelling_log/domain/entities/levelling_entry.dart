/// FILE HEADER
/// File: levelling_entry.dart
/// Feature: levelling_log
/// Layer: models
///
/// PURPOSE:
/// Data model representing a single row in a levelling log table.
/// Supports Height of Instrument (HI) calculation method.
library;

class LevellingEntry {
  final String station;
  final double? bs;
  final double? isReading;
  final double? fs;
  final double? hi;
  final double? rl;
  final String remark;

  const LevellingEntry({
    required this.station,
    this.bs,
    this.isReading,
    this.fs,
    this.hi,
    this.rl,
    this.remark = '',
  });

  /// Creates a copy of the entry, allowing specific fields to be nullified.
  LevellingEntry copyWith({
    String? station,
    double? bs,
    bool nullifyBS = false,
    double? isReading,
    bool nullifyIS = false,
    double? fs,
    bool nullifyFS = false,
    double? hi,
    bool nullifyHI = false,
    double? rl,
    bool nullifyRL = false,
    String? remark,
  }) {
    return LevellingEntry(
      station: station ?? this.station,
      bs: nullifyBS ? null : (bs ?? this.bs),
      isReading: nullifyIS ? null : (isReading ?? this.isReading),
      fs: nullifyFS ? null : (fs ?? this.fs),
      hi: nullifyHI ? null : (hi ?? this.hi),
      rl: nullifyRL ? null : (rl ?? this.rl),
      remark: remark ?? this.remark,
    );
  }

  /// Helper to check if row has any non-null numerical reading
  bool get hasReading => bs != null || isReading != null || fs != null;
}
