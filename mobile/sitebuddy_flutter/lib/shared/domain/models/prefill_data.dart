/// Lightweight data transfer objects to transfer extracted parameters from the
/// Smart Assistant into the various calculator screens.
/// ----------------------------------------------
library;

sealed class ToolPrefillData {
  const ToolPrefillData();
}

class ConcretePrefillData extends ToolPrefillData {
  final double? length;
  final double? width;
  final double? thickness;

  const ConcretePrefillData({this.length, this.width, this.thickness});

  @override
  String toString() => 'Concrete(L: $length, W: $width, T: $thickness)';
}

class BrickPrefillData extends ToolPrefillData {
  final double? length;
  final double? height;
  final double? thickness;

  const BrickPrefillData({this.length, this.height, this.thickness});

  @override
  String toString() => 'Brick(L: $length, H: $height, T: $thickness)';
}

class SteelWeightPrefillData extends ToolPrefillData {
  final double? length;
  final double? diameter;
  final double? spacing;

  const SteelWeightPrefillData({this.length, this.diameter, this.spacing});

  @override
  String toString() => 'Steel(L: $length, D: $diameter, S: $spacing)';
}

class ExcavationPrefillData extends ToolPrefillData {
  final double? length;
  final double? width;
  final double? depth;

  const ExcavationPrefillData({this.length, this.width, this.depth});

  @override
  String toString() => 'Excavation(L: $length, W: $width, D: $depth)';
}

class ShutteringPrefillData extends ToolPrefillData {
  final double? length;
  final double? width;
  final double? depth;

  const ShutteringPrefillData({this.length, this.width, this.depth});

  @override
  String toString() => 'Shuttering(L: $length, W: $width, D: $depth)';
}

class SlabDesignPrefillData extends ToolPrefillData {
  final double? lx;
  final double? ly;
  final double? depth;

  const SlabDesignPrefillData({this.lx, this.ly, this.depth});

  @override
  String toString() => 'SlabDesign(Lx: $lx, Ly: $ly, D: $depth)';
}

class BeamDesignPrefillData extends ToolPrefillData {
  final double? length;
  final double? width;
  final double? depth;

  const BeamDesignPrefillData({this.length, this.width, this.depth});

  @override
  String toString() => 'BeamDesign(L: $length, W: $width, D: $depth)';
}

class ColumnDesignPrefillData extends ToolPrefillData {
  final double? width;
  final double? depth;
  final double? height;

  const ColumnDesignPrefillData({this.width, this.depth, this.height});

  @override
  String toString() => 'ColumnDesign(W: $width, D: $depth, H: $height)';
}

class FootingDesignPrefillData extends ToolPrefillData {
  final double? length;
  final double? width;
  final double? depth;

  const FootingDesignPrefillData({this.length, this.width, this.depth});

  @override
  String toString() => 'FootingDesign(L: $length, W: $width, D: $depth)';
}



