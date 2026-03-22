
import 'package:site_buddy/features/report/domain/report_model.dart';
import 'package:site_buddy/features/report/domain/report_section.dart';
import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';

/// BUILDER: StructuralReportBuilder
/// PURPOSE: Maps Structural Design reports (Beam, Slab, Footing) to an EngineeringReport.
class StructuralReportBuilder {
  
  static EngineeringReport build(DesignReport report, {required String projectTitle, required String engineerName, required bool isPro}) {
    return EngineeringReport(
      id: report.id,
      title: "${report.typeLabel} Design Report",
      projectTitle: projectTitle,
      engineerName: engineerName,
      date: report.timestamp,
      codeReference: "IS 456:2000",
      isPro: isPro,
      sections: [
        ReportSection(
          title: "Input Parameters",
          content: report.inputs.map((k, v) => MapEntry(k, v.toString())),
        ),
        ReportSection(
          title: "Technical Results",
          content: report.results.map((k, v) => MapEntry(k, v.toString())),
          steps: isPro ? [
            "Calculate effective span and factored loads.",
            "Determine required depth/area based on Limit State Method.",
            "Verify shear and deflection criteria as per IS 456.",
            "Finalize reinforcement detailing."
          ] : null,
          isProOnly: false,
        ),
        ReportSection(
          title: "Design Summary",
          content: {
            "Status": report.isSafe ? "SAFE" : "RE-DESIGN REQUIRED",
            "Summary": report.summary,
          },
        ),
      ],
    );
  }
}
