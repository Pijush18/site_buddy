import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
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
    final colorScheme = theme.colorScheme;

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is SteelWeightPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

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
              EngineeringTerms.resultSummary,
              style: AppTextStyles.sectionTitle(context).copyWith(
                color: colorScheme.primary,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            const Divider(),
            SbListItemTile(
              title: EngineeringTerms.numberOfBars,
              onTap: () {}, // Detail view entry
              trailing: Text(
                res.numberOfBars.toStringAsFixed(0),
                style: AppTextStyles.cardTitle(context).copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.totalLength,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.totalLength.toStringAsFixed(2)} m',
                style: AppTextStyles.body(context),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.totalWeight,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.totalWeight.toStringAsFixed(2)} kg',
                style: AppTextStyles.cardTitle(context).copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final bool isValid = state.memberLength != null && state.spacing != null && state.diameter != null;

    return AppScreenWrapper(
      title: AppStrings.steelWeightEstimatorTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.rebarRequirements,
            style: AppTextStyles.sectionTitle(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8

          AppNumberField(
            label: EngineeringTerms.memberLength,
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateMemberLength,
            errorText: lError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8

          AppNumberField(
            label: EngineeringTerms.spacingLabel,
            suffixIcon: SbIcons.spacing,
            onChanged: controller.updateSpacing,
            errorText: sError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8

          Wrap(
            spacing: AppSpacing.md, // Replaced AppLayout.md
            runSpacing: AppSpacing.md, // Replaced AppLayout.md
            children: [
              SizedBox(
                width: 160,
                child: AppNumberField(
                  label: EngineeringTerms.diameterLabel,
                  suffixIcon: SbIcons.diameter,
                  onChanged: controller.updateDiameter,
                  errorText: dError,
                ),
              ),
              SizedBox(
                width: 160,
                child: AppNumberField(
                  label: EngineeringTerms.wastePercent,
                  suffixIcon: SbIcons.percent,
                  onChanged: controller.updateWaste,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? AppStrings.calculating : AppStrings.calculate,
                icon: state.isLoading ? null : SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: AppTextStyles.body(context).copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],

          if (state.result != null) ...[
            buildResultCard(),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
        ],
      ),
    );
  }
}
