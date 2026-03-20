import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';

class AddHistoryEntryUseCase {
  final HistoryRepository repository;

  AddHistoryEntryUseCase(this.repository);

  Future<void> execute(CalculationHistoryEntry entry) {
    return repository.addEntry(entry);
  }
}



