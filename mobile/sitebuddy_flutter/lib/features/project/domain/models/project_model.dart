import 'package:hive/hive.dart';
import 'package:site_buddy/core/enums/unit_system.dart';

part 'project_model.g.dart';

/// ENUM: ProjectType
/// Defines the type of construction project.
@HiveType(typeId: 20)
enum ProjectType {
  @HiveField(0)
  residential('Residential'),
  @HiveField(1)
  commercial('Commercial'),
  @HiveField(2)
  industrial('Industrial'),
  @HiveField(3)
  infrastructure('Infrastructure'),
  @HiveField(4)
  other('Other');

  final String label;
  const ProjectType(this.label);
}

/// ENUM: ProjectStatus
/// Represents the current status of a project.
@HiveType(typeId: 21)
enum ProjectStatus {
  @HiveField(0)
  draft('Draft'),
  @HiveField(1)
  inProgress('In Progress'),
  @HiveField(2)
  completed('Completed'),
  @HiveField(3)
  archived('Archived');

  final String label;
  const ProjectStatus(this.label);
}

/// MODEL: ProjectModel
/// Core data model for a construction project in SiteBuddy.
/// 
/// This model serves as the foundation for the project system,
/// allowing users to create, manage, and export structural calculations.
@HiveType(typeId: 22)
class ProjectModel extends HiveObject {
  /// Unique identifier for the project
  @HiveField(0)
  final String id;

  /// Human-readable project name
  @HiveField(1)
  final String name;

  /// Project description
  @HiveField(2)
  final String? description;

  /// Type of construction project
  @HiveField(3)
  final ProjectType type;

  /// Current project status
  @HiveField(4)
  final ProjectStatus status;

  /// Unit system preference (metric/imperial)
  @HiveField(5)
  final UnitSystem unitSystem;

  /// Location of the project (optional)
  @HiveField(6)
  final String? location;

  /// Client name (optional)
  @HiveField(7)
  final String? clientName;

  /// All structural calculations in this project
  /// Key: calculation type (beam, slab, column, footing)
  /// Value: List of calculation data maps
  @HiveField(8)
  final Map<String, List<Map<String, dynamic>>> calculations;

  /// Project-specific settings and metadata
  @HiveField(9)
  final Map<String, dynamic>? metadata;

  /// Timestamps
  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  /// Owner/user ID who created the project
  @HiveField(12)
  final String? ownerId;

  /// Tags for organization
  @HiveField(13)
  final List<String> tags;

  /// Whether this project is synced to cloud
  @HiveField(14)
  final bool isSynced;

  /// Constructor
  ProjectModel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    this.status = ProjectStatus.draft,
    this.unitSystem = UnitSystem.metric,
    this.location,
    this.clientName,
    Map<String, List<Map<String, dynamic>>>? calculations,
    this.metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.ownerId,
    List<String>? tags,
    this.isSynced = false,
  })  : calculations = calculations ?? {},
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        tags = tags ?? [];

  /// Create a copy with updated fields
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    ProjectType? type,
    ProjectStatus? status,
    UnitSystem? unitSystem,
    String? location,
    String? clientName,
    Map<String, List<Map<String, dynamic>>>? calculations,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
    List<String>? tags,
    bool? isSynced,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      unitSystem: unitSystem ?? this.unitSystem,
      location: location ?? this.location,
      clientName: clientName ?? this.clientName,
      calculations: calculations ?? Map.from(this.calculations),
      metadata: metadata ?? Map.from(this.metadata ?? {}),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      ownerId: ownerId ?? this.ownerId,
      tags: tags ?? List.from(this.tags),
      isSynced: isSynced ?? this.isSynced,
    );
  }

  /// Add a calculation to the project
  ProjectModel addCalculation(String type, Map<String, dynamic> calculation) {
    final newCalculations = Map<String, List<Map<String, dynamic>>>.from(calculations);
    newCalculations[type] = [...(newCalculations[type] ?? []), calculation];
    return copyWith(calculations: newCalculations);
  }

  /// Remove a calculation from the project
  ProjectModel removeCalculation(String type, String calculationId) {
    final newCalculations = Map<String, List<Map<String, dynamic>>>.from(calculations);
    if (newCalculations.containsKey(type)) {
      newCalculations[type] = newCalculations[type]!
          .where((calc) => calc['id'] != calculationId)
          .toList();
    }
    return copyWith(calculations: newCalculations);
  }

  /// Get count of calculations by type
  int getCalculationCount(String type) {
    return calculations[type]?.length ?? 0;
  }

  /// Get total number of calculations
  int get totalCalculations {
    return calculations.values.fold(0, (sum, list) => sum + list.length);
  }

  /// Check if project has any calculations
  bool get hasCalculations => totalCalculations > 0;

  /// Get summary of calculation types
  Map<String, int> get calculationSummary {
    return {
      for (final entry in calculations.entries) entry.key: entry.value.length,
    };
  }

  /// Convert to JSON for API/Export
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'status': status.name,
      'unitSystem': unitSystem.name,
      'location': location,
      'clientName': clientName,
      'calculations': calculations,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ownerId': ownerId,
      'tags': tags,
      'isSynced': isSynced,
    };
  }

  /// Create from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: ProjectType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ProjectType.other,
      ),
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProjectStatus.draft,
      ),
      unitSystem: UnitSystem.values.firstWhere(
        (e) => e.name == json['unitSystem'],
        orElse: () => UnitSystem.metric,
      ),
      location: json['location'] as String?,
      clientName: json['clientName'] as String?,
      calculations: (json['calculations'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => Map<String, dynamic>.from(e)).toList(),
        ),
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String?,
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  @override
  String toString() => 'ProjectModel(id: $id, name: $name, type: ${type.label})';
}
