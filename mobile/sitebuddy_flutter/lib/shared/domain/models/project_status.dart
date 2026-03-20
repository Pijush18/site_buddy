/// FILE HEADER
/// ----------------------------------------------
/// File: project_status.dart
/// Feature: project
/// Layer: domain
///
/// PURPOSE:
/// Defines the lifecycle state of a construction project.
///
/// RESPONSIBILITIES:
/// - Represents standard phases like planning, active, or completed.
///
/// DEPENDENCIES:
/// - None
///
/// FUTURE IMPROVEMENTS:
/// - Add localization extensions.
/// ----------------------------------------------
library;


import 'package:hive/hive.dart';

part 'project_status.g.dart';

/// ENUM: ProjectStatus
/// PURPOSE: Core status values a Project entity can hold.
@HiveType(typeId: 1)
enum ProjectStatus {
  @HiveField(0)
  planning('Planning'),
  @HiveField(1)
  active('Active'),
  @HiveField(2)
  onHold('On Hold'),
  @HiveField(3)
  completed('Completed');

  final String label;
  const ProjectStatus(this.label);

  static ProjectStatus fromString(String value) {
    return ProjectStatus.values.firstWhere(
      (e) =>
          e.name.toLowerCase() == value.toLowerCase() ||
          e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => ProjectStatus.active,
    );
  }
}



