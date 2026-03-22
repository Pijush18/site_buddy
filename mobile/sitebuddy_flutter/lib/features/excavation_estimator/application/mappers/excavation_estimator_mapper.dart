import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/excavation_estimator/domain/models/excavation_estimator_result.dart';

/// MAPPER: ExcavationEstimatorMapper
class ExcavationEstimatorMapper {
  static DesignReport toDesignReport(
    ExcavationEstimatorResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.excavation,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Excavation: ${result.volume.toStringAsFixed(2)}m³ net volume',
      projectId: projectId,
    );
  }
}

