/// FILE HEADER
/// ----------------------------------------------
/// File: project.dart
/// Feature: project
/// Layer: domain
///
/// PURPOSE:
/// Entity representing a construction site project.
///
/// RESPONSIBILITIES:
/// - Holds metadata about the project (name, location, date).
/// - Tracks the number of generated logs and calculators attached to the project.
///
/// DEPENDENCIES:
/// - None
///
/// FUTURE IMPROVEMENTS:
/// - Add team members or permission boundary fields.
///
library;

/// - Add Firebase sync
/// - Add PDF export
/// - Add team collaboration
/// - Add offline storage
/// ----------------------------------------------


import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';

part 'project.g.dart';

/// CLASS: Project
/// PURPOSE: Core data structure for project details.
/// WHY: Provides a strong contract for the UI to depend on rather than raw Maps or JSON.
@HiveType(typeId: 0)
class Project extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String location;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final ProjectStatus status;
  @HiveField(6)
  final int logsCount;
  @HiveField(7)
  final int calculationsCount;

  /// Holds UUID strings referencing saved AI interactions.
  @HiveField(8)
  final List<String> linkedChatIds;
  @HiveField(9)
  final String? clientName;
  @HiveField(10)
  final DateTime updatedAt;
  @HiveField(11)
  final DateTime? lastAccessedAt;

  const Project({
    required this.id,
    required this.name,
    required this.location,
    this.clientName,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.lastAccessedAt,
    this.logsCount = 0,
    this.calculationsCount = 0,
    this.linkedChatIds = const [],
  });

  /// METHOD: initial
  /// PURPOSE: Factory for new empty project form state
  factory Project.initial() {
    final now = DateTime.now();
    return Project(
      id: '',
      name: '',
      location: '',
      createdAt: now,
      updatedAt: now,
      status: ProjectStatus.planning,
      linkedChatIds: const [],
      clientName: '',
    );
  }

  /// METHOD: copyWith
  /// PURPOSE: Immutable state duper for local updates
  Project copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastAccessedAt,
    ProjectStatus? status,
    int? logsCount,
    int? calculationsCount,
    List<String>? linkedChatIds,
    String? clientName,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      clientName: clientName ?? this.clientName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      status: status ?? this.status,
      logsCount: logsCount ?? this.logsCount,
      calculationsCount: calculationsCount ?? this.calculationsCount,
      linkedChatIds: linkedChatIds ?? this.linkedChatIds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    description,
    createdAt,
    updatedAt,
    lastAccessedAt,
    status,
    logsCount,
    calculationsCount,
    linkedChatIds,
    clientName,
  ];

  /// METHOD: fromJson
  /// PURPOSE: Deserialization from backend JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['created_at'] as String);
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String? ?? '',
      clientName: json['client_name'] as String?,
      description: json['description'] as String?,
      createdAt: createdAt,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : createdAt,
      lastAccessedAt: json['last_accessed_at'] != null 
          ? DateTime.parse(json['last_accessed_at'] as String) 
          : null,
      status: ProjectStatus.fromString(json['status'] as String? ?? 'active'),
      logsCount: json['logs_count'] as int? ?? 0,
      calculationsCount: json['calculations_count'] as int? ?? 0,
    );
  }

  /// METHOD: toJson
  /// PURPOSE: Serialization for backend POST requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'client_name': clientName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
      'status': status.name,
    };
  }
}



