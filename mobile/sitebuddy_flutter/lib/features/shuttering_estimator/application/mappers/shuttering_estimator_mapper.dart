import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/shuttering_estimator/domain/models/shuttering_estimator_result.dart';

/// MAPPER: ShutteringEstimatorMapper
class ShutteringEstimatorMapper {
  static DesignReport toDesignReport(
    ShutteringEstimatorResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.shuttering,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Shuttering Area: ${result.area.toStringAsFixed(2)}m²',
      projectId: projectId,
    );
  }
}

