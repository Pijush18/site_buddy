import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';

/// STATE: ColumnSafetyState
class ColumnSafetyState {
  final OptimizationOption? selectedOption;
  final bool hasSaved;

  const ColumnSafetyState({
    this.selectedOption,
    this.hasSaved = false,
  });

  ColumnSafetyState copyWith({
    OptimizationOption? selectedOption,
    bool? hasSaved,
  }) {
    return ColumnSafetyState(
      selectedOption: selectedOption ?? this.selectedOption,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}

/// CONTROLLER: ColumnSafetyController
/// Handles automated saving of selected column design variants.
class ColumnSafetyController extends AutoDisposeNotifier<ColumnSafetyState> {
  @override
  ColumnSafetyState build() {
    return const ColumnSafetyState();
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

    final columnState = ref.read(columnDesignControllerProvider);

    try {
      final report = DesignReportMapper.fromSafetyCheck(
        type: DesignType.column,
        option: option.toMap(),
        params: {
          'width_b': columnState.b,
          'depth_d': columnState.d,
          'length': columnState.length,
          'concrete': columnState.concreteGrade,
          'steel': columnState.steelGrade,
          'load_pu': columnState.pu,
          'moment_mx': columnState.mx,
          'moment_my': columnState.my,
        },
        projectId: project.id,
      );

      await HistorySaver.save(
        ref: ref,
        report: report,
      );

      state = state.copyWith(hasSaved: true);
      debugPrint("✅ Column safety selection saved");
    } catch (e, st) {
      debugPrint("❌ Save failed: $e");
      debugPrintStack(stackTrace: st);
    }
  }
}

final columnSafetyControllerProvider =
    AutoDisposeNotifierProvider<ColumnSafetyController, ColumnSafetyState>(() {
  return ColumnSafetyController();
});
