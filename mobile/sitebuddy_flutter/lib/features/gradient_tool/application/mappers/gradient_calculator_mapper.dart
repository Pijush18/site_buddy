import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/gradient_tool/domain/models/gradient_calculator_result.dart';

/// MAPPER: GradientCalculatorMapper
/// PURPOSE: Converts Gradient results to DesignReports.
class GradientCalculatorMapper {
  static DesignReport toDesignReport(
    GradientCalculatorResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.siteGradient,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Gradient: ${result.slopePercent.toStringAsFixed(1)}% (${result.ratio})',
      projectId: projectId,
    );
  }
}


