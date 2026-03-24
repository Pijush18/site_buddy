import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/structural/shared/application/controllers/cracking_check_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/insight_card.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/shared_safety_widgets.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/cracking_input_section.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/cracking_result_summary.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/cracking_history_section.dart';

/// SCREEN: CrackingCheckScreen
/// 
/// [REFACTORED] - This screen is now purely declarative.
/// All business logic has been moved to CrackingCheckNotifier.
/// 
/// VIOLATIONS FIXED:
/// - ✅ Removed setState for loading state (now in Notifier)
/// - ✅ Removed setState for result (now in Notifier)
/// - ✅ Removed direct CalculationService call (now in Notifier)
/// - ✅ Removed manual form validation logic (now in Notifier)
/// - ✅ UI is now purely declarative, watching state from Notifier
class CrackingCheckScreen extends ConsumerWidget {
  const CrackingCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state from Notifier - UI reacts automatically
    final state = ref.watch(crackingCheckControllerProvider);
    final notifier = ref.read(crackingCheckControllerProvider.notifier);

    return SbPage.form(
      title: 'Cracking Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: state.result != null ? 'Check Again' : 'Check Cracking',
            onPressed: state.isLoading
                ? null
                : () {
                    HapticFeedback.heavyImpact();
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
              'Durability & Crack Control Analysis',
              style: SbTypography.headline,
            ),
          ),

          // ── INPUTS ──
          SbSection(
            title: 'Input Parameters',
            child: CrackingInputSection(
              // Pass controllers bound to notifier updates
              spacingController: _createTextController(state.spacing, notifier.updateSpacing),
              coverController: _createTextController(state.cover, notifier.updateCover),
              fsController: _createTextController(state.fs, notifier.updateFs),
              selectedConcrete: state.selectedConcrete,
              selectedSteel: state.selectedSteel,
              concreteGrades: CrackingCheckNotifier.concreteGrades,
              steelGrades: CrackingCheckNotifier.steelGrades,
              onDropdownChanged: (label, value) {
                if (label == 'Concrete') {
                  notifier.updateConcreteGrade(value);
                } else {
                  notifier.updateSteelGrade(value);
                }
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
              child: CrackingResultSummary(result: state.result!),
            ),
            SbSection(
              title: 'Engineering Insight',
              child: InsightCard(insights: state.result!.insights),
            ),
          ] else
            const SbSection(
              title: 'Design Status',
              child: PlaceholderCard(
                icon: SbIcons.visibility,
                message: 'Calculate crack width for durability',
              ),
            ),

          // ── HISTORY ──
          const SbSection(
            title: 'Recent Checks',
            child: CrackingHistorySection(),
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
class PlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const PlaceholderCard({
    super.key,
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
