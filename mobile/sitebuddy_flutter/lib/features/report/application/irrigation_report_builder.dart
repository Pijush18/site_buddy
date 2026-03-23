
import 'package:site_buddy/features/report/domain/report_model.dart';
import 'package:site_buddy/features/report/domain/report_section.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_result.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_input.dart';

/// BUILDER: IrrigationReportBuilder
/// PURPOSE: Maps Canal Design results to an EngineeringReport.
/// 
/// APPLICATION LAYER: Receives Pro status as parameter (not from domain model).
/// The domain model is pure; policy decisions are made at this layer.
class IrrigationReportBuilder {
  
  static EngineeringReport build(
    CanalResult result, 
    CanalInput input, {
    required String projectTitle, 
    required String engineerName,
    required bool isPro,
  }) {
    return EngineeringReport(
      id: "IRRI-${DateTime.now().millisecondsSinceEpoch}",
      title: "Irrigation Canal Design Report",
      projectTitle: projectTitle,
      engineerName: engineerName,
      date: DateTime.now(),
      codeReference: "Manning's Method | IS:10430",
      isPro: isPro,
      sections: [
        ReportSection(
          title: "Canal Geometry",
          content: {
            "Shape": input.shape.name.toUpperCase(),
            "Bed Width (b)": "${input.bedWidth} m",
            "Flow Depth (y)": "${input.flowDepth} m",
            "Side Slope (z:1)": "${input.sideSlope}",
            "Bed Slope (S)": "${input.longitudinalSlope}",
            "Material": input.material,
          },
        ),
        ReportSection(
          title: "Hydraulic Results",
          content: {
            "Discharge (Q)": "${result.discharge.toStringAsFixed(3)} m³/s",
            "Mean Velocity (V)": "${result.velocity.toStringAsFixed(3)} m/s",
            "Hydraulic Radius (R)": "${result.hydraulicRadius.toStringAsFixed(3)} m",
            "Section Efficiency": "${result.efficiency.toStringAsFixed(1)}%",
          },
          steps: isPro ? [
            "Compute Area (A) and Wetted Perimeter (P).",
            "Compute Hydraulic Radius (R = A/P).",
            "Apply Manning's Equation: Q = (1/n) * A * R^(2/3) * S^(1/2).",
            "Check for Silting & Scouring velocity limits."
          ] : null,
          isProOnly: false,
        ),
        ReportSection(
          title: "Safety Evaluation",
          content: {
            "Safety Classification": result.safetyNote,
          },
        ),
      ],
    );
  }
}
