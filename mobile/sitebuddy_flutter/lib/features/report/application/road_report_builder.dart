
import 'package:site_buddy/features/report/domain/report_model.dart';
import 'package:site_buddy/features/report/domain/report_section.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_design_result.dart';

/// BUILDER: RoadReportBuilder
/// PURPOSE: Maps Road Pavement Design results to an EngineeringReport.
/// 
/// APPLICATION LAYER: Receives Pro status as parameter (not from domain model).
/// The domain model is pure; policy decisions are made at this layer.
class RoadReportBuilder {
  
  static EngineeringReport build(
    PavementDesignResult result, {
    required String projectTitle, 
    required String engineerName,
    required bool isPro,
  }) {
    return EngineeringReport(
      id: "ROAD-${DateTime.now().millisecondsSinceEpoch}",
      title: "Flexible Pavement Design Report",
      projectTitle: projectTitle,
      engineerName: engineerName,
      date: DateTime.now(),
      codeReference: "IRC:37-2018",
      isPro: isPro,
      sections: [
        ReportSection(
          title: "Input Parameters",
          content: {
            "Subgrade CBR": "${result.cbrProvided}%",
            "Cumulative Traffic (MSA)": "${result.msaDesign} msa",
          },
        ),
        ReportSection(
          title: "Design Composition",
          content: Map.fromEntries(result.layers.map((l) => MapEntry(l.name, "${l.thickness.toStringAsFixed(0)} mm"))),
          steps: isPro ? [
            "Calculate Total Thickness (H) using Fig 12.1 interpolation.",
            "Distribute thickness based on MSA thresholds (BC, DBM, WMM, GSB).",
            "Verify minimum crust requirements as per IRC 37."
          ] : null,
          isProOnly: false,
        ),
        ReportSection(
          title: "Technical Summary",
          content: {
            "Total Thickness": "${result.totalThickness.toStringAsFixed(0)} mm",
            "Safety Classification": result.safetyClassification,
          },
        ),
      ],
    );
  }
}
