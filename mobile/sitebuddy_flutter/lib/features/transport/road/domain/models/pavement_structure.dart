/// lib/features/transport/road/domain/models/pavement_structure.dart
///
/// Enhanced model for complete pavement structure with all layers.
/// 
/// PURPOSE:
/// - Define full pavement structure (subgrade to surface)
/// - Each layer includes strength parameters
/// - Support for IRC-compliant layer design
library;

/// Layer types in a flexible pavement structure
enum PavementLayerType {
  surface,      // Bituminous Concrete (BC)
  binder,       // Dense Bituminous Macadam (DBM)
  base,         // Wet Mix Macadam (WMM)
  subBase,      // Granular Sub-base (GSB)
  subgrade,     // Natural Subgrade
}

/// Material categories for pavement layers
enum PavementMaterial {
  // Surface course materials
  bituminousConcrete,
  semiDenseBituminous,
  denseBituminousMacadam,
  
  // Base/Sub-base materials  
  wetMixMacadam,
  granularSubBase,
  cementTreatedBase,
  
  // Subgrade
  naturalSubgrade,
  stabilizedSubgrade,
  
  // Other
  earth,
}

/// Enhanced pavement layer with strength parameters
class EnhancedPavementLayer {
  /// Layer type (surface, base, sub-base, subgrade)
  final PavementLayerType type;
  
  /// Layer name (e.g., "Bituminous Concrete")
  final String name;
  
  /// Layer thickness in mm
  final double thickness;
  
  /// Material used
  final PavementMaterial material;
  
  /// Elastic modulus in MPa (for analysis)
  final double? modulusMPa;
  
  /// California Bearing Ratio (%) - for subgrade/sub-base
  final double? cbr;
  
  /// Marshall Stability (kN) - for bituminous layers
  final double? marshallStability;
  
  /// Compaction degree (%) - field compaction target
  final double? compactionPercent;
  
  /// Dry density (kN/m³) - for compaction control
  final double? dryDensity;
  
  /// Specification reference (e.g., "IRC:37-2018", "MORTH 500")
  final String? specification;
  
  /// Whether this layer is locked (Pro feature gating handled in Application)
  final bool isLocked;

  const EnhancedPavementLayer({
    required this.type,
    required this.name,
    required this.thickness,
    required this.material,
    this.modulusMPa,
    this.cbr,
    this.marshallStability,
    this.compactionPercent,
    this.dryDensity,
    this.specification,
    this.isLocked = false,
  });

  /// Total thickness of this layer in meters
  double get thicknessMeters => thickness / 1000.0;

  /// Check if this is a bound (bituminous) layer
  bool get isBoundLayer => 
    material == PavementMaterial.bituminousConcrete ||
    material == PavementMaterial.semiDenseBituminous ||
    material == PavementMaterial.denseBituminousMacadam;

  /// Check if this is an unbound granular layer
  bool get isGranularLayer =>
    material == PavementMaterial.wetMixMacadam ||
    material == PavementMaterial.granularSubBase;

  Map<String, dynamic> toMap() => {
    'type': type.name,
    'name': name,
    'thickness': thickness,
    'material': material.name,
    'modulusMPa': modulusMPa,
    'cbr': cbr,
    'marshallStability': marshallStability,
    'compactionPercent': compactionPercent,
    'dryDensity': dryDensity,
    'specification': specification,
    'isLocked': isLocked,
  };
}

/// Complete pavement structure model
class PavementStructure {
  /// Surface course layer (top)
  final EnhancedPavementLayer surface;
  
  /// Binder course layer (optional, for thick designs)
  final EnhancedPavementLayer? binder;
  
  /// Base course layer
  final EnhancedPavementLayer base;
  
  /// Sub-base course layer
  final EnhancedPavementLayer subBase;
  
  /// Subgrade layer (natural or treated)
  final EnhancedPavementLayer subgrade;
  
  /// Total pavement thickness (excluding subgrade)
  final double totalPavementThickness;
  
  /// Total crust thickness (including subgrade)
  final double totalCrustThickness;

  const PavementStructure({
    required this.surface,
    this.binder,
    required this.base,
    required this.subBase,
    required this.subgrade,
    required this.totalPavementThickness,
    required this.totalCrustThickness,
  });

