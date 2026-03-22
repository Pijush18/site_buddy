
/// MODEL: PavementLayer
/// PURPOSE: Individual layer in a pavement crust (e.g., GSB, WMM).
class PavementLayer {
  final String name;
  final double thickness; // in mm
  final String materialType;
  final String? specification; // e.g., "MORTH 400"
  final bool isLocked; // For Pro feature handling

  const PavementLayer({
    required this.name,
    required this.thickness,
    required this.materialType,
    this.specification,
    this.isLocked = false,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'thickness': thickness,
    'materialType': materialType,
    'specification': specification,
    'isLocked': isLocked,
  };
}
