enum MortarRatio {
  oneToFour('1:4', 'Rich mix — 1:4 (stronger, water-retaining walls)'),
  oneToSix('1:6', 'Standard mix — 1:6 (general brickwork, IS 2212)');

  final String ratioString;
  final String label;

  const MortarRatio(this.ratioString, this.label);

  static MortarRatio fromString(String ratio) {
    return MortarRatio.values.firstWhere(
      (e) => e.ratioString == ratio,
      orElse: () => MortarRatio.oneToSix,
    );
  }
}