  /// Get all layers as a list (top to bottom)
  List<EnhancedPavementLayer> get allLayers {
    final layers = <EnhancedPavementLayer>[surface];
    if (binder != null) layers.add(binder!);
    layers.add(base);
    layers.add(subBase);
    layers.add(subgrade);
    return layers;
  }

  /// Get only pavement layers (excluding subgrade)
  List<EnhancedPavementLayer> get pavementLayers {
    final layers = <EnhancedPavementLayer>[surface];
    if (binder != null) layers.add(binder!);
    layers.add(base);
    layers.add(subBase);
    return layers;
  }

  Map<String, dynamic> toMap() => {
    'surface': surface.toMap(),
    'binder': binder?.toMap(),
    'base': base.toMap(),
    'subBase': subBase.toMap(),
    'subgrade': subgrade.toMap(),
    'totalPavementThickness': totalPavementThickness,
    'totalCrustThickness': totalCrustThickness,
  };
}

/// Helper to create standard IRC-compliant pavement layers
class PavementLayerFactory {
  /// Create standard IRC 37-2018 compliant layers
  static PavementStructure createIRCCompliantLayers({
    required double totalThickness,
    required double subgradeCBR,
    double minSurfaceThickness = 40.0,
    double minBaseThickness = 225.0,
    double minSubBaseThickness = 150.0,
  }) {
    // IRC layer distribution: BC 7%, DBM 18%, WMM 35%, GSB 40%
    final surfaceThickness = (totalThickness * 0.07).clamp(minSurfaceThickness, totalThickness * 0.15);
    final binderThickness = (totalThickness * 0.18).clamp(minSurfaceThickness, totalThickness * 0.25);
    final baseThickness = (totalThickness * 0.35).clamp(minBaseThickness, totalThickness * 0.50);
    final subBaseThickness = totalThickness - surfaceThickness - binderThickness - baseThickness;
    
    final remainingForSubBase = subBaseThickness.clamp(minSubBaseThickness, totalThickness * 0.40);

    return PavementStructure(
      surface: EnhancedPavementLayer(
        type: PavementLayerType.surface,
        name: 'Bituminous Concrete (BC)',
        thickness: surfaceThickness,
        material: PavementMaterial.bituminousConcrete,
        modulusMPa: 2000.0,
        marshallStability: 12.0,
        compactionPercent: 98.0,
        specification: 'IRC:37-2018, MORTH 500',
      ),
      binder: EnhancedPavementLayer(
        type: PavementLayerType.binder,
        name: 'Dense Bituminous Macadam (DBM)',
        thickness: binderThickness,
        material: PavementMaterial.denseBituminousMacadam,
        modulusMPa: 1500.0,
        marshallStability: 10.0,
        compactionPercent: 98.0,
        specification: 'IRC:37-2018, MORTH 500',
      ),
      base: EnhancedPavementLayer(
        type: PavementLayerType.base,
        name: 'Wet Mix Macadam (WMM)',
        thickness: baseThickness,
        material: PavementMaterial.wetMixMacadam,
        cbr: 80.0,
        compactionPercent: 100.0,
        dryDensity: 22.0,
        specification: 'IRC:37-2018, MORTH 400',
      ),
      subBase: EnhancedPavementLayer(
        type: PavementLayerType.subBase,
        name: 'Granular Sub-base (GSB)',
        thickness: remainingForSubBase > 0 ? remainingForSubBase : minSubBaseThickness,
        material: PavementMaterial.granularSubBase,
        cbr: subgradeCBR > 10 ? 30 : 20,
        compactionPercent: 100.0,
        dryDensity: 19.5,
        specification: 'IRC:37-2018, MORTH 400',
      ),
      subgrade: EnhancedPavementLayer(
        type: PavementLayerType.subgrade,
        name: 'Natural Subgrade',
        thickness: 500.0, // Representative thickness
        material: PavementMaterial.naturalSubgrade,
        cbr: subgradeCBR,
        compactionPercent: 95.0,
        dryDensity: 18.0,
        specification: 'IRC:37-2018',
      ),
      totalPavementThickness: totalThickness,
      totalCrustThickness: totalThickness + 500.0,
    );
  }
}
