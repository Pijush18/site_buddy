import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/rebar_controller.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

/// SCREEN: RebarScreen
/// PURPOSE: Estimate steel rebar quantity, length, and weight based on spacing and member dimensions.
class RebarScreen extends ConsumerWidget {
  const RebarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(rebarControllerProvider);
    final controller = ref.read(rebarControllerProvider.notifier);

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is SteelWeightPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });
    final colorScheme = theme.colorScheme;

    final lError = state.failure?.message.toLowerCase().contains('length') == true ? state.failure?.message : null;
    final sError = state.failure?.message.toLowerCase().contains('spacing') == true ? state.failure?.message : null;
    final dError = state.failure?.message.toLowerCase().contains('diameter') == true ? state.failure?.message : null;

    Widget buildResultCard() {
      final res = state.result!;
      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'RESULT SUMMARY',
              style: SbTextStyles.title(context).copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap16,
            const Divider(),
            SbListItem(
              title: 'Number of Bars',
              trailing: Text(
                res.numberOfBars.toStringAsFixed(0),
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            SbListItem(
              title: 'Total Length',
              trailing: Text(
                '${res.totalLength.toStringAsFixed(2)} m',
                style: SbTextStyles.body(context),
              ),
            ),
            SbListItem(
              title: 'Total Weight',
              trailing: Text(
                '${res.totalWeight.toStringAsFixed(2)} kg',
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final bool isValid = state.memberLength != null && state.spacing != null && state.diameter != null;

    return SbPage.detail(
      title: 'Rebar Estimator',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'STRUCTURAL REBAR REQUIREMENTS',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap8,

          AppNumberField(
            label: 'Member Length (m)',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateMemberLength,
            errorText: lError,
          ),
          AppLayout.vGap8,

          AppNumberField(
            label: 'Spacing (m)',
            suffixIcon: SbIcons.spacing,
            onChanged: controller.updateSpacing,
            errorText: sError,
          ),
          AppLayout.vGap8,

          Wrap(
            spacing: AppLayout.md,
            runSpacing: AppLayout.md,
            children: [
              SizedBox(
                width: 160,
                child: AppNumberField(
                  label: 'Diameter (mm)',
                  suffixIcon: SbIcons.diameter,
                  onChanged: controller.updateDiameter,
                  errorText: dError,
                ),
              ),
              SizedBox(
                width: 160,
                child: AppNumberField(
                  label: 'Waste (%)',
                  suffixIcon: SbIcons.percent,
                  onChanged: controller.updateWaste,
                ),
              ),
            ],
          ),

          AppLayout.vGap24,

          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: 'Clear All',
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? 'Calculating...' : 'Calculate',
                icon: state.isLoading ? null : SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          AppLayout.vGap24,

          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AppLayout.vGap24,
          ],

          if (state.result != null) ...[buildResultCard(), AppLayout.vGap24],
        ],
      ),
    );
  }
}
