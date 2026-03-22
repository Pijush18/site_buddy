import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';

class AddHistoryEntryUseCase {
  final HistoryRepository repository;

  AddHistoryEntryUseCase(this.repository);

  Future<void> execute(CalculationHistoryEntry entry) {
    // Audit Fix: Use the mapper to convert legacy entries to the unified report format.
    final report = DesignReportMapper.fromHistoryEntry(entry);
    return repository.save(report);
  }
}




