import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/currency/domain/models/currency_converter_result.dart';

/// MAPPER: CurrencyConverterMapper
class CurrencyConverterMapper {
  static DesignReport toDesignReport(
    CurrencyConverterResult result,
    Map<String, dynamic> inputs,
    String projectId,
  ) {
    return DesignReportMapper.fromGenericCalculator(
      type: DesignType.currency,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Currency: ${inputs['amount']} ${inputs['from']} = ${result.amount.toStringAsFixed(2)} ${result.currency}',
      projectId: projectId,
    );
  }
}


