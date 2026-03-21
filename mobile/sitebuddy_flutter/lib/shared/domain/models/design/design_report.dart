import 'package:hive/hive.dart';

part 'design_report.g.dart';

/// ENUM: DesignType
/// PURPOSE: Standardized identifiers for core structural categories.
@HiveType(typeId: 211)
enum DesignType {
  @HiveField(0)
  beam,
  @HiveField(1)
  slab,
  @HiveField(2)
  column,
  @HiveField(3)
  footing,
  @HiveField(4)
  levelLog,
  @HiveField(5)
  cement,
  @HiveField(6)
  rebar,
  @HiveField(7)
  brick,
  @HiveField(8)
  plaster,
  @HiveField(9)
  excavation,
  @HiveField(10)
  shuttering,
  @HiveField(11)
  sand,
}

/// ENTITY: DesignReport
/// PURPOSE: A standardized output format for ANY engineering calculation result.
/// 
/// IMPLEMENTATION:
/// - Stores inputs and results as generic maps to remain schema-agnostic.
/// - Includes top-level flags (isSafe) and summaries for quick UI consumption.
@HiveType(typeId: 210)
class DesignReport extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DesignType designType;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String? projectId;

  @HiveField(4)
  final Map<String, dynamic> inputs;

  @HiveField(5)
  final Map<String, dynamic> results;

  @HiveField(6)
  final String summary;

  @HiveField(7)
  final bool isSafe;

  DesignReport({
    required this.id,
    required this.designType,
    required this.timestamp,
    this.projectId,
    required this.inputs,
    required this.results,
    required this.summary,
    this.isSafe = false,
  });

  /// User-friendly label for the design type.
  String get typeLabel {
    switch (designType) {
      case DesignType.beam: return 'Beam Design';
      case DesignType.slab: return 'Slab Design';
      case DesignType.column: return 'Column Design';
      case DesignType.footing: return 'Footing Design';
      case DesignType.cement: return 'Cement Calculator';
      case DesignType.rebar: return 'Rebar Calculator';
      case DesignType.brick: return 'Brick Wall Calculator';
      case DesignType.plaster: return 'Plaster Calculator';
      case DesignType.excavation: return 'Excavation Calculator';
      case DesignType.shuttering: return 'Shuttering Calculator';
      case DesignType.sand: return 'Sand Calculator';
      case DesignType.levelLog: return 'Level Log';
    }
  }
}
