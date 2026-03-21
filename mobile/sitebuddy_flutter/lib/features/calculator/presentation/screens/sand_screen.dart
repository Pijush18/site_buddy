import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/calculator/application/controllers/sand_controller.dart';

/// SCREEN: SandScreen
/// PURPOSE: UI for calculating sand volume based on area dimensions and rates.
class SandScreen extends ConsumerWidget {
  const SandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sandControllerProvider);
    final controller = ref.read(sandControllerProvider.notifier);

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
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SbSpacing.lg),
            const Divider(),
            SizedBox(height: SbSpacing.sm),
            Text(
              '${res.dryVolume.toStringAsFixed(2)} m³',
              style: Theme.of(context).textTheme.titleLarge!,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SbSpacing.lg),
            SbListItemTile(
              title: EngineeringTerms.wetVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.sandCubicFeet,
              onTap: () {}, // Detail view entry
              trailing: Text(
                res.cubicFeet.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            if (res.totalCost != null) ...[
              SizedBox(height: SbSpacing.sm),
              const Divider(),
              SizedBox(height: SbSpacing.sm),
              SbListItemTile(
                title: EngineeringTerms.estimatedCost,
                onTap: () {}, // Detail view entry
                trailing: Text(
                  '\$ ${res.totalCost!.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return SbPage.scaffold(
      title: EngineeringTerms.sandQuantityEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.volumeAndRate,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SbSpacing.lg / 1.5),

          SbInput(
            label: EngineeringTerms.length,
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          SizedBox(height: SbSpacing.lg / 1.5),

          SbInput(
            label: EngineeringTerms.width,
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          SizedBox(height: SbSpacing.lg / 1.5),

          SbInput(
            label: EngineeringTerms.depth,
            suffixIcon: const Icon(SbIcons.height),
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          SizedBox(height: SbSpacing.lg / 1.5),

          SbInput(
            label: EngineeringTerms.ratePerUnit,
            suffixIcon: const Icon(SbIcons.payments),
            onChanged: controller.updateRate,
          ),

          SizedBox(height: SbSpacing.xxl),

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

          SizedBox(height: SbSpacing.xxl),

          if (state.error != null && lError == null && wError == null && dError == null) ...[
            SbCard(
              child: Padding(
                padding: const EdgeInsets.all(SbSpacing.lg),
                child: Text(
                  state.error!,
                  style: Theme.of(context).textTheme.bodyLarge!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: SbSpacing.xxl),
          ],

          if (state.result != null) ...[
            buildResultCard(),
            SizedBox(height: SbSpacing.xxl),
          ],
        ],
      ),
    );
  }
}











