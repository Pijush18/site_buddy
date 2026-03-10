/// FILE HEADER
/// ----------------------------------------------
/// File: report_section.dart
/// Feature: reports
/// Layer: domain/entities
///
/// PURPOSE:
/// Defines the structural building blocks of an Enterprise Site Report.
///
/// RESPONSIBILITIES:
/// - Categorizes content using `ReportSectionType`.
/// - Holds the string-based payload representations ready for PDF/UI parsing.
/// ----------------------------------------------
library;


enum ReportSectionType { summary, calculation, conversion, knowledge, history }

class ReportSection {
  final ReportSectionType type;
  final String title;
  final List<String> content;

  const ReportSection({
    required this.type,
    required this.title,
    required this.content,
  });

  /// Helpful helper to combine lists cleanly without UI manipulation overhead.
  String get combinedContent => content.join('\n\n');
}
