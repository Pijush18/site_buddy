import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/unit_converter/domain/models/unit_converter_result.dart';

/// MAPPER: UnitConverterMapper
class UnitConverterMapper {
  static DesignReport toDesignReport(
    UnitConverterResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.currency,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Unit Conversion: ${inputs['value']} ${inputs['from']} = ${result.value.toStringAsFixed(4)} ${result.unit}',
      projectId: projectId,
    );
  }
}


