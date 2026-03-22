import 'package:site_buddy/core/logging/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/features/structural/beam/application/beam_design_controller.dart';

/// STATE: BeamSafetyState
class BeamSafetyState {
  final OptimizationOption? selectedOption;
  final bool hasSaved;

  const BeamSafetyState({
    this.selectedOption,
    this.hasSaved = false,
  });

  BeamSafetyState copyWith({
    OptimizationOption? selectedOption,
    bool? hasSaved,
  }) {
    return BeamSafetyState(
      selectedOption: selectedOption ?? this.selectedOption,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}

/// CONTROLLER: BeamSafetyController
/// Handles automated saving of selected beam design variants.
class BeamSafetyController extends AutoDisposeNotifier<BeamSafetyState> {
  @override
  BeamSafetyState build() {
    return const BeamSafetyState();
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
      AppLogger.warning('No active project — skipping save', tag: 'BeamSafety');
      return;
    }

    final beamState = ref.read(beamDesignControllerProvider);

    try {
      final report = DesignReportMapper.fromSafetyCheck(
        type: DesignType.beam,
        option: option.toMap(),
        params: {
          'span': beamState.span,
          'width': beamState.width,
          'overallDepth': beamState.overallDepth,
          'concrete': beamState.concreteGrade,
          'steel': beamState.steelGrade,
          'mu': beamState.mu,
          'vu': beamState.vu,
        },
        projectId: project.id,
      );

      await HistorySaver.save(
        ref: ref,
        report: report,
      );

      state = state.copyWith(hasSaved: true);
      AppLogger.info('Beam safety selection saved', tag: 'BeamSafety');
    } catch (e, st) {
      AppLogger.error('Save failed', tag: 'BeamSafety', error: e, stackTrace: st);
    }
  }
}

final beamSafetyControllerProvider =
    AutoDisposeNotifierProvider<BeamSafetyController, BeamSafetyState>(() {
  return BeamSafetyController();
});


