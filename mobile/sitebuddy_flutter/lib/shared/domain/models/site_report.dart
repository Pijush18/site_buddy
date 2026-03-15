/// FILE HEADER
/// ----------------------------------------------
/// File: site_report.dart
/// Feature: reports
/// Layer: domain/entities
///
/// PURPOSE:
/// Encapsulates the entire domain model representation of an exported engineering report.
///
/// RESPONSIBILITIES:
/// - Bonds global BrandingContext alongside Project nomenclature.
/// - Houses a dynamic, sequentially ordered collection of `ReportSection` representations.
/// ----------------------------------------------
library;


import 'package:site_buddy/core/branding/branding_model.dart';
import 'package:site_buddy/shared/domain/models/report_section.dart';

class SiteReport {
  final String id;
  final String projectId;
  final String projectName;
  final BrandingModel branding;
  final DateTime date;
  final List<ReportSection> sections;
  final String? filePath;
  final String? fileUrl;

  const SiteReport({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.branding,
    required this.date,
    required this.sections,
    this.filePath,
    this.fileUrl,
  });

  /// METHOD: fromJson
  /// PURPOSE: Deserialization from backend JSON
  factory SiteReport.fromJson(Map<String, dynamic> json) {
    return SiteReport(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      projectName: json['project_name'] as String? ?? 'Unnamed Project',
      branding: BrandingModel.defaultBranding(), // Simplified for now
      date: DateTime.parse(json['created_at'] as String),
      sections: [], // Content sections are often not retrieved for list views
      fileUrl: json['file_url'] as String?,
    );
  }

  /// METHOD: toJson
  /// PURPOSE: Serialization for backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'created_at': date.toIso8601String(),
      'file_url': fileUrl,
    };
  }

  /// Validates if the entire constructed payload actually contains generated bodies.
  bool get isEmpty => sections.isEmpty;
}
