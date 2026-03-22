import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_calculation_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_history_repository.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

/// Provide the unified history repository.
final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HiveHistoryRepository(),
);

/// Provide a feed of the latest 5 design reports.
final recentReportsProvider = FutureProvider<List<DesignReport>>((ref) async {
  final repo = ref.watch(historyRepositoryProvider);
  final reports = repo.getAll();
  return reports.take(5).toList();
});

/// Legacy provider for broader calculation history (Calculators/Logs).
final sharedHistoryRepositoryProvider = Provider<CalculationRepository>(
  (ref) {
    final backend = ref.watch(backendClientProvider);
    final connectivity = ref.watch(connectivityServiceProvider);
    return HiveCalculationRepository(
      backendClient: backend,
      connectivityService: connectivity,
    );
  },
);
