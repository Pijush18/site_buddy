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

  const Project({
    required this.id,
    required this.name,
    required this.location,
    this.clientName,
    this.description,
    required this.createdAt,
    required this.status,
    this.logsCount = 0,
    this.calculationsCount = 0,
    this.linkedChatIds = const [],
  });

  /// METHOD: initial
  /// PURPOSE: Factory for new empty project form state
  factory Project.initial() {
    return Project(
      id: '',
      name: '',
      location: '',
      createdAt: DateTime.now(),
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
    status,
    logsCount,
    calculationsCount,
    linkedChatIds,
    clientName,
  ];
}
