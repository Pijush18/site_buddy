import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/brick_estimator/domain/models/brick_estimator_result.dart';

/// MAPPER: BrickEstimatorMapper
class BrickEstimatorMapper {
  static DesignReport toDesignReport(
    BrickEstimatorResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.brick,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Brick Wall: ${result.numberOfBricks.toInt()} bricks, ${result.mortarVolume.toStringAsFixed(2)}m³ mortar',
      projectId: projectId,
    );
  }
}
