import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_log_session.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_method.dart';
import 'package:site_buddy/features/level_log/domain/usecases/level_calculation_service.dart';
import 'package:site_buddy/features/level_log/domain/usecases/level_log_report_service.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/features/level_log/application/services/level_history_service.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/features/level_log/presentation/providers/level_log_providers.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

class LevelLogState {
  final List<LevelEntry> entries;
  final List<double?> slopes;
  final LevelMethod method;
  final String? projectId;

  LevelLogState({
    required this.entries,
    required this.slopes,
    required this.method,
    this.projectId,
  });

  LevelLogState copyWith({
    List<LevelEntry>? entries,
    List<double?>? slopes,
    LevelMethod? method,
    String? projectId,
  }) {
    return LevelLogState(
      entries: entries ?? this.entries,
      slopes: slopes ?? this.slopes,
      method: method ?? this.method,
      projectId: projectId ?? this.projectId,
    );
  }
}

class LevelLogController extends StateNotifier<LevelLogState> {
  final LevelCalculationService _calculationService;
  final Ref _ref;

  // FIX: No external projectId parameter - get from session only
  LevelLogController(this._calculationService, this._ref)
    : super(
        LevelLogState(
          entries: [
            const LevelEntry(
              station: 'BM 1',
              chainage: 0,
              rl: 100.0,
              remark: 'Initial Bench Mark',
            ),
            const LevelEntry(station: 'STN 1', chainage: 20),
          ],
          slopes: [null, null],
          method: LevelMethod.heightOfInstrument,
        ),
      ) {
    _initProject();
    recalculate();
  }

  void _initProject() {
    // FIX: Get projectId from session ONLY - throws if no active project
    // No external projectId allowed - session is the only source
    final projectId = _ref
        .read(projectSessionServiceProvider)
        .getActiveProjectId();
    state = state.copyWith(projectId: projectId);
  }

  void addEntry() {
    final newStation = 'STN ${state.entries.length}';
    state = state.copyWith(
      entries: [
        ...state.entries,
        LevelEntry(station: newStation, projectId: state.projectId),
      ],
    );
    recalculate();
  }

  void removeEntry(int index) {
    if (state.entries.length <= 1) return;
    final newEntries = List<LevelEntry>.from(state.entries)..removeAt(index);
    state = state.copyWith(entries: newEntries);
    recalculate();
  }

  void updateEntry(int index, LevelEntry updatedEntry) {
    final newEntries = List<LevelEntry>.from(state.entries);
    newEntries[index] = updatedEntry.copyWith(projectId: state.projectId);
    state = state.copyWith(entries: newEntries);
    recalculate();
  }

  void updateChainage(int index, String value) {
    final parsed = _calculationService.parseChainage(value);
    final newEntries = List<LevelEntry>.from(state.entries);
    newEntries[index] = newEntries[index].copyWith(chainage: parsed);
    state = state.copyWith(entries: newEntries);
    recalculate();
  }

  void setMethod(LevelMethod method) {
    state = state.copyWith(method: method);
    recalculate();
  }

  void recalculate() {
    List<LevelEntry> calculated;
    if (state.method == LevelMethod.heightOfInstrument) {
      calculated = _calculationService.calculateHISeries(state.entries);
    } else if (state.method == LevelMethod.riseFall) {
      calculated = _calculationService.calculateRiseFallSeries(state.entries);
    } else {
      calculated = state.entries;
    }
    state = state.copyWith(
      entries: calculated,
      slopes: _calculationService.calculateSlopes(calculated),
    );
  }

  Future<void> saveCurrentSession(String name) async {
    if (state.projectId == null) return;
    final repo = _ref.read(levelLogRepositoryProvider);

    final session = LevelLogSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      projectId: state.projectId,
      date: DateTime.now(),
      method: state.method,
      entries: state.entries,
    );

    await repo.saveSession(session);

    // FIX: Get fresh projectId from session at save time - not from cached state
    // This ensures we use the correct project even if active project changed
    final projectId = _ref
        .read(projectSessionServiceProvider)
        .getActiveProjectId();

    // Record calculation history
    final historyRepo = _ref.read(sharedHistoryRepositoryProvider);
    final entry = CalculationHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: projectId,
      calculationType: CalculationType.levelLog,
      timestamp: DateTime.now(),
      inputParameters: {
        'method': state.method.index,
        'entryCount': state.entries.length,
      },
      resultSummary:
          "Level log session saved: $name (${state.entries.length} points)",
    );
    await historyRepo.addEntry(entry);
  }

  Future<void> exportReport() async {
    final closure = _calculationService.verifyLevelClosure(state.entries);
    await LevelLogReportService.generateAndShareReport(
      entries: state.entries,
      slopes: state.slopes,
      method: state.method,
      closure: closure,
      projectName: 'SiteBuddy Survey',
    );
  }
}

final levelCalculationServiceProvider = Provider(
  (ref) => LevelCalculationService(),
);

final levelHistoryServiceProvider = Provider((ref) => LevelHistoryService());

// FIX: Use family provider to accept optional projectId from route
// If projectId is null, controller will get from session (throws if no session)
// FIX: Remove family provider - projectId comes from session only
final levelLogControllerProvider =
    StateNotifierProvider<LevelLogController, LevelLogState>((ref) {
      final service = ref.watch(levelCalculationServiceProvider);
      return LevelLogController(service, ref);
    });
