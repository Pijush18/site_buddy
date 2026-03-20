

/// ENUM: ReportSectionType
/// Categorizes sections for specialized rendering in the report.
enum ReportSectionType { input, calculation, result, check }

/// MODEL: CalculationItem
/// Represents a single parameter or result row in a report.
class CalculationItem {
  final String label;
  final String value;
  final String? unit;
  final String? formula;

  CalculationItem({
    required this.label,
    required this.value,
    this.unit,
    this.formula,
  });
}

/// MODEL: CalculationSection
/// A group of related calculation items under a single heading.
class CalculationSection {
  final String heading;
  final ReportSectionType type;
  final List<CalculationItem> items;

  CalculationSection({
    required this.heading,
    required this.type,
    required this.items,
  });
}

/// MODEL: ReportData
/// Root object containing all metadata and sections for a design report.
class ReportData {
  final String title;
  final String projectName;
  final DateTime date;
  final List<CalculationSection> sections;

  ReportData({
    required this.title,
    required this.projectName,
    required this.date,
    required this.sections,
  });
}



