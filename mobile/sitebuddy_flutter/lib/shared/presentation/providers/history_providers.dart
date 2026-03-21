import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_calculation_repository.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

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



