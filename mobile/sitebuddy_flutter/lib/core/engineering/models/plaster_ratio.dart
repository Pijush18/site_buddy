enum PlasterRatio {
  oneToThree('1:3', '1:3  —  Rich mix (external / waterproofing coat)'),
  oneToFour('1:4', '1:4  —  Cement-rich (internal + external walls)'),
  oneToSix('1:6', '1:6  —  Standard mix (internal walls)');

  final String ratioString;
  final String label;

  const PlasterRatio(this.ratioString, this.label);

  static PlasterRatio fromString(String ratio) {
    return PlasterRatio.values.firstWhere(
      (e) => e.ratioString == ratio,
      orElse: () => PlasterRatio.oneToFour,
    );
  }
}



