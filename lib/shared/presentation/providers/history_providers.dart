import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_history_repository.dart';

final sharedHistoryRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HiveHistoryRepository(),
);
