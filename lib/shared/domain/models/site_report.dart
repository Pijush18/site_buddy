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
  final String projectName;
  final BrandingModel branding;
  final DateTime date;
  final List<ReportSection> sections;

  const SiteReport({
    required this.projectName,
    required this.branding,
    required this.date,
    required this.sections,
  });

  /// Validates if the entire constructed payload actually contains generated bodies.
  bool get isEmpty => sections.isEmpty;
}
