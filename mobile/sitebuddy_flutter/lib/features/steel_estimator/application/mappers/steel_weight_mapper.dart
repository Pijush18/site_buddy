import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/steel_estimator/domain/models/steel_weight_result.dart';

/// MAPPER: SteelWeightMapper
class SteelWeightMapper {
  static DesignReport toDesignReport(
    SteelWeightResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.steel,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Steel Weight: ${result.weight.toStringAsFixed(2)} kg (${inputs['diameter']}mm @ ${inputs['length']}m)',
      projectId: projectId,
    );
  }
}


