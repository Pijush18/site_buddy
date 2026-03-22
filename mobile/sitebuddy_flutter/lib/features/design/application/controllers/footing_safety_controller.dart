import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';

/// STATE: FootingSafetyState
class FootingSafetyState {
  final OptimizationOption? selectedOption;
  final bool hasSaved;

  const FootingSafetyState({
    this.selectedOption,
    this.hasSaved = false,
  });

  FootingSafetyState copyWith({
    OptimizationOption? selectedOption,
    bool? hasSaved,
  }) {
    return FootingSafetyState(
      selectedOption: selectedOption ?? this.selectedOption,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}

/// CONTROLLER: FootingSafetyController
/// Handles automated saving of selected footing design variants.
class FootingSafetyController extends AutoDisposeNotifier<FootingSafetyState> {
  @override
  FootingSafetyState build() {
    return const FootingSafetyState();
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
      debugPrint("❌ No active project — skipping save");
      return;
    }

    final footingState = ref.read(footingDesignControllerProvider);

    try {
      final report = DesignReportMapper.fromSafetyCheck(
        type: DesignType.footing,
        option: option.toMap(),
        params: {
          'length': footingState.footingLength,
          'width': footingState.footingWidth,
          'thickness': footingState.footingThickness,
          'sbc': footingState.sbc,
          'load': footingState.columnLoad,
          'concrete': footingState.concreteGrade,
          'steel': footingState.steelGrade,
        },
        projectId: project.id,
      );

      await HistorySaver.save(
        ref: ref,
        report: report,
      );

      state = state.copyWith(hasSaved: true);
      debugPrint("✅ Footing safety selection saved");
    } catch (e, st) {
      debugPrint("❌ Save failed: $e");
      debugPrintStack(stackTrace: st);
    }
  }
}

final footingSafetyControllerProvider =
    AutoDisposeNotifierProvider<FootingSafetyController, FootingSafetyState>(() {
  return FootingSafetyController();
});
