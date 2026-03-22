import 'package:site_buddy/shared/domain/models/design/design_report.dart';
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
      type: DesignType.currencyConverter,
      inputs: inputs,
      results: result.toMap(),
      summary: 'Currency: ${inputs['amount']} ${inputs['from']} = ${result.amount.toStringAsFixed(2)} ${result.currency}',
      projectId: projectId,
    );
  }
}
