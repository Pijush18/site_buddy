import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

/// SERVICE: HistorySaver
/// PURPOSE: Unified utility for saving calculation results to the design report history.
class HistorySaver {
  /// Saves a [DesignReport] to the history repository and invalidates related providers.
  /// This ensures that the UI reflects the latest history,
  /// which was causing inconsistent history when switching projects.
  static Future<void> save({
    required Ref ref,
    required DesignReport report,
  }) async {
    await ref.read(historyRepositoryProvider).save(report);
    
    // Invalidate history providers to trigger UI refresh across the app
    ref.invalidate(recentReportsProvider);
    ref.invalidate(projectHistoryProvider);
  }
}
