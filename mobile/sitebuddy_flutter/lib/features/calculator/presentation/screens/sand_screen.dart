import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/calculator/application/controllers/sand_controller.dart';

/// SCREEN: SandScreen
/// PURPOSE: UI for calculating sand volume based on area dimensions and rates.
class SandScreen extends ConsumerWidget {
  const SandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(sandControllerProvider);
    final controller = ref.read(sandControllerProvider.notifier);
    final colorScheme = theme.colorScheme;

    final lError = state.error?.toLowerCase().contains('length') == true ? state.error : null;
    final wError = state.error?.toLowerCase().contains('width') == true ? state.error : null;
    final dError = state.error?.toLowerCase().contains('depth') == true ? state.error : null;

    final isValid = state.length != null && state.width != null && state.depth != null;

    Widget buildResultCard() {
      final res = state.result!;
      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              EngineeringTerms.resultSummary,
              style: TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            const Divider(),
            const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
            Text(
              '${res.dryVolume.toStringAsFixed(2)} m³',
              style: TextStyle(
                fontSize: 24, // Preserving headline-like size
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            SbListItemTile(
              title: EngineeringTerms.wetVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.sandCubicFeet,
              onTap: () {}, // Detail view entry
              trailing: Text(
                res.cubicFeet.toStringAsFixed(2),
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            if (res.totalCost != null) ...[
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
              const Divider(),
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
              SbListItemTile(
                title: EngineeringTerms.estimatedCost,
                onTap: () {}, // Detail view entry
                trailing: Text(
                  '\$ ${res.totalCost!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return AppScreenWrapper(
      title: EngineeringTerms.sandQuantityEstimator,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.volumeAndRate,
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md / 1.5), // Replaced AppLayout.vGap12 (8px approx)

          AppNumberField(
            label: EngineeringTerms.length,
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: AppSpacing.md / 1.5), // Replaced AppLayout.vGap12

          AppNumberField(
            label: EngineeringTerms.width,
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: AppSpacing.md / 1.5), // Replaced AppLayout.vGap12

          AppNumberField(
            label: EngineeringTerms.depth,
            suffixIcon: SbIcons.height,
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: AppSpacing.md / 1.5), // Replaced AppLayout.vGap12

          AppNumberField(
            label: EngineeringTerms.ratePerUnit,
            suffixIcon: SbIcons.payments,
            onChanged: controller.updateRate,
          ),

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: 'Clear All',
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? AppStrings.calculating : AppStrings.calculate,
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          if (state.error != null && lError == null && wError == null && dError == null) ...[
            SbCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md), // Replaced AppLayout.paddingMedium
                child: Text(
                  state.error!,
                  style: TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
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
