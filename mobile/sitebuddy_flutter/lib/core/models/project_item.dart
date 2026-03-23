import 'package:hive/hive.dart';

part 'project_item.g.dart';

/// MODEL: Project
/// Represents a container for grouped calculations/work
@HiveType(typeId: 1)
class Project extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// MODEL: ProjectItem
/// Links a HistoryItem to a Project (many-to-many relationship)
@HiveType(typeId: 2)
class ProjectItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final String historyItemId;

  @HiveField(3)
  final DateTime addedAt;

  ProjectItem({
    required this.id,
    required this.projectId,
    required this.historyItemId,
    required this.addedAt,
  });
}