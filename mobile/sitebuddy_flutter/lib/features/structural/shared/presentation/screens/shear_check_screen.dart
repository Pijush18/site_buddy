import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/structural/shared/application/controllers/shear_check_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/shear_input_section.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/shear_result_summary.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/shear_history_section.dart';

/// SCREEN: ShearCheckScreen
/// 
/// [REFACTORED] - This screen is now purely declarative.
/// All business logic has been moved to ShearCheckNotifier.
/// 
/// VIOLATIONS FIXED:
/// - ✅ Removed setState for loading state (now in Notifier)
/// - ✅ Removed setState for result (now in Notifier)
/// - ✅ Removed direct CalculationService call (now in Notifier)
/// - ✅ Removed manual form validation logic (now in Notifier)
/// - ✅ UI is now purely declarative, watching state from Notifier
class ShearCheckScreen extends ConsumerWidget {
  const ShearCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state from Notifier - UI reacts automatically
    final state = ref.watch(shearCheckControllerProvider);
    final notifier = ref.read(shearCheckControllerProvider.notifier);

    return SbPage.form(
      title: 'Shear Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Calculate',
            onPressed: state.isLoading
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    notifier.calculate();
                  },
            isLoading: state.isLoading,
          ),
          if (state.result != null) ...[
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Report',
              onPressed: notifier.shareResult,
            ),
            const SizedBox(height: SbSpacing.sm),
            GhostButton(
              label: 'Reset',
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
              'Assessment',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── INPUTS ──
          SbSection(
            title: 'Input Parameters',
            child: ShearInputSection(
              dController: _createTextController(state.depth, notifier.updateDepth),
              bController: _createTextController(state.width, notifier.updateWidth),
              vuController: _createTextController(state.shearForce, notifier.updateShearForce),
              ptController: _createTextController(state.steelPercentage, notifier.updateSteelPercentage),
              selectedConcrete: state.selectedConcrete,
              selectedSteel: state.selectedSteel,
              onConcreteChanged: (v) {
                if (v != null) notifier.updateConcreteGrade(v);
              },
              onSteelChanged: (v) {
                if (v != null) notifier.updateSteelGrade(v);
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.error!,
                  style: TextStyle(
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
              child: ShearResultSummary(result: state.result!),
            ),
            SbSection(
              title: 'Engineering Insight',
              child: InsightCard(insights: state.result!.insights),
            ),
          ] else
            const SbSection(
              title: 'Design Status',
              child: _PlaceholderCard(
                icon: SbIcons.analytics,
                message: 'Enter parameters to generate report',
              ),
            ),

          // ── HISTORY ──
          const SbSection(
            title: 'Recent Checks',
            child: ShearHistorySection(),
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
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
