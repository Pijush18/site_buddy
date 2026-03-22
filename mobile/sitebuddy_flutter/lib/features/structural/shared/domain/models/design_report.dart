
import 'package:hive/hive.dart';

part 'design_report.g.dart';

@HiveType(typeId: 20)
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
  brick,
  @HiveField(5)
  concrete,
  @HiveField(6)
  plaster,
  @HiveField(7)
  excavation,
  @HiveField(8)
  shuttering,
  @HiveField(9)
  steel,
  @HiveField(10)
  currency,
  @HiveField(11)
  siteLeveling,
  @HiveField(12)
  siteGradient,
  @HiveField(13)
  road,
  @HiveField(14)
  irrigation,
}

@HiveType(typeId: 21)
class DesignReport {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String projectId;
  @HiveField(2)
  final String typeLabel;
  @HiveField(3)
  final String summary;
  @HiveField(4)
  final DateTime timestamp;
  @HiveField(5)
  final DesignType designType;
  @HiveField(6)
  final Map<String, dynamic> inputs;
  @HiveField(7)
  final Map<String, dynamic> results;
  @HiveField(8)
  final bool isSafe;
  @HiveField(9)
  final Map<String, dynamic> data;
  @HiveField(10)
  final bool isSynced;
  @HiveField(11)
  final DateTime? updatedAt;

  DesignReport({
    required this.id,
    required this.projectId,
    required this.typeLabel,
    required this.summary,
    required this.timestamp,
    required this.designType,
    required this.inputs,
    required this.results,
    this.isSafe = true,
    this.data = const {},
    this.isSynced = false,
    this.updatedAt,
  });

  DesignReport copyWith({
    String? id,
    String? projectId,
    String? typeLabel,
    String? summary,
    DateTime? timestamp,
    DesignType? designType,
    Map<String, dynamic>? inputs,
    Map<String, dynamic>? results,
    bool? isSafe,
    Map<String, dynamic>? data,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return DesignReport(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      typeLabel: typeLabel ?? this.typeLabel,
      summary: summary ?? this.summary,
      timestamp: timestamp ?? this.timestamp,
      designType: designType ?? this.designType,
      inputs: inputs ?? this.inputs,
      results: results ?? this.results,
      isSafe: isSafe ?? this.isSafe,
      data: data ?? this.data,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
