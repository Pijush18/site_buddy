import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/level_calculator/domain/models/level_calculator_result.dart';

/// MAPPER: LevelCalculatorMapper
/// PURPOSE: Converts Level Calculator results to DesignReports.
class LevelCalculatorMapper {
  static DesignReport toDesignReport(
    LevelCalculatorResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.levelLog,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Leveling: RL ${result.reducedLevel.toStringAsFixed(3)} m (${result.isRise ? 'Rise' : 'Fall'})',
      projectId: projectId,
    );
  }
}
