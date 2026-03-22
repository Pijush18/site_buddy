import 'package:site_buddy/core/logging/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';

/// STATE: SlabSafetyState
class SlabSafetyState {
  final OptimizationOption? selectedOption;
  final bool hasSaved;

  const SlabSafetyState({
    this.selectedOption,
    this.hasSaved = false,
  });

  SlabSafetyState copyWith({
    OptimizationOption? selectedOption,
    bool? hasSaved,
  }) {
    return SlabSafetyState(
      selectedOption: selectedOption ?? this.selectedOption,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}

/// CONTROLLER: SlabSafetyController
/// Handles automated saving of selected slab design variants.
class SlabSafetyController extends AutoDisposeNotifier<SlabSafetyState> {
  @override
  SlabSafetyState build() {
    return const SlabSafetyState();
  }

  Future<void> selectOption(OptimizationOption option) async {
    // Prevent duplicate selection
    if (state.selectedOption == option) return;

    // Update UI state
    state = state.copyWith(
      selectedOption: option,
      hasSaved: false,
    );

    // Save immediately
    await _saveSelection(option);
  }

  Future<void> _saveSelection(OptimizationOption option) async {
    if (state.hasSaved) return;

    final project = ref.read(activeProjectProvider);
    if (project == null) {
      AppLogger.warning('No active project — skipping save', tag: 'SlabSafety');
      return;
    }

    final slabState = ref.read(slabDesignControllerProvider);

    try {
      final report = DesignReportMapper.fromSafetyCheck(
        type: DesignType.slab,
        option: option.toMap(),
        params: {
          'lx': slabState.lx,
          'ly': slabState.ly,
          'D': slabState.d,
          'concrete': slabState.concreteGrade,
          'steel': slabState.steelGrade,
        },
        projectId: project.id,
      );

      await HistorySaver.save(
        ref: ref,
        report: report,
      );

      state = state.copyWith(hasSaved: true);
      AppLogger.info('Slab safety selection saved', tag: 'SlabSafety');
    } catch (e, st) {
      AppLogger.error('Save failed', tag: 'SlabSafety', error: e, stackTrace: st);
    }
  }
}

final slabSafetyControllerProvider =
    AutoDisposeNotifierProvider<SlabSafetyController, SlabSafetyState>(() {
  return SlabSafetyController();
});
