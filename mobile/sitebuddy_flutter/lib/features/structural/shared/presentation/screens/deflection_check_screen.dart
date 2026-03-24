import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/structural/shared/application/controllers/deflection_check_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/deflection_input_section.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/deflection_result_summary.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/deflection_history_section.dart';

/// SCREEN: DeflectionCheckScreen
/// 
/// [REFACTORED] - This screen is now purely declarative.
/// All business logic has been moved to DeflectionCheckNotifier.
/// 
/// VIOLATIONS FIXED:
/// - ✅ Removed setState for loading state (now in Notifier)
/// - ✅ Removed setState for result (now in Notifier)
/// - ✅ Removed direct CalculationService call (now in Notifier)
/// - ✅ Removed manual form validation logic (now in Notifier)
/// - ✅ UI is now purely declarative, watching state from Notifier
class DeflectionCheckScreen extends ConsumerWidget {
  const DeflectionCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state from Notifier - UI reacts automatically
    final state = ref.watch(deflectionCheckControllerProvider);
    final notifier = ref.read(deflectionCheckControllerProvider.notifier);

    return SbPage.form(
      title: 'Deflection Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: state.result != null ? 'Check Again' : 'Check Deflection',
            onPressed: state.isLoading
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    notifier.calculate();
                  },
            isLoading: state.isLoading,
          ),
          if (state.result != null) ...[
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Share Report',
              onPressed: notifier.shareResult,
            ),
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Reset Form',
              onPressed: notifier.reset,
            ),
          ],
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── HEADER ──
          SbSection(
            child: Text(
              'Span-to-Depth Ratio Analysis',
              style: SbTypography.headline,
            ),
          ),

          // ── INPUTS ──
          SbSection(
            title: 'Input Parameters',
            child: DeflectionInputSection(
              dController: _createTextController(state.depth, notifier.updateDepth),
              spanController: _createTextController(state.span, notifier.updateSpan),
              ptController: _createTextController(state.pt, notifier.updatePt),
              pcController: _createTextController(state.pc, notifier.updatePc),
              selectedSpanType: state.selectedSpanType,
              onSpanTypeChanged: (v) {
                if (v != null) notifier.updateSpanType(v);
              },
            ),
          ),

          // ── ERROR MESSAGE ──
          if (state.error != null)
            SbSection(
              child: Container(
                padding: const EdgeInsets.all(SbSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(SbRadius.standard),
                ),
                child: Text(
                  state.error!,
                  style: SbTypography.body.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),

          // ── RESULTS ──
          if (state.result != null) ...[
            SbSection(
              title: 'Design Status',
              trailing: StatusBadge(isSafe: state.result!.isSafe),
              child: DeflectionResultSummary(result: state.result!),
            ),
            SbSection(
              title: 'Engineering Insight',
              child: InsightCard(insights: state.result!.insights),
            ),
          ] else
            const SbSection(
              title: 'Design Status',
              child: _PlaceholderCard(
                icon: Icons.query_stats,
                message: 'Calculate ratio to check safety',
              ),
            ),

          // ── HISTORY ──
          const SbSection(
            title: 'Recent Checks',
            child: DeflectionHistorySection(),
          ),
        ],
      ),
    );
  }

  /// Creates a TextEditingController that syncs with the provider state
  TextEditingController _createTextController(
    String initialValue,
    void Function(String) onChanged,
  ) {
    final controller = TextEditingController(text: initialValue);
    
    // Listen to controller changes and update Notifier
    controller.addListener(() {
      if (controller.text != initialValue) {
        onChanged(controller.text);
      }
    });
    
    return controller;
  }
}

/// PLACEHOLDER CARD: Used when no calculation has been performed yet
class _PlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _PlaceholderCard({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SbSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: SbSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: SbTypography.body.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
