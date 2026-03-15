import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/reports/application/generate_site_report_usecase.dart';
import 'package:site_buddy/features/reports/domain/repositories/report_repository.dart';
import 'package:site_buddy/features/reports/data/repositories/report_repository_impl.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

final generateSiteReportUseCaseProvider = Provider<GenerateSiteReportUseCase>((
  ref,
) {
  return const GenerateSiteReportUseCase();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final backend = ref.watch(backendClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  return ReportRepositoryImpl(
    backendClient: backend,
    connectivityService: connectivity,
  );
});
