/// CLASS: LevelEntry
/// PURPOSE: Represents a single row in a surveying level book.
/// DESIGN: Supports both HI and Rise/Fall fields, plus chainage for distance analysis.
class LevelEntry {
  final String station;
  final double? chainage; // Distance in meters
  final double? bs; // Backsight
  final double? isReading; // Intermediate Sight
  final double? fs; // Foresight
  final double? hi; // Height of Instrument
  final double? rl; // Reduced Level
  final double? rise; // Rise
  final double? fall; // Fall
  final String? remark;
  final String? projectId;

  const LevelEntry({
    required this.station,
    this.chainage,
    this.bs,
    this.isReading,
    this.fs,
    this.hi,
    this.rl,
    this.rise,
    this.fall,
    this.remark,
    this.projectId,
  });

  /// Creates a copy of LevelEntry with updated values.
  LevelEntry copyWith({
    String? station,
    double? chainage,
    double? bs,
    double? isReading,
    double? fs,
    double? hi,
    double? rl,
    double? rise,
    double? fall,
    String? remark,
    String? projectId,
  }) {
    return LevelEntry(
      station: station ?? this.station,
      chainage: chainage ?? this.chainage,
      bs: bs ?? this.bs,
      isReading: isReading ?? this.isReading,
      fs: fs ?? this.fs,
      hi: hi ?? this.hi,
      rl: rl ?? this.rl,
      rise: rise ?? this.rise,
      fall: fall ?? this.fall,
      remark: remark ?? this.remark,
      projectId: projectId ?? this.projectId,
    );
  }

  /// Map representation for serialization or debugging.
  Map<String, dynamic> toMap() {
    return {
      'station': station,
      'chainage': chainage,
      'bs': bs,
      'isReading': isReading,
      'fs': fs,
      'hi': hi,
      'rl': rl,
      'rise': rise,
      'fall': fall,
      'remark': remark,
      'projectId': projectId,
    };
  }

  Map<String, dynamic> toJson() => toMap();
}



