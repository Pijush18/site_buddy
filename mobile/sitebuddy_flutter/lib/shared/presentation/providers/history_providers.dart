import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_history_repository.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

final sharedHistoryRepositoryProvider = Provider<HistoryRepository>(
  (ref) {
    final backend = ref.watch(backendClientProvider);
    final connectivity = ref.watch(connectivityServiceProvider);
    return HiveHistoryRepository(
      backendClient: backend,
      connectivityService: connectivity,
    );
  },
);
