import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/reports/application/generate_site_report_usecase.dart';

final generateSiteReportUseCaseProvider = Provider<GenerateSiteReportUseCase>((
  ref,
) {
  return const GenerateSiteReportUseCase();
});
