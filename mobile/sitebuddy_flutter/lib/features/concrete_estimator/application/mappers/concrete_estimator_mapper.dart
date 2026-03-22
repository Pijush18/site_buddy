import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/concrete_estimator/domain/models/concrete_estimator_result.dart';

/// MAPPER: ConcreteEstimatorMapper
class ConcreteEstimatorMapper {
  static DesignReport toDesignReport(
    ConcreteEstimatorResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.cement, // Reusing cement type for concrete estimation
      inputs: inputs,
      results: result.toMap(),
      summary: 'Concrete: ${result.cementBags.toStringAsFixed(1)} bags, ${result.sandVolume.toStringAsFixed(2)}m³ sand, ${result.aggregateVolume.toStringAsFixed(2)}m³ agg.',
      projectId: projectId,
    );
  }
}
