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
  @HiveField(12)
  gradient,
  @HiveField(13)
  unitConverter,
  @HiveField(14)
  currencyConverter,
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
  final String projectId;

  @HiveField(4)
  final Map<String, dynamic> inputs;

  @HiveField(5)
  final Map<String, dynamic> results;

  @HiveField(6)
  final String summary;

  @HiveField(7)
  final bool isSafe;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final bool isSynced;

  DesignReport({
    required this.id,
    required this.designType,
    required this.timestamp,
    required this.projectId,
    required this.inputs,
    required this.results,
    required this.summary,
    this.isSafe = false,
    DateTime? updatedAt,
    this.isSynced = false,
  }) : updatedAt = updatedAt ?? timestamp {
    if (projectId.isEmpty) {
      throw ArgumentError('DesignReport must be linked to a valid projectId');
    }
  }

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
      case DesignType.levelLog: return 'Level Calculator';
      case DesignType.gradient: return 'Gradient Tool';
      case DesignType.unitConverter: return 'Unit Converter';
      case DesignType.currencyConverter: return 'Currency Converter';
    }
  }
  DesignReport copyWith({
    String? id,
    DesignType? designType,
    DateTime? timestamp,
    String? projectId,
    Map<String, dynamic>? inputs,
    Map<String, dynamic>? results,
    String? summary,
    bool? isSafe,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return DesignReport(
      id: id ?? this.id,
      designType: designType ?? this.designType,
      timestamp: timestamp ?? this.timestamp,
      projectId: projectId ?? this.projectId,
      inputs: inputs ?? this.inputs,
      results: results ?? this.results,
      summary: summary ?? this.summary,
      isSafe: isSafe ?? this.isSafe,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
